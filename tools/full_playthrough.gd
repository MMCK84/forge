extends Node
## Durchspiel-Test: Der Referenzspieler spielt das echte Spiel über den GameManager von Epoche 1
## bis zum Finale (Angebote, Lehrzeit, Meilensteine, Meisterstücke, Laden, Personal, Einrichtung,
## Umzug) und danach einige Aufträge im Freien Spiel. Prüft je Epoche, ob alles weiterläuft,
## und gibt eine Übersicht aus.
##
##   godot --headless --path . res://tools/full_playthrough.tscn [-- --seed=7]

const ReferencePlayer = preload("res://scripts/reference_player.gd")
const Economy = preload("res://scripts/economy.gd")
const Furnishings = preload("res://scripts/furnishings.gd")
const Masterpieces = preload("res://scripts/masterpieces.gd")
const SaveManagerScript = preload("res://scenes/autoload/save_manager.gd")

const DT := 0.05
const JOB_LIMIT_S := 1500.0
const MAX_JOBS := 1200

var gm
var problems: Array = []
var hints: Array = []
var settlements: Array = []
var ep: Dictionary = {}


func _ready() -> void:
	SaveManager.save_blocked = true
	gm = GameManager
	var seed_value := 7
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--seed="):
			seed_value = int(a.substr(7))
	gm.new_game()
	gm.end_session()
	gm.generator.set_seed(seed_value)
	gm.generator_seed = seed_value
	gm.job_offers = []
	gm.refresh_offers()
	gm.sim.auto_force = true
	# Ohne Tonausgabe (headless) würden sich die Klang-Wiedergaben im Zeitraffer stauen
	if gm.sim_event.is_connected(SoundManager._on_sim_event):
		gm.sim_event.disconnect(SoundManager._on_sim_event)
	gm.hint_requested.connect(func(id: String) -> void:
		hints.append([gm.current_epoch, gm.jobs_completed_in_epoch, id])
		gm.mark_hint_seen(id))
	gm.settlement_ready.connect(func(r: Dictionary) -> void: settlements.append(r))
	print("Durchspiel-Test (Seed %d)" % seed_value)
	print("Ep | Spielzeit | Aufträge | Meilensteine | Meisterstück-Teile | Siegel B/S/G | Einrichtung | Ausschuss | Sterne Ø | Geld am Ende | Ausrüstung")
	var total_jobs := 0
	var finale := false
	var epoch_start_s := 0.0
	_reset_ep()
	while total_jobs < MAX_JOBS:
		_shop()
		# Umzug, sobald möglich
		if gm.can_advance_epoch() and gm.can_afford(gm.next_epoch_fee()):
			_epoch_report(epoch_start_s)
			_check_save_roundtrip()
			var e_before: int = gm.current_epoch
			if not gm.advance_epoch():
				_problem("Umzug nach Epoche %d nicht möglich" % (e_before + 1))
				break
			epoch_start_s = gm.playtime_seconds
			_reset_ep()
			_check_offers_after_move()
			continue
		var idx := _pick_offer()
		if idx < 0:
			_problem("Epoche %d, Auftrag %d: kein annehmbares Angebot (%s)" % [gm.current_epoch, gm.jobs_completed_in_epoch, _offer_issues()])
			gm.debug_reroll_now()
			idx = _pick_offer()
			if idx < 0:
				break
		var err: String = gm.accept_offer(idx)
		if err != "":
			_problem("Annehmen fehlgeschlagen: " + err)
			break
		var j: JobInstance = gm.active_job
		var t := _play_active()
		total_jobs += 1
		ep["jobs"] += 1
		if OS.get_cmdline_user_args().has("--mem") and total_jobs % 20 == 0:
			print("  [%d] Speicher %.0f MB, Objekte %d, Ressourcen %d" % [total_jobs, OS.get_static_memory_usage() / 1048576.0,
				Performance.get_monitor(Performance.OBJECT_COUNT), Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT)])

		if t >= JOB_LIMIT_S:
			_problem("Epoche %d: Auftrag hängt (%s, %s, Menge %d, %.0f s)" % [gm.current_epoch, j.template_id, j.category, j.quantity, t])
			gm.abort_job()
			continue
		var r: Dictionary = settlements[settlements.size() - 1] if not settlements.is_empty() else {}
		ep["stars"] += int(r.get("stars", 0))
		if j.is_masterpiece():
			ep["mp_parts"] += 1
			if not bool(r.get("masterpiece_passed", true)):
				ep["mp_failed"] += 1
		if bool(r.get("game_done", false)):
			finale = true
			_epoch_report(epoch_start_s)
			break
	if not finale:
		_problem("Finale nicht erreicht (Epoche %d nach %d Aufträgen)" % [gm.current_epoch, total_jobs])
	else:
		# Freies Spiel: einige Aufträge
		var fp_ok := 0
		for k in 5:
			var idx2 := _pick_offer()
			if idx2 < 0 or gm.accept_offer(idx2) != "":
				_problem("Freies Spiel: kein Auftrag annehmbar")
				break
			if _play_active() < JOB_LIMIT_S:
				fp_ok += 1
		print("Freies Spiel: %d/5 Aufträge erledigt, free_play=%s" % [fp_ok, str(gm.free_play)])
	print("Gesamt: %d Aufträge, Spielzeit %.2f h, Geld %s, Meisterstücke %d, längste Serie %d" % [total_jobs, gm.playtime_seconds / 3600.0,
		Economy.format_lsd(gm.total_pence, "de"), int(gm.stats.get("masterpieces", 0)), int(gm.stats.get("best_streak", 0))])
	print("Hinweisfenster (Epoche/Auftrag/ID): ", hints)
	if problems.is_empty():
		print("ERGEBNIS: keine Probleme")
	else:
		print("ERGEBNIS: %d Probleme" % problems.size())
		for p in problems:
			print("  - " + p)
	get_tree().quit(0 if problems.is_empty() else 1)


