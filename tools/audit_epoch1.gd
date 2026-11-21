extends "res://tools/playtest.gd"
## Bestandsaufnahme Epoche 1 (Alpha): nimmt jeden Bildschirm auf, den ein Spieler in Epoche 1 sieht.
##   xvfb-run -a godot --path . --rendering-driver opengl3 --resolution 1080x1920 res://tools/audit_epoch1.tscn
## Bilder in user://audit_e1/

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute("user://audit_e1/")
	_run_audit.call_deferred()


func shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	shots += 1
	img.save_png("user://audit_e1/%02d_%s.png" % [shots, name])
	log_step("Bild %02d %s" % [shots, name])


func hint(id: String, name: String) -> void:
	GameManager.seen_hints.erase(id)
	workshop().call("_queue_hint", id)
	await wait(0.5)
	await shot("hinweis_" + name)
	await close_overlays()


func _run_audit() -> void:
	var gm := GameManager
	SaveManager.save_blocked = true
	gm.settings["language"] = "de"
	gm.settings["tutorial"] = true
	gm.apply_settings()
	main = load("res://scenes/main/main.tscn").instantiate()
	get_tree().root.add_child(main)
	await wait(1.2)
	await shot("hauptmenue")
	workshop().call("_open", "res://scenes/ui/settings_panel.gd")
	await wait(0.5)
	await shot("einstellungen_menue")
	await close_overlays()
	workshop().call("_open", "res://scenes/ui/credits_panel.gd")
	await wait(0.5)
	await shot("mitwirkende")
	await close_overlays()

	workshop().call("_start_new")
	await wait(1.2)
	await shot("neues_spiel")
	await close_overlays()
	await shot("lehrzeit_auftragsbuch_oeffnen")
	workshop().call("open_overlay", "res://scenes/ui/job_book.gd")
	await wait(0.5)
	await shot("auftragsbuch_erster_auftrag")
	await close_overlays()
	gm.accept_offer(0)
	await wait(0.4)
	await close_overlays()
	await shot("lehrzeit_einlegen")
	var sim = gm.sim
	sim.load_raw()
	Engine.time_scale = 4.0
	await run_until(func() -> bool: return gm.active_job.pieces[0].temp > 450.0, 20.0)
	Engine.time_scale = 1.0
	await shot("lehrzeit_esse_heizt")
	Engine.time_scale = 4.0
	await run_until(func() -> bool: return gm.active_job.pieces[0].temp >= sim.step_window(0).y - 5.0, 20.0)
	Engine.time_scale = 1.0
	await wait(0.3)
	await shot("lehrzeit_stueck_holen")
	sim.move_slot_to_anvil(0)
	await wait(0.6)
	for k in 6:
		_hit_right()
		await wait(0.14)
	await shot("lehrzeit_schmieden")
	for k in 200:
		if gm.active_job == null:
			break
		var p = gm.active_job.pieces[0]
		if sim.anvil < 0 or p.temp < sim.step_window(0).x:
			if sim.anvil >= 0:
				await shot("lehrzeit_zu_kalt")
				sim.move_anvil_to_forge(-1)
			Engine.time_scale = 4.0
			await run_until(func() -> bool: return gm.active_job == null or gm.active_job.pieces[0].temp >= sim.step_window(0).y - 5.0, 20.0)
			Engine.time_scale = 1.0
			if gm.active_job == null:
				break
			sim.move_slot_to_anvil(0)
			await wait(0.6)
			continue
		_hit_right()
		await wait(0.14)
	await wait(0.6)
	await shot("werkstueck_fertig")
	await finish_showcase()
	await shot("abrechnung_erster_auftrag")
	await close_overlays()
	await wait(0.4)
	await shot("lehrzeit_hammer_kaufen")
	workshop().call("open_overlay", "res://scenes/ui/shop.gd")
	await wait(0.5)
	await shot("laden_lehrzeit")
	await close_overlays()

	# Lehrzeit im Zeitraffer beenden
	gm.total_pence += 400
	gm.buy_hammer("hammer_cross_peen")
	gm.equip_hammer("hammer_cross_peen")
	var mastery_shot := false
	for k in 4:
		if gm.active_job == null:
			gm.accept_offer(0)
		gm.debug_finish_job()
		await wait(0.4)
		if not mastery_shot and int(gm.stats.get("jobs_completed", 0)) == 3:
			mastery_shot = true
			await finish_showcase()
			await shot("abrechnung_erstes_siegel")
		await close_overlays()
		await close_overlays()
	await wait(0.5)
	await shot("nach_lehrzeit_werkstatt")
	await close_overlays()
	await close_overlays()
	gm.accept_offer(0)
	await wait(0.4)
	await close_overlays()
	sim.load_raw()
	Engine.time_scale = 4.0
	await run_until(func() -> bool: return sim.hottest_forge_piece() >= 0 and gm.active_job.pieces[sim.hottest_forge_piece()].temp >= sim.step_window(sim.hottest_forge_piece()).y - 5.0, 20.0)
	Engine.time_scale = 1.0
	sim.move_slot_to_anvil(gm.active_job.pieces[sim.hottest_forge_piece()].slot)
	await wait(0.6)
	await shot("werkstatt_schlagstaerke")
	gm.debug_finish_job()
	await wait(0.4)
	await close_overlays()

	for pair in [["steps", "arbeitsgaenge"], ["mastery", "meisterschaft"], ["furnish_intro", "einrichtung"], ["force", "schlagstaerke"],
			["precision", "praezision"], ["masterpiece", "meisterstueck"], ["money", "geld"]]:
		await hint(pair[0], pair[1])

	workshop().call("open_overlay", "res://scenes/ui/job_book.gd")
	await wait(0.5)
	await shot("auftragsbuch_drei_angebote")
	await close_overlays()
	gm.total_pence += 300000
	workshop().call("open_overlay", "res://scenes/ui/shop.gd")
	await wait(0.5)
	await shot("laden_einrichtung")
	var sh = _overlay_layer().get_child(_overlay_layer().get_child_count() - 1)
	var sc = sh.get("_scroll")
	if sc != null:
		sc.scroll_vertical = 600
		await wait(0.3)
		await shot("laden_mitte")
		sc.scroll_vertical = 5000
		await wait(0.3)
		await shot("laden_unten")
	await close_overlays()
	for sl in ["fuel", "tools", "bench", "trade", "light"]:
		gm.buy_furnishing(sl)
	await wait(0.8)
	await close_overlays()
	await shot("werkstatt_eingerichtet")
	for path in ["res://scenes/ui/staff_panel.gd", "res://scenes/ui/stats_panel.gd", "res://scenes/ui/pattern_book.gd",
			"res://scenes/ui/pause_menu.gd", "res://scenes/ui/settings_panel.gd", "res://scenes/ui/chapter_panel.gd"]:
		workshop().call("open_overlay", path)
		await wait(0.5)
		await shot("fenster_" + path.get_file().get_basename())
		await close_overlays()

	# Meisterstück am Ende der Epoche
	var fm: MilestoneData = gm.final_milestone(1)
	for ms in gm.milestones_by_epoch[1]:
		if ms.id != fm.id and not gm.completed_milestone_ids.has(ms.id):
			gm.completed_milestone_ids.append(ms.id)
	gm.jobs_completed_in_epoch = gm.epoch_job_count(1)
	gm.job_offers = []
	gm.refresh_offers()
	workshop().call("open_overlay", "res://scenes/ui/job_book.gd")
	await wait(0.5)
	await shot("auftragsbuch_meisterstueck")
	await close_overlays()
	gm.accept_offer(0)
	await wait(0.3)
	await shot("werkstatt_meisterstueck")
	gm.debug_finish_job()
	await wait(0.5)
	await finish_showcase()
	await shot("abrechnung_meisterstueck_teil")
	await close_overlays()
	gm.accept_offer(0)
	gm.debug_finish_job()
	await wait(0.5)
	await finish_showcase()
	await shot("abrechnung_meisterbrief")
	await close_overlays()
	await wait(0.6)
	await shot("nach_meisterbrief")
	var p2 = load("res://scenes/ui/epoch_panel.gd").new()
	p2.mode = "offer"
	p2.epoch = 2
	_overlay_layer().add_child(p2)
	await wait(0.5)
	await shot("epochenwechsel_angebot")
	await close_overlays()
	log_step("Fertig: %d Bilder" % shots)
	get_tree().quit(0)
