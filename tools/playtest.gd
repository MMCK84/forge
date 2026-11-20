extends Node
## Automatischer Spieltest: startet das echte Spiel, spielt Abläufe durch und speichert Screenshots.
## Aufruf mit Grafik (z. B. unter xvfb-run):
##   godot --path . --rendering-driver opengl3 --resolution 1080x1920 res://tools/playtest.tscn
## Screenshots landen in user://playtest/ (Pfad wird ausgegeben).

const OUT := "user://playtest/"
var main: Node
var shots: int = 0
var problems: Array = []


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	_run.call_deferred()


func log_step(text: String) -> void:
	print("[Spieltest] " + text)


func shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	shots += 1
	var path := OUT + "%02d_%s.png" % [shots, name]
	img.save_png(path)
	log_step("Screenshot " + ProjectSettings.globalize_path(path))


func wait(sec: float) -> void:
	await get_tree().create_timer(sec, true, false, true).timeout


func check(cond: bool, msg: String) -> void:
	if cond:
		log_step("OK   " + msg)
	else:
		log_step("FEHLER " + msg)
		problems.append(msg)


func close_overlays() -> void:
	var layer := _overlay_layer()
	if layer == null:
		return
	for c in layer.get_children():
		if c.has_method("close"):
			c.close()
	await wait(0.2)


func _overlay_layer() -> Node:
	var cur = main.get("_current")
	if cur == null:
		return null
	var l = cur.get("overlay_layer")
	if l == null:
		l = cur.get("_overlay_layer")
	return l


func workshop() -> Node:
	return main.get("_current")


func run_until(cond: Callable, timeout_s: float) -> bool:
	var t := 0.0
	while t < timeout_s:
		if cond.call():
			return true
		await wait(0.05)
		t += 0.05
	return false


## Schlag mit der verlangten Schlagstärke (wie ein aufmerksamer Spieler).
func _hit_right() -> void:
	var sim = GameManager.sim
	if sim.anvil >= 0:
		var rf: int = sim.required_force(sim.anvil)
		if rf >= 0 and sim.force_enabled:
			workshop().call("_set_force", rf)
	workshop().call("_do_hit")


func _run() -> void:
	var gm := GameManager
	SaveManager.save_blocked = false
	gm.settings["language"] = "de"
	gm.settings["tutorial"] = true
	gm.apply_settings()
	main = load("res://scenes/main/main.tscn").instantiate()
	get_tree().root.add_child(main)
	await wait(1.0)
	await shot("hauptmenue")

	# --- Neues Spiel über das Menü
	var menu = workshop()
	menu.call("_start_new")
	await wait(1.0)
	check(gm.in_game, "Neues Spiel gestartet")
	await shot("werkstatt_willkommen")
	await close_overlays()

	# --- Auftragsbuch
	workshop().call("open_overlay", "res://scenes/ui/job_book.gd")
	await wait(0.5)
	await shot("auftragsbuch")
	await close_overlays()
	check(gm.accept_offer(0) == "", "Auftrag angenommen")
	await wait(0.3)
	await close_overlays()

	# --- Schmieden mit dem echten Ablauf (beschleunigt)
	Engine.time_scale = 6.0
	var sim = gm.sim
	sim.load_raw()
	await run_until(func() -> bool: return sim.hottest_forge_piece() >= 0 and gm.active_job.pieces[sim.hottest_forge_piece()].temp > 600.0, 30.0)
	Engine.time_scale = 1.0
	await shot("esse_aufheizen")
	Engine.time_scale = 6.0
	await run_until(func() -> bool: return gm.active_job.pieces[0].temp >= sim.step_window(0).y - 10.0, 30.0)
	Engine.time_scale = 1.0
	sim.move_slot_to_anvil(0)
	await wait(0.6)
	var done := false
	var hits := 0
	for k in 400:
		if gm.active_job == null:
			done = true
			break
		if sim.anvil < 0:
			Engine.time_scale = 6.0
			if sim.hottest_forge_piece() < 0 and sim.next_raw() >= 0:
				sim.load_raw()
			var h: int = sim.hottest_forge_piece()
			if h >= 0 and gm.active_job.pieces[h].temp >= sim.step_window(h).y - 10.0:
				Engine.time_scale = 1.0
				sim.move_slot_to_anvil(gm.active_job.pieces[h].slot)
				await wait(0.6)
			else:
				await wait(0.1)
			continue
		var p = gm.active_job.pieces[sim.anvil]
		var w: Vector2 = sim.step_window(sim.anvil)
		if p.temp < w.x:
			sim.move_anvil_to_forge(-1)
			await wait(0.6)
			continue
		if p.temp > w.y:
			await wait(0.1)
			continue
		_hit_right()
		hits += 1
		if hits == 4:
			await shot("amboss_schmieden")
		await wait(0.13)
	Engine.time_scale = 1.0
	await wait(0.5)
	check(done or gm.active_job == null, "Erster Auftrag abgeschlossen (%d Schläge)" % hits)
	await shot("abrechnung")
	await close_overlays()
	check(gm.total_pence > 0, "Lohn gutgeschrieben: " + gm.format_money(gm.total_pence))

	# --- Laden
	gm.total_pence += 2000
	workshop().call("open_overlay", "res://scenes/ui/shop.gd")
	await wait(0.4)
	await shot("laden")
	await close_overlays()
	check(gm.buy_hammer("hammer_cross_peen"), "Kreuzschlaghammer gekauft")

	# --- Speichern / Laden-Rundlauf über die echten Dateien
	check(SaveManager.save_game(), "Spielstand gespeichert")
	var before: int = gm.total_pence
	gm.total_pence = 1
	check(SaveManager.load_game() and gm.total_pence == before, "Spielstand geladen (Geld wiederhergestellt)")

	# --- Spätere Epochen (Zustand direkt gesetzt)
	for e in [2, 3, 4, 5, 6]:
		await _epoch_scene(e)

	Engine.time_scale = 1.0
	await _panels()
	log_step("Fertig: %d Screenshots, %d Probleme" % [shots, problems.size()])
	for p in problems:
		log_step("  - " + str(p))
	get_tree().quit(1 if problems.size() > 0 else 0)


