extends "res://tests/test_base.gd"
## Speichern/Laden-Rundlauf, atomarer Ablauf, Backup-Kette, Migration (7, 9.4).

const SaveManagerScript = preload("res://scenes/autoload/save_manager.gd")
const DIR := "user://test_saves"


func _paths() -> Array:
	DirAccess.make_dir_recursive_absolute(DIR)
	return [DIR + "/save.json", DIR + "/save.json.tmp", DIR + "/backup.json", DIR + "/unused.json"]


func _cleanup() -> void:
	for p in _paths():
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(p)


func test_job_roundtrip() -> void:
	var j := JobInstance.new()
	j.uid = "gen_e2_0012"
	j.template_id = "coach_axle"
	j.customer_id = "coachbuilder_york"
	j.quantity = 2
	j.form_points = 2600
	j.reward_base_pence = 104
	j.elapsed_s = 31.5
	j.reset_pieces(20.0)
	j.pieces[0].progress = 1300.0
	j.pieces[0].location = "done"
	j.pieces[0].damage = 0.04
	j.pieces[1].temp = 912.0
	j.pieces[1].location = "anvil"
	var text := JSON.stringify(j.to_dict())
	var back := JobInstance.from_dict(JSON.parse_string(text))
	assert_eq(back.to_dict(), j.to_dict(), "Rundlauf über JSON")
	assert_eq(typeof(back.form_points), TYPE_INT, "Ganzzahlen nach JSON (float) wieder int")
	assert_eq(back.time_limit_s, -1.0, "null-Zeitlimit")


func test_atomic_write_and_backup() -> void:
	_cleanup()
	var p := _paths()
	var d1 := {"meta": {"save_version": 2}, "economy": {"total_pence": 1}}
	var d2 := {"meta": {"save_version": 2}, "economy": {"total_pence": 2}}
	assert_true(SaveManagerScript.write_atomic(d1, p[0], p[1], p[2]))
	assert_true(not FileAccess.file_exists(p[1]), "keine .tmp-Datei übrig")
	assert_true(SaveManagerScript.write_atomic(d2, p[0], p[1], p[2]))
	var main: Dictionary = SaveManagerScript._read_json(p[0])
	var backup: Dictionary = SaveManagerScript._read_json(p[2])
	assert_eq(int(main["economy"]["total_pence"]), 2)
	assert_eq(int(backup["economy"]["total_pence"]), 1, "vorheriger Stand als Backup")
	_cleanup()


func test_corrupt_detected() -> void:
	_cleanup()
	var p := _paths()
	var f := FileAccess.open(p[0], FileAccess.WRITE)
	f.store_string("{\"meta\": {\"save_ver")
	f.close()
	assert_true(SaveManagerScript._read_json(p[0]).is_empty(), "abgebrochene Datei wird erkannt")
	_cleanup()


func test_load_chain_fallback() -> void:
	# Simuliert einen abgebrochenen Schreibvorgang: Hauptdatei kaputt, Backup gültig.
	_cleanup()
	var p := _paths()
	var good := {"meta": {"save_version": 2}, "economy": {"total_pence": 7}}
	assert_true(SaveManagerScript.write_atomic(good, p[2], p[1], DIR + "/unused.json"))
	var f := FileAccess.open(p[0], FileAccess.WRITE)
	f.store_string("{\"meta\": {")
	f.close()
	var res: Dictionary = SaveManagerScript.read_chain([[p[0], "ok"], [p[2], "backup"], [p[1], "tmp"]])
	assert_eq(res["status"], "backup", "Backup wird geladen")
	assert_eq(int(res["data"]["economy"]["total_pence"]), 7)
	var newer := {"meta": {"save_version": 99}}
	SaveManagerScript.write_atomic(newer, p[0], p[1], DIR + "/unused.json")
	res = SaveManagerScript.read_chain([[p[0], "ok"], [p[2], "backup"]])
	assert_eq(res["status"], "newer", "neuere Version wird nicht geladen")
	_cleanup()