func _reset_ep() -> void:
	ep = {"jobs": 0, "stars": 0, "mp_parts": 0, "mp_failed": 0}


func _problem(text: String) -> void:
	problems.append(text)
	print("PROBLEM: " + text)


## Spielt den aktiven Auftrag mit dem Referenzspieler zu Ende. Gibt die Dauer zurück.
func _play_active() -> float:
	var bot = ReferencePlayer.new(gm.cfg, gm.sim)
	var t := 0.0
	gm._pending_finish = false
	while gm.active_job != null and t < JOB_LIMIT_S:
		bot.act(DT)
		gm.sim.step(DT)
		gm.playtime_seconds += DT
		gm._step_journeyman(DT)
		t += DT
		if gm._pending_finish:
			gm._pending_finish = false
			gm._complete_active_job()
	return t


## Meilenstein zuerst, sonst das erste Angebot ohne Hindernis.
func _pick_offer() -> int:
	for i in gm.job_offers.size():
		var o: JobInstance = gm.job_offers[i]
		if o.is_milestone():
			if gm.job_requirement_issue(o) == "":
				return i
			_problem("Epoche %d: Meilenstein %s nicht annehmbar: %s" % [gm.current_epoch, o.uid, gm.job_requirement_issue(o)])
	for i in gm.job_offers.size():
		if gm.job_requirement_issue(gm.job_offers[i]) == "":
			return i
	return -1


func _offer_issues() -> String:
	var a: PackedStringArray = []
	for o in gm.job_offers:
		a.append("%s:%s" % [o.template_id, gm.job_requirement_issue(o)])
	return ", ".join(a)


## Einkaufen wie der Balancing-Spieler: bessere Ausrüstung, Personal (ohne Gesellen), Einrichtung
## und Verbesserungen, ohne die Meistergebühr anzutasten.
func _shop() -> void:
	var e: int = gm.current_epoch
	var fee: int = gm.next_epoch_fee() if e < gm.EPOCH_COUNT else 0
	var changed := true
	while changed:
		changed = false
		for h in _sorted(gm.hammers.values()):
			if h.tier > gm.current_hammer().tier and h.min_epoch <= e and gm.can_afford(h.price):
				if gm.buy_hammer(h.id):
					gm.equip_hammer(h.id)
					changed = true
		for f in _sorted(gm.forges.values()):
			if f.tier > gm.current_forge().tier and f.min_epoch <= e and gm.can_afford(f.price):
				if gm.buy_forge(f.id):
					gm.equip_forge(f.id)
					changed = true
		for s in gm.staff.values():
			if s.id != "staff_journeyman" and not gm.is_hired(s.id) and s.min_epoch <= e and gm.can_afford(s.price):
				if gm.hire(s.id):
					changed = true
		for m in _sorted(gm.machines.values()):
			var cur = gm.current_machine()
			if (cur == null or m.tier > cur.tier) and m.min_epoch <= e and gm.can_afford(m.price):
				if gm.buy_machine(m.id):
					gm.activate_machine(m.id)
					changed = true
		for sl in Furnishings.slots_by_price():
			if gm.is_furnished(sl):
				continue
			if gm.total_pence - gm.furnish_price(sl) >= fee:
				if gm.buy_furnishing(sl):
					changed = true
			break
		var hid: String = gm.current_hammer().id
		var c: int = gm.next_upgrade_cost(hid)
		if c > 0 and gm.total_pence - c >= fee:
			if gm.upgrade_hammer(hid):
				changed = true