func _epoch_scene(e: int) -> void:
	var gm := GameManager
	await close_overlays()
	gm.abort_job()
	# Voraussetzung: alle Meilensteine der Vorepoche erledigt
	for ms in gm.milestones_by_epoch.get(gm.current_epoch, []):
		if not gm.completed_milestone_ids.has(ms.id):
			gm.completed_milestone_ids.append(ms.id)
	gm.total_pence += 500000
	if e == 2:
		workshop().call("_open_epoch_offer")
		await wait(0.4)
		await shot("epochenwechsel_angebot")
		await close_overlays()
	check(gm.advance_epoch(), "Wechsel in Epoche %d" % e)
	await wait(0.3)
	if e == 2:
		await shot("epoche2_ankunft")
	await close_overlays()
	var forge_id: String = {2: "forge_brick", 3: "forge_double_bellows", 4: "forge_double_bellows", 5: "forge_coke", 6: "forge_coke"}[e]
	gm.buy_forge(forge_id)
	gm.buy_hammer("hammer_steel_faced")
	gm.buy_hammer("hammer_crucible")
	if e >= 2:
		gm.hire("staff_apprentice")
	if e >= 3:
		gm.hire("staff_striker")
	if e == 5:
		gm.buy_machine("machine_water_helve")
	if e == 6:
		gm.buy_machine("machine_steam_helve")
	await wait(0.2)
	await close_overlays()
	# Passenden Auftrag suchen (Mengen-, Schweiß-, Härte-, Großauftrag)
	var want: String = {2: "quantity", 3: "weld", 4: "harden", 5: "machine", 6: "big"}[e]
	var idx := -1
	for attempt in 40:
		for i in gm.job_offers.size():
			var j: JobInstance = gm.job_offers[i]
			var ok: bool = (want == "quantity" and j.quantity > 1) or (want == "weld" and j.needs_weld()) \
				or (want == "harden" and j.needs_harden()) or (want == "machine") or (want == "big" and j.is_big())
			if ok and gm.job_requirement_issue(j) == "":
				idx = i
				break
		if idx >= 0:
			break
		gm.reroll_available_at = 0
		gm.reroll_offers()
	check(idx >= 0, "Epoche %d: Auftrag vom Typ '%s' gefunden" % [e, want])
	if idx < 0:
		return
	workshop().call("open_overlay", "res://scenes/ui/job_book.gd")
	await wait(0.4)
	if e == 3:
		await shot("auftragsbuch_epoche3")
	await close_overlays()
	gm.accept_offer(idx)
	await wait(0.2)
	await close_overlays()
	var sim = gm.sim
	var j2: JobInstance = gm.active_job
	# Lehrling arbeitet ab Epoche 2 automatisch; wir schmieden mit
	Engine.time_scale = 4.0
	var shot_taken := false
	var budget := 3.0 * maxf(j2.estimate_s, 60.0) + 120.0
	var start_time: float = gm.sim.sim_time
	log_step("Epoche %d: %s, %d Stück, Schätzung %.0f s" % [e, gm.job_title(j2), j2.quantity, j2.estimate_s])
	for k in 100000:
		if gm.active_job == null:
			break
		if gm.sim.sim_time - start_time > budget:
			log_step("Zeitbudget überschritten: %d/%d fertig, Ausschuss bisher %d" % [j2.pieces_done(), j2.quantity, gm.sim.pieces_ruined])
			break
		if workshop().get("overlay_layer").get_child_count() > 0:
			await close_overlays()
		if sim.anvil >= 0 and not sim.in_transit(sim.anvil):
			var i: int = sim.anvil
			var p = j2.pieces[i]
			if sim.awaiting_quench(i):
				if p.temp <= 830.0 and p.temp >= 770.0:
					Engine.time_scale = 1.0
					if not shot_taken:
						await shot("epoche%d_abschrecken" % e)
						shot_taken = true
					workshop().call("_on_quench")
					await wait(0.4)
					await shot("epoche%d_nach_abschrecken" % e)
					Engine.time_scale = 4.0
				elif p.temp < 770.0:
					sim.move_anvil_to_forge(-1)
			elif sim.in_weld_phase(i):
				if p.temp >= 1200.0 and p.temp <= 1300.0:
					if not shot_taken:
						Engine.time_scale = 1.0
						_hit_right()
						await shot("epoche%d_feuerschweissen" % e)
						shot_taken = true
						Engine.time_scale = 4.0
					sim.last_player_hit = -10.0
					_hit_right()
			elif p.temp >= sim.step_window(i).x and p.temp <= sim.step_window(i).y:
				sim.last_player_hit = -10.0
				_hit_right()
				if not shot_taken and (e == 2 or e >= 5) and k > 20:
					Engine.time_scale = 1.0
					await wait(0.1)
					await shot("epoche%d_werkstatt" % e)
					shot_taken = true
					Engine.time_scale = 4.0
		await wait(0.05)
	Engine.time_scale = 1.0
	await wait(0.3)
	check(gm.active_job == null, "Epoche %d: Auftrag '%s' abgeschlossen" % [e, want])
	if e == 4:
		await shot("abrechnung_haerten")
	await close_overlays()


