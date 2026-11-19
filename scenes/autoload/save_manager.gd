extends Node
## SaveManager (Lastenheft 7, 8.2): atomares Speichern und Laden, Backup-Kette,
## Migration, Autosave-Timer und Sonderbehandlung der Web-Version.

const SAVE_VERSION := 2
const SAVE_PATH := "user://savegame.json"
const TMP_PATH := "user://savegame.json.tmp"
const BACKUP_PATH := "user://savegame_backup.json"

## Ergebnis des letzten Ladeversuchs: "ok", "backup", "tmp", "none", "corrupt", "newer"
var last_load_status: String = "none"
## Wenn ein Spielstand einer neueren Spielversion gefunden wurde, wird nie automatisch gespeichert.
var save_blocked: bool = false

var _autosave_timer: float = 0.0
var _save_requested: bool = false
var _js_visibility_cb = null
var _js_import_cb = null

signal saved()
signal save_failed(reason: String)
signal imported(ok: bool)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().set_auto_accept_quit(false)
	_setup_web_hooks()


func _process(delta: float) -> void:
	if not GameManager.in_game:
		return
	_autosave_timer += delta
	if _save_requested or _autosave_timer >= GameManager.cfg.autosave_interval_s:
		_save_requested = false
		_autosave_timer = 0.0
		save_game()


## Autosave nach Auftrag, Kauf, Epochenwechsel (am Ende des Frames gebündelt).
func request_save() -> void:
	_save_requested = true


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			if GameManager.in_game:
				save_game()
			get_tree().quit()
		NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_WM_GO_BACK_REQUEST:
			if GameManager.in_game:
				save_game()


# ================================================================== Speichern (7.2)

func save_game() -> bool:
	if save_blocked:
		return false
	var data := GameManager.to_save_dict()
	var ok := write_atomic(data, SAVE_PATH, TMP_PATH, BACKUP_PATH)
	if ok:
		saved.emit()
	else:
		save_failed.emit("write")
	return ok


## Atomarer Ablauf: .tmp schreiben → .tmp prüfen → alte Datei als Backup → .tmp umbenennen.
static func write_atomic(data: Dictionary, path: String, tmp_path: String, backup_path: String) -> bool:
	var text := JSON.stringify(data, "\t")
	var f := FileAccess.open(tmp_path, FileAccess.WRITE)
	if f == null:
		push_error("Speichern: %s nicht beschreibbar (%s)" % [tmp_path, FileAccess.get_open_error()])
		return false
	f.store_string(text)
	f.flush()
	f.close()
	# 2. Prüfen
	var check := _read_json(tmp_path)
	if check.is_empty():
		push_error("Speichern: Prüfung der Zwischendatei fehlgeschlagen")
		return false
	# 3. Backup
	if FileAccess.file_exists(path):
		if FileAccess.file_exists(backup_path):
			DirAccess.remove_absolute(backup_path)
		var err_copy := DirAccess.copy_absolute(path, backup_path)
		if err_copy != OK:
			push_warning("Speichern: Backup fehlgeschlagen (%s)" % err_copy)
	# 4. Umbenennen
	var err := DirAccess.rename_absolute(tmp_path, path)
	if err != OK:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(path)
		err = DirAccess.rename_absolute(tmp_path, path)
	return err == OK


static func _read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var text := FileAccess.get_file_as_string(path)
	if text.is_empty():
		return {}
	var parsed = JSON.parse_string(text)
	if parsed is Dictionary and parsed.has("meta"):
		return parsed
	return {}


# ================================================================== Laden (7.2/7.6)

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH) or FileAccess.file_exists(BACKUP_PATH) or FileAccess.file_exists(TMP_PATH)


## Lädt savegame.json → Backup → .tmp. Gibt das migrierte Dictionary zurück (leer = kein Spielstand).
func read_best_save() -> Dictionary:
	save_blocked = false
	var res := read_chain([[SAVE_PATH, "ok"], [BACKUP_PATH, "backup"], [TMP_PATH, "tmp"]])
	last_load_status = str(res["status"])
	if last_load_status == "newer":
		save_blocked = true
		return {}
	return res["data"]


## Liest die erste gültige Datei der Kette. Ergebnis: {"status": ..., "data": Dictionary (migriert)}
static func read_chain(order: Array) -> Dictionary:
	var any_file := false
	for entry in order:
		var path: String = entry[0]
		if not FileAccess.file_exists(path):
			continue
		any_file = true
		var d := _read_json(path)
		if d.is_empty():
			continue
		var version := int(d.get("meta", {}).get("save_version", 1))
		if version > SAVE_VERSION:
			return {"status": "newer", "data": {}}
		return {"status": entry[1], "data": migrate(d)}
	return {"status": "corrupt" if any_file else "none", "data": {}}


func load_game() -> bool:
	var d := read_best_save()
	if d.is_empty():
		return false
	GameManager.load_from_dict(d)
	return true


func start_new_game() -> void:
	save_blocked = false
	GameManager.new_game()
	save_game()


## Schrittweise Migration bis SAVE_VERSION.
static func migrate(d: Dictionary) -> Dictionary:
	if not (d.get("meta", null) is Dictionary):
		d["meta"] = {}
	var meta: Dictionary = d["meta"]
	var v := int(meta.get("save_version", 1))
	while v < SAVE_VERSION:
		match v:
			1:
				d = migrate_v1_to_v2(d)
		v += 1
	d["meta"]["save_version"] = SAVE_VERSION
	return d