func _sorted(arr: Array) -> Array:
	var a := arr.duplicate()
	a.sort_custom(func(x, y): return x.tier < y.tier)
	return a


func _epoch_report(start_s: float) -> void:
	var e: int = gm.current_epoch
	var ms_all: Array = gm.milestones_by_epoch.get(e, [])
	var ms_done := 0
	for ms in ms_all:
		if gm.completed_milestone_ids.has(ms.id):
			ms_done += 1
	var seals := [0, 0, 0, 0]
	for id in gm.items:
		if gm.items[id].epoch == e:
			seals[gm.mastery_level(id)] += 1
	var fm: MilestoneData = gm.final_milestone(e)
	var parts := Masterpieces.part_count(fm.id) if fm != null else 0
	var furn := 0
	for sl in Furnishings.SLOTS:
		if gm.is_furnished(sl):
			furn += 1
	var avg := float(ep["stars"]) / maxf(1.0, float(ep["jobs"]))
	var mach = gm.current_machine()
	print("   Speicher: %.0f MB" % (OS.get_static_memory_usage() / 1048576.0))
	print("%2d | %6.1f min | %3d | %d/%d | %d/%d%s | %d/%d/%d | %d/5 | %d | %.2f | %s | %s +%d, %s%s%s" % [
		e, (gm.playtime_seconds - start_s) / 60.0, ep["jobs"], ms_done, ms_all.size(),
		ep["mp_parts"], parts, (" (%d nicht bestanden)" % ep["mp_failed"]) if ep["mp_failed"] > 0 else "",
		seals[1], seals[2], seals[3], furn, int(gm.stats.get("pieces_ruined", 0)), avg,
		Economy.format_lsd(gm.total_pence, "de"), gm.current_hammer().id, gm.hammer_level(gm.current_hammer().id),
		gm.current_forge().id, (", " + mach.id) if mach != null else "", (", Personal " + ",".join(gm.hired_ids)) if not gm.hired_ids.is_empty() else ""])
	if ms_done < ms_all.size():
		_problem("Epoche %d: nur %d/%d Meilensteine" % [e, ms_done, ms_all.size()])
	if ep["mp_parts"] < parts:
		_problem("Epoche %d: Meisterstück unvollständig (%d/%d Teile)" % [e, ep["mp_parts"], parts])


## Spielstand speichern und wieder laden: Fortschritt und Geld müssen gleich bleiben.
func _check_save_roundtrip() -> void:
	var d1: Dictionary = gm.to_save_dict()
	var text := JSON.stringify(d1)
	gm.load_from_dict(SaveManagerScript.migrate(JSON.parse_string(text)))
	gm.end_session()
	var d2: Dictionary = gm.to_save_dict()
	for k in ["economy", "equipment", "progress", "staff"]:
		if JSON.stringify(d1[k]) != JSON.stringify(d2[k]):
			_problem("Epoche %d: Speichern/Laden ändert '%s'" % [gm.current_epoch, k])
	gm.sim.auto_force = true


func _check_offers_after_move() -> void:
	if gm.job_offers.size() < gm.offers_count():
		_problem("Epoche %d: nach dem Umzug nur %d Angebote" % [gm.current_epoch, gm.job_offers.size()])
	for o in gm.job_offers:
		if o.epoch != gm.current_epoch:
			_problem("Epoche %d: Angebot aus Epoche %d" % [gm.current_epoch, o.epoch])