## Alle übrigen Fenster einmal öffnen, Sprache wechseln, Finale zeigen.
func _panels() -> void:
	var gm := GameManager
	await close_overlays()
	for path in ["res://scenes/ui/staff_panel.gd", "res://scenes/ui/settings_panel.gd", "res://scenes/ui/stats_panel.gd",
			"res://scenes/ui/pause_menu.gd", "res://scenes/ui/credits_panel.gd"]:
		var p = workshop().call("open_overlay", path)
		await wait(0.4)
		check(p != null and is_instance_valid(p), "Fenster geöffnet: " + path.get_file())
		await shot("fenster_" + path.get_file().get_basename())
		await close_overlays()
	# Finale (Abschluss-Meilenstein Epoche 6)
	var ep = load("res://scenes/ui/epoch_panel.gd").new()
	ep.mode = "finale"
	ep.epoch = 6
	workshop().get("overlay_layer").add_child(ep)
	await wait(0.4)
	await shot("finale")
	await close_overlays()
	# Sprachwechsel auf Englisch
	gm.set_setting("language", "en")
	await wait(0.4)
	workshop().call("open_overlay", "res://scenes/ui/job_book.gd")
	await wait(0.4)
	await shot("englisch_auftragsbuch")
	await close_overlays()
	check(TranslationServer.translate("UI_SHOP") == "Shop", "Englische Übersetzung aktiv")
	gm.set_setting("language", "de")
	# Testmenü: sichern, springen, laden
	var tp = workshop().call("open_overlay", "res://scenes/ui/test_panel.gd")
	await wait(0.4)
	await shot("testmenue")
	tp.call("_save", 1)
	var epoch_before: int = gm.current_epoch
	tp.call("_jump", 5, 1.0)
	await wait(0.6)
	check(gm.current_epoch == 5 and gm.current_complexity() > 0.99, "Testmenü: Sprung ans Ende von Epoche 5")
	workshop().call("open_overlay", "res://scenes/ui/job_book.gd")
	await wait(0.4)
	await shot("auftragsbuch_ende_epoche5")
	await close_overlays()
	var tp2 = workshop().call("open_overlay", "res://scenes/ui/test_panel.gd")
	await wait(0.3)
	tp2.call("_load", 1)
	await wait(0.6)
	check(gm.current_epoch == epoch_before, "Testmenü: Test-Spielstand geladen")
	SaveManager.delete_test_slot(1)
	# Pause-Menü: Speichern & Beenden zurück ins Hauptmenü
	workshop().call("_open_pause")
	await wait(0.3)
	var pm = workshop().get("overlay_layer").get_child(0)
	pm.call("_save_quit")
	await wait(0.8)
	check(not gm.in_game, "Speichern & Beenden führt ins Hauptmenü")
	await shot("hauptmenue_mit_spielstand")
	# Testmenü aus dem Hauptmenü: direkt in Epoche 3 einsteigen
	var menu = workshop()
	menu.call("_open_test_menu")
	await wait(0.4)
	var tp3 = menu.get("_overlay_layer").get_child(0)
	tp3.call("_jump", 3, 0.5)
	await wait(1.0)
	check(gm.in_game and gm.current_epoch == 3, "Testmenü im Hauptmenü: Einstieg in Epoche 3")
	await shot("einstieg_epoche3")
