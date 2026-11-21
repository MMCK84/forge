extends "res://tools/playtest.gd"
## Stufensprung-Prüfung: zeigt jedes Werkstück mit Rohform-Bild auf dem Amboss in fünf Stadien
## (Rohling, im ersten Arbeitsgang, Rohform, im letzten Arbeitsgang, fertig) und die Einrichtung je Epoche.
##   xvfb-run -a godot --path . --rendering-driver opengl3 --resolution 1080x1920 res://tools/rough_check.tscn -- --items=nail,horseshoe --furn=2
## Bilder in user://rough_check/ (je Werkstück ein Streifen <id>.png, Einrichtung furn_e<N>.png)

const Assets = preload("res://scripts/assets.gd")
var out_dir := "user://rough_check/"


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(out_dir)
	_run_check.call_deferred()


func _arg(name: String, def: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--" + name + "="):
			return a.substr(name.length() + 3)
	return def


func _grab() -> Image:
	await RenderingServer.frame_post_draw
	return get_viewport().get_texture().get_image()


func _run_check() -> void:
	var gm := GameManager
	SaveManager.save_blocked = true
	gm.settings["language"] = "de"
	gm.settings["tutorial"] = false
	gm.apply_settings()
	main = load("res://scenes/main/main.tscn").instantiate()
	get_tree().root.add_child(main)
	await wait(1.0)
	workshop().call("_start_new")
	await wait(1.2)
	await close_overlays()
	var ids: Array = []
	var arg := _arg("items", "")
	if arg != "":
		ids = Array(arg.split(","))
	else:
		for id in gm.items.keys():
			if Assets.item_tex(str(id) + "_rough") != null:
				ids.append(str(id))
	for id in ids:
		await _item_strip(str(id))
	var furn := _arg("furn", "")
	for e in (Array(furn.split(",")) if furn != "" else []):
		await _furn_shot(int(e))
	log_step("fertig: %d Werkstücke" % ids.size())
	get_tree().quit()


func _item_strip(id: String) -> void:
	var gm := GameManager
	var item: ItemData = gm.items.get(id, null)
	if item == null:
		log_step("unbekannt: " + id)
		return
	gm.abort_job()
	await close_overlays()
	for attempt in 5:
		if not gm.job_offers.is_empty():
			break
		gm.reroll_available_at = 0
		gm.reroll_offers()
		gm.refresh_offers()
		await wait(0.3)
	if gm.job_offers.is_empty():
		log_step("keine Angebote – %s übersprungen" % id)
		return
	var j: JobInstance = gm.job_offers[0]
	j.template_id = id
	j.steps = item.steps.duplicate(true)
	j.material = item.material
	j.quantity = 1
	gm.job_requirement_issue(j)
	gm.accept_offer(0)
	await wait(0.3)
	await close_overlays()
	var sim = gm.sim
	sim.load_raw()
	for attempt in 30:
		await wait(0.2)
		if sim.anvil >= 0 or sim.move_slot_to_anvil(0):
			break
	await wait(0.8)
	var p = gm.active_job.pieces[0]
	var fp: float = gm.active_job.piece_fp()
	var s1: float = gm.active_job.step_start(1) if gm.active_job.steps.size() > 1 else 1.0
	var stages := [0.0, s1 * 0.6, s1, s1 + (1.0 - s1) * 0.6, 0.999]
	var crops: Array = []
	for r in stages:
		p.progress = fp * r
		p.temp = 650.0
		await wait(0.6)
		var img: Image = await _grab()
		var w := img.get_width()
		var h := img.get_height()
		# Ausschnitt um den Amboss (mittleres Drittel der Bühne)
		var c := img.get_region(Rect2i(int(w * 0.10), int(h * 0.36), int(w * 0.80), int(h * 0.30)))
		crops.append(c)
	var cw: int = crops[0].get_width()
	var ch: int = crops[0].get_height()
	var strip := Image.create(cw * crops.size(), ch, false, crops[0].get_format())
	for k in crops.size():
		strip.blit_rect(crops[k], Rect2i(0, 0, cw, ch), Vector2i(k * cw, 0))
	strip.save_png(out_dir + id + ".png")
	shots += 1
	log_step("Stufensprung %s gespeichert" % id)
	gm.abort_job()


func _furn_shot(e: int) -> void:
	var gm := GameManager
	gm.abort_job()
	await close_overlays()
	while gm.current_epoch < e:
		for ms in gm.milestones_by_epoch.get(gm.current_epoch, []):
			if not gm.completed_milestone_ids.has(ms.id):
				gm.completed_milestone_ids.append(ms.id)
		gm.total_pence += 5000000
		gm.advance_epoch()
		await wait(0.3)
		await close_overlays()
	# Esse und Maschine der Epoche wie im Spiel (sonst stünde überall die Lehm-Esse)
	var forge_id: String = {1: "", 2: "forge_brick", 3: "forge_double_bellows", 4: "forge_double_bellows", 5: "forge_coke", 6: "forge_coke",
		7: "forge_coke", 8: "forge_welding_furnace", 9: "forge_welding_furnace", 10: "forge_siemens"}[e]
	if forge_id != "":
		gm.debug_add_money(5000000)
		gm.buy_forge(forge_id)
	var mach: String = {5: "machine_water_helve", 6: "machine_steam_helve", 9: "machine_nasmyth", 10: "machine_great_steam_hammer"}.get(e, "")
	if mach != "":
		gm.debug_add_money(50000000)
		gm.buy_machine(mach)
	if e >= 4:
		gm.debug_add_money(5000000)
	var stars := int(_arg("stars", "-1"))
	if stars >= 0:
		gm.stats["stars_total"] = stars
		gm.state_changed.emit()
	for sl in ["fuel", "tools", "bench", "trade", "light"]:
		gm.debug_add_money(gm.furnish_price(sl))
		gm.buy_furnishing(sl)
	await wait(0.5)
	await close_overlays()
	var img: Image = await _grab()
	img.save_png(out_dir + "furn_e%d.png" % e)
	shots += 1
	log_step("Einrichtung Epoche %d gespeichert" % e)