func test_migration_v1() -> void:
	var v1 := {
		"meta": {"save_version": 1},
		"economy": {"total_pence": 500},
		"equipment": {"equipped_hammer_id": "hammer_stone", "owned_hammer_ids": ["hammer_wood", "hammer_stone"],
			"equipped_forge_id": "furnace_blast", "owned_forge_ids": ["furnace_clay", "furnace_blast"],
			"active_machine_id": "machine_steam_drop", "owned_machine_ids": ["machine_steam_drop"]},
		"progress": {"current_epoch": 3},
		"active_job": {"uid": "x"},
	}
	var d := SaveManagerScript.migrate(v1)
	assert_eq(int(d["meta"]["save_version"]), 2)
	assert_eq(d["equipment"]["equipped_hammer_id"], "hammer_cross_peen")
	assert_eq(d["equipment"]["owned_hammer_ids"], ["hammer_hand", "hammer_cross_peen"])
	assert_eq(d["equipment"]["equipped_forge_id"], "forge_double_bellows")
	assert_eq(d["equipment"]["active_machine_id"], "machine_steam_helve")
	assert_eq(d["active_job"], null, "laufende v1-Aufträge werden neu erzeugt")
	assert_eq(int(d["progress"]["jobs_completed_in_epoch"]), 0)


func test_gamestate_roundtrip() -> void:
	# Kompletter Spielstand über GameManager (Autoload) – ohne in die echte Datei zu schreiben.
	var gm = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameManager")
	if gm == null:
		return
	gm.new_game()
	gm.total_pence = 2946
	gm.lifetime_pence = 9120
	gm.buy_hammer("hammer_cross_peen")
	gm.upgrade_hammer("hammer_cross_peen")
	gm.accept_offer(0)
	gm.sim.load_raw()
	gm.sim.step(1.0)
	var d1: Dictionary = gm.to_save_dict()
	var text := JSON.stringify(d1)
	gm.new_game()
	gm.load_from_dict(SaveManagerScript.migrate(JSON.parse_string(text)))
	var d2: Dictionary = gm.to_save_dict()
	d1["meta"].erase("last_saved_at")
	d2["meta"].erase("last_saved_at")
	assert_eq(JSON.stringify(d2["economy"]), JSON.stringify(d1["economy"]), "Geld")
	assert_eq(JSON.stringify(d2["equipment"]), JSON.stringify(d1["equipment"]), "Ausrüstung")
	assert_eq(JSON.stringify(d2["progress"]), JSON.stringify(d1["progress"]), "Fortschritt inkl. Generator-Zustand")
	assert_eq(JSON.stringify(d2["job_offers"]), JSON.stringify(d1["job_offers"]), "Angebote")
	assert_eq(JSON.stringify(d2["active_job"]), JSON.stringify(d1["active_job"]), "aktiver Auftrag mit Stücken")
	assert_eq(typeof(gm.total_pence), TYPE_INT, "Geld bleibt Ganzzahl")
	gm.end_session()


func test_unknown_ids_ignored() -> void:
	var gm = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameManager")
	if gm == null:
		return
	gm.new_game()
	var d: Dictionary = gm.to_save_dict()
	d["equipment"]["owned_hammer_ids"].append("hammer_mithril")
	d["progress"]["completed_milestone_ids"].append("ms_removed")
	gm.load_from_dict(d)
	assert_true(not gm.owned_hammer_ids.has("hammer_mithril"), "unbekannte ID ignoriert")
	assert_true(not gm.completed_milestone_ids.has("ms_removed"))
	gm.end_session()


func test_offline_clock_guard() -> void:
	var gm = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameManager")
	if gm == null:
		return
	gm.new_game()
	gm.hired_ids.append("staff_journeyman")
	var before: int = gm.total_pence
	gm.compute_offline(int(Time.get_unix_time_from_system()) + 3600)
	assert_eq(gm.total_pence, before, "Uhr zurückgestellt: keine Offline-Einnahmen")
	gm.compute_offline(int(Time.get_unix_time_from_system()) - 100000)
	var max_gain := int(floor(gm.journeyman_rate() * gm.cfg.offline_max_s))
	assert_eq(gm.total_pence - before, max_gain, "höchstens 8 Stunden")
	gm.end_session()