## Version 1 (Lastenheft v1.0) kannte andere Werkzeug- und Ofen-IDs und keine Sterne/Gefügeschäden.
static func migrate_v1_to_v2(d: Dictionary) -> Dictionary:
	var hammer_map := {
		"hammer_wood": "hammer_hand", "hammer_wooden_mallet": "hammer_hand",
		"hammer_stone": "hammer_cross_peen", "hammer_cast_iron": "hammer_steel_faced",
		"hammer_steel": "hammer_crucible",
	}
	var forge_map := {
		"furnace_clay": "forge_clay", "furnace_blast": "forge_double_bellows",
		"furnace_melting": "forge_coke", "furnace_brick": "forge_brick",
	}
	var machine_map := {"machine_steam_drop": "machine_steam_helve", "machine_hydraulic_drop": "machine_steam_helve"}
	var eq: Dictionary = d.get("equipment", {})
	eq["equipped_hammer_id"] = hammer_map.get(str(eq.get("equipped_hammer_id", "hammer_hand")), eq.get("equipped_hammer_id", "hammer_hand"))
	var owned: Array = []
	for h in eq.get("owned_hammer_ids", []):
		var nid = hammer_map.get(str(h), str(h))
		if not owned.has(nid):
			owned.append(nid)
	eq["owned_hammer_ids"] = owned
	if not eq.has("hammer_levels"):
		eq["hammer_levels"] = {}
	eq["equipped_forge_id"] = forge_map.get(str(eq.get("equipped_forge_id", "forge_clay")), eq.get("equipped_forge_id", "forge_clay"))
	var forges: Array = []
	for f in eq.get("owned_forge_ids", []):
		var fid = forge_map.get(str(f), str(f))
		if not forges.has(fid):
			forges.append(fid)
	eq["owned_forge_ids"] = forges
	var machines: Array = []
	for m in eq.get("owned_machine_ids", []):
		var mid = machine_map.get(str(m), str(m))
		if not machines.has(mid):
			machines.append(mid)
	eq["owned_machine_ids"] = machines
	if eq.get("active_machine_id", null) != null:
		eq["active_machine_id"] = machine_map.get(str(eq["active_machine_id"]), eq["active_machine_id"])
	d["equipment"] = eq
	if not d.has("staff"):
		d["staff"] = {"hired_ids": [], "apprentice_thresholds": {"to_forge_below": 750, "to_anvil_at": 1050}}
	# v1 skalierte über alle 300 Aufträge: angebotene und laufende Aufträge werden neu erzeugt.
	d["job_offers"] = []
	d["active_job"] = null
	var pr: Dictionary = d.get("progress", {})
	if not pr.has("jobs_completed_in_epoch"):
		pr["jobs_completed_in_epoch"] = 0
	d["progress"] = pr
	if not d.has("stats"):
		d["stats"] = {}
	return d


# ================================================================== Web-Version (7.4)

func _setup_web_hooks() -> void:
	if not OS.has_feature("web"):
		return
	_js_visibility_cb = JavaScriptBridge.create_callback(_on_js_visibility)
	var doc = JavaScriptBridge.get_interface("document")
	if doc != null:
		doc.addEventListener("visibilitychange", _js_visibility_cb)


func _on_js_visibility(_args) -> void:
	var hidden = JavaScriptBridge.eval("document.hidden", true)
	if hidden and GameManager.in_game:
		save_game()


## Export als Datei: im Browser per Download, auf dem Desktop über einen Pfad.
func export_save_text() -> String:
	if GameManager.in_game:
		save_game()
	return FileAccess.get_file_as_string(SAVE_PATH)


func export_to_browser() -> void:
	var text := export_save_text()
	if text.is_empty():
		return
	JavaScriptBridge.download_buffer(text.to_utf8_buffer(), "forge_workshop_save.json", "application/json")


func export_to_path(path: String) -> bool:
	var text := export_save_text()
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(text)
	f.close()
	return true


## Import: Text prüfen, als aktuellen Spielstand übernehmen und laden.
func import_text(text: String) -> bool:
	var parsed = JSON.parse_string(text)
	if not (parsed is Dictionary) or not parsed.has("meta"):
		imported.emit(false)
		return false
	var version := int(parsed.get("meta", {}).get("save_version", 1))
	if version > SAVE_VERSION:
		imported.emit(false)
		return false
	var d := migrate(parsed)
	save_blocked = false
	GameManager.load_from_dict(d)
	save_game()
	imported.emit(true)
	return true


func import_from_path(path: String) -> bool:
	if not FileAccess.file_exists(path):
		imported.emit(false)
		return false
	return import_text(FileAccess.get_file_as_string(path))


func import_from_browser() -> void:
	if not OS.has_feature("web"):
		return
	_js_import_cb = JavaScriptBridge.create_callback(_on_js_import)
	var window = JavaScriptBridge.get_interface("window")
	window.godotForgeImport = _js_import_cb
	JavaScriptBridge.eval("""
		(function () {
			var input = document.createElement('input');
			input.type = 'file';
			input.accept = '.json,application/json';
			input.onchange = function (e) {
				var file = e.target.files[0];
				if (!file) { return; }
				var reader = new FileReader();
				reader.onload = function () { window.godotForgeImport(reader.result); };
				reader.readAsText(file);
			};
			input.click();
		})();
	""", true)


func _on_js_import(args) -> void:
	if args.size() > 0:
		import_text(str(args[0]))