func test_debug_set_epoch() -> void:
	var gm = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameManager")
	if gm == null:
		return
	gm.new_game()
	gm.debug_set_epoch(4, 1.0)
	assert_eq(gm.current_epoch, 4)
	assert_eq(gm.jobs_completed_in_epoch, gm.epoch_job_count(4) - 1, "Ende der Epoche")
	for ms in gm.milestones_by_epoch[3]:
		assert_true(gm.completed_milestone_ids.has(ms.id), "Meilensteine früherer Epochen erledigt")
	var fm: MilestoneData = gm.final_milestone(4)
	assert_true(not gm.completed_milestone_ids.has(fm.id), "Abschluss-Meilenstein noch offen")
	assert_eq(gm.open_milestone(), fm, "Abschluss-Meilenstein wird angeboten")
	assert_eq(gm.equipped_forge_id, "forge_double_bellows", "Esse der Epoche")
	assert_eq(gm.equipped_hammer_id, "hammer_crucible", "Hammer der Epoche")
	assert_true(gm.is_hired("staff_journeyman"), "Personal der Epoche")
	gm.debug_set_epoch(2, 0.0)
	assert_eq(gm.jobs_completed_in_epoch, 0, "Anfang der Epoche")
	assert_near(gm.current_complexity(), 0.0, 0.0001)
	gm.end_session()


func test_debug_finish_job() -> void:
	var gm = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameManager")
	if gm == null:
		return
	gm.new_game()
	assert_eq(gm.accept_offer(0), "")
	gm.debug_finish_job()
	assert_eq(gm.active_job, null, "Auftrag abgeschlossen")
	assert_eq(int(gm.stats["jobs_completed"]), 1)
	assert_eq(int(gm.stats["stars_total"]), 3, "mit drei Sternen")
	assert_true(gm.total_pence > 0, "Lohn gutgeschrieben")
	gm.end_session()


func test_test_slots_roundtrip() -> void:
	var gm = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameManager")
	var sm = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("SaveManager")
	if gm == null or sm == null:
		return
	gm.new_game()
	gm.debug_set_epoch(5, 0.5)
	gm.total_pence = 12345
	assert_true(sm.save_test_slot(5), "Test-Spielstand gespeichert")
	var info: Dictionary = sm.test_slot_info(5)
	assert_eq(info["epoch"], 5)
	assert_eq(info["pence"], 12345)
	gm.new_game()
	assert_eq(gm.current_epoch, 1)
	assert_true(sm.load_test_slot(5), "Test-Spielstand geladen")
	assert_eq(gm.current_epoch, 5, "Epoche wiederhergestellt")
	assert_eq(gm.total_pence, 12345, "Geld wiederhergestellt")
	sm.delete_test_slot(5)
	assert_true(sm.test_slot_info(5).is_empty(), "Test-Spielstand gelöscht")
	gm.end_session()


func test_repeat_job() -> void:
	var gm = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameManager")
	if gm == null:
		return
	gm.new_game()
	var first: JobInstance = null
	for o in gm.job_offers:
		if not o.is_milestone():
			first = o
			break
	gm.accept_offer(gm.job_offers.find(first))
	var done: JobInstance = gm.active_job
	assert_true(not gm.can_repeat_job(done), "nicht wiederholbar, solange er läuft")
	gm.debug_finish_job()
	assert_true(gm.can_repeat_job(done), "nach Abschluss wiederholbar")
	assert_eq(gm.repeat_job(done), "", "Wiederholung angenommen")
	var j: JobInstance = gm.active_job
	assert_true(j != null and j.uid != done.uid, "neuer Auftrag mit eigener Kennung")
	assert_eq(j.template_id, done.template_id, "gleiches Werkstück")
	assert_eq(j.quantity, done.quantity, "gleiche Menge")
	assert_eq(j.reward_base_pence, done.reward_base_pence, "gleicher Lohn")
	assert_eq(j.pieces_done(), 0, "Stücke zurückgesetzt")
	assert_eq(gm.job_offers.size(), gm.offers_count(), "Angebote wieder vollständig")
	gm.end_session()
