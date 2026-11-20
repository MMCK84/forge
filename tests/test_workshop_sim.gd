extends "res://tests/test_base.gd"
## Werkstatt-Simulation: Temperatur, Schläge, Ausschuss, Schweißen, Härten, Personal, Maschinen.

const WorkshopSim = preload("res://scripts/workshop_sim.gd")
const Catalog = preload("res://scripts/catalog.gd")
const ReferencePlayer = preload("res://scripts/reference_player.gd")
var cfg: BalanceConfig = Catalog.BALANCE


func _job(fp: int, qty: int = 1, category: String = "normal", precise: bool = false) -> JobInstance:
	var j := JobInstance.new()
	j.template_id = "horseshoe"
	j.customer_id = "vicar"
	j.form_points = fp
	j.quantity = qty
	j.category = category
	j.precise = precise
	j.reward_base_pence = 100 * qty
	j.reset_pieces(cfg.room_temp)
	return j


func _sim(job: JobInstance, k_heat: float = 25.0, t_max: float = 1100.0, slots: int = 1) -> WorkshopSim:
	var s := WorkshopSim.new(cfg)
	s.set_forge(k_heat, t_max, slots)
	s.hammer_power = 10.0
	s.water_timer = 1.0e9
	# Bestehende Tests prüfen Temperatur und Fortschritt: Schlagstärke passt immer
	s.auto_force = true
	s.load_job(job)
	return s


func _run(s: WorkshopSim, seconds: float, dt: float = 0.05) -> void:
	var t := 0.0
	while t < seconds - 0.00001:
		s.step(dt)
		t += dt


func _hit(s: WorkshopSim) -> String:
	s.last_player_hit = -10.0
	return s.player_hit()


func test_heating_and_cooling() -> void:
	var s := _sim(_job(1000))
	assert_eq(s.load_raw(), 0)
	_run(s, 0.5)  # Umlegen: keine Temperaturänderung
	assert_near(s.job.pieces[0].temp, 20.0, 0.001, "während des Umlegens kein Aufheizen")
	_run(s, 10.0)
	assert_near(s.job.pieces[0].temp, 270.0, 0.5, "25 °C/s")
	_run(s, 60.0)
	assert_near(s.job.pieces[0].temp, 1100.0, 0.001, "begrenzt auf T_max")
	assert_true(s.move_slot_to_anvil(0))
	_run(s, 0.5)
	_run(s, 10.0)
	assert_near(s.job.pieces[0].temp, 950.0, 0.5, "Abkühlen 15 °C/s")


func test_hit_progress_and_window() -> void:
	var s := _sim(_job(1000), 25.0, 1100.0)
	var p: JobInstance.Piece = s.job.pieces[0]
	s.load_raw()
	p.temp = 900.0
	s.transit.clear()
	s.move_slot_to_anvil(0)
	s.transit.clear()
	assert_eq(_hit(s), "good")
	assert_near(p.progress, 10.0, 0.001)
	assert_near(p.points_in_window, 10.0, 0.001)
	p.temp = 550.0
	assert_eq(_hit(s), "weak")
	assert_near(p.progress, 15.5, 0.001, "M(550) = 0,55")
	assert_near(p.points_in_window, 10.0, 0.001, "Anwärmbereich zählt nicht als Treffer")


func test_rate_limit() -> void:
	var s := _sim(_job(1000))
	s.load_raw()
	s.transit.clear()
	s.job.pieces[0].temp = 900.0
	s.move_slot_to_anvil(0)
	s.transit.clear()
	assert_eq(s.player_hit(), "good")
	assert_eq(s.player_hit(), "none", "mehr als 8 Schläge/s werden ignoriert")
	s.step(0.13)
	assert_true(s.player_hit() != "none")


func test_cold_hits_damage_and_ruin() -> void:
	var s := _sim(_job(1000))
	var costs := [0]
	s.cost_incurred.connect(func(p: int, _r: String) -> void: costs[0] += p)
	s.load_raw()
	s.transit.clear()
	s.move_slot_to_anvil(0)
	s.transit.clear()
	assert_eq(_hit(s), "cold")
	assert_near(s.job.pieces[0].damage, 0.02, 0.0001)
	for i in 49:
		_hit(s)
	assert_eq(s.job.pieces[0].location, "raw", "D ≥ 100 % = Ausschuss, neuer Rohling")
	assert_eq(s.anvil, -1)
	assert_eq(costs[0], 20, "Materialkosten 20 % des Lohns")


func test_burn() -> void:
	var s := _sim(_job(1000), 100.0, 1450.0)
	var reasons := []
	s.piece_ruined.connect(func(_i: int, r: String) -> void: reasons.append(r))
	s.load_raw()
	_run(s, 14.0)
	assert_eq(reasons, ["burned"], "über 1300 °C verbrennt das Werkstück")


func test_weld_phase() -> void:
	var s := _sim(_job(100, 1, "weld"), 40.0, 1250.0)
	var p: JobInstance.Piece = s.job.pieces[0]
	s.load_raw()
	s.transit.clear()
	p.temp = 900.0
	s.move_slot_to_anvil(0)
	s.transit.clear()
	for i in 10:
		_hit(s)
	assert_near(p.progress, 50.0, 0.001, "Fortschritt pausiert bei 50 %")
	assert_true(s.in_weld_phase(0))
	assert_eq(_hit(s), "weld_miss", "außerhalb der Weißglut")
	p.temp = 1250.0
	for i in 6:
		assert_eq(_hit(s), "weld")
	assert_true(not s.in_weld_phase(0))
	p.temp = 900.0
	_hit(s)
	assert_near(p.progress, 60.0, 0.001, "nach dem Schweißen geht es weiter")


func test_harden_quench() -> void:
	var s := _sim(_job(20, 1, "harden"))
	s.has_trough = true
	var p: JobInstance.Piece = s.job.pieces[0]
	var done := [false]
	s.job_finished.connect(func() -> void: done[0] = true)
	s.load_raw()
	s.transit.clear()
	p.temp = 1000.0
	s.move_slot_to_anvil(0)
	s.transit.clear()
	_hit(s)
	_hit(s)
	assert_true(s.awaiting_quench(0))
	assert_true(not done[0], "erst nach dem Abschrecken fertig")
	assert_true(s.quench())
	assert_near(p.quench_penalty, 0.35, 0.0001, "1000 °C = Härteriss")
	assert_true(done[0])
	assert_near(p.temp, 20.0, 0.001, "Löschtrog setzt auf 20 °C")


func test_quantity_and_evaluate() -> void:
	var s := _sim(_job(40, 2), 25.0, 1100.0, 2)
	var done := [false]
	s.job_finished.connect(func() -> void: done[0] = true)
	s.load_raw()
	s.load_raw()
	assert_eq(s.free_slot(), -1)
	s.transit.clear()
	for i in 2:
		s.job.pieces[i].temp = 900.0
	s.move_slot_to_anvil(0)
	s.transit.clear()
	_hit(s)
	_hit(s)
	assert_eq(s.job.pieces_done(), 1)
	s.move_slot_to_anvil(1)
	s.transit.clear()
	_hit(s)
	_hit(s)
	assert_true(done[0])
	var ev := s.evaluate()
	assert_eq(ev["stars"], 3)
	assert_near(ev["hit_quote"], 1.0, 0.0001)


func test_apprentice() -> void:
	var s := _sim(_job(100000, 1), 40.0, 1250.0, 2)
	s.has_apprentice = true
	_run(s, 0.2)
	assert_eq(s.job.pieces[0].location, "forge", "Lehrling legt Rohling ein")
	_run(s, 30.0)
	assert_eq(s.anvil, 0, "Lehrling legt bei 1050 °C auf den Amboss")
	_run(s, 22.0)
	assert_eq(s.job.pieces[0].location, "forge", "unter 750 °C zurück in die Esse")


func test_machine_strikes() -> void:
	var s := _sim(_job(100000, 1))
	s.machine = Catalog.MACHINES[1]
	var costs := [0]
	s.cost_incurred.connect(func(p: int, _r: String) -> void: costs[0] += p)
	s.load_raw()
	s.transit.clear()
	s.job.pieces[0].temp = 1100.0
	s.move_slot_to_anvil(0)
	s.transit.clear()
	_run(s, 1.1)
	assert_near(s.job.pieces[0].progress, 750.0, 0.01, "Dampf-Schwanzhammer: 3 × 250 je Sekunde")
	_run(s, 19.0)
	assert_true(costs[0] >= 19 and costs[0] <= 21, "Betriebskosten 5s je Minute (≈ 1d/s)")


func test_big_forging_manual_factor() -> void:
	var s := _sim(_job(10000, 1, "big"))
	s.load_raw()
	s.transit.clear()
	s.job.pieces[0].temp = 900.0
	s.move_slot_to_anvil(0)
	s.transit.clear()
	_hit(s)
	assert_near(s.job.pieces[0].progress, 2.5, 0.001, "Handschläge wirken nur zu 25 %")


func test_apprentice_fetches_quench_piece() -> void:
	# Ein fertig geschmiedetes Härte-Stück in der Esse holt der Lehrling bei Abschrecktemperatur auf den Amboss.
	var s := _sim(_job(10, 1, "harden"), 65.0, 1350.0, 3)
	s.has_trough = true
	s.has_apprentice = true
	var p: JobInstance.Piece = s.job.pieces[0]
	s.load_raw()
	s.transit.clear()
	p.progress = 10.0
	p.temp = 500.0
	assert_true(s.awaiting_quench(0))
	_run(s, 6.0)
	assert_eq(s.anvil, 0, "Lehrling legt das Stück auf den Amboss")
	assert_true(p.temp < 1000.0, "nicht verbrannt")
	assert_true(s.quench(), "Spieler kann abschrecken")


func test_apprentice_holds_waiting_pieces() -> void:
	# In einer Esse über der Verbrennungsgrenze verbrennen wartende Stücke nicht, solange der Lehrling aufpasst.
	var s := _sim(_job(100000, 3), 65.0, 1350.0, 3)
	s.has_apprentice = true
	var ruined := [0]
	s.piece_ruined.connect(func(_i: int, _r: String) -> void: ruined[0] += 1)
	_run(s, 120.0)
	assert_eq(ruined[0], 0, "kein Stück verbrannt")
	assert_true(s.anvil >= 0, "ein Stück liegt auf dem Amboss")
	var s2 := _sim(_job(100000, 3), 65.0, 1350.0, 3)
	var ruined2 := [0]
	s2.piece_ruined.connect(func(_i: int, _r: String) -> void: ruined2[0] += 1)
	s2.load_raw()
	_run(s2, 25.0)
	assert_true(ruined2[0] > 0, "ohne Lehrling verbrennt ein vergessenes Stück (5.3: mehr Leistung, mehr Aufmerksamkeit)")


func test_smart_move_swaps_when_forge_full() -> void:
	# Ein Platz, zwei Stücke: E tauscht das kalte Amboss-Stück gegen das heiße aus der Esse.
	var s := _sim(_job(1000, 2), 60.0, 1200.0, 1)
	s.load_raw()
	s.transit.clear()
	s.move_slot_to_anvil(0)
	s.transit.clear()
	s.load_raw()
	s.transit.clear()
	s.job.pieces[0].temp = 500.0
	s.job.pieces[1].temp = 1000.0
	assert_eq(s.free_slot(), -1)
	assert_true(s.smart_move(), "Umlegen tauscht bei voller Esse")
	assert_eq(s.anvil, 1, "heißes Stück liegt jetzt auf dem Amboss")
	assert_eq(s.job.pieces[0].location, "forge", "kaltes Stück ist in der Esse")


func test_clay_forge_can_overheat() -> void:
	# Lehm-Esse 1200 °C: ein vergessenes Stück wird zu heiß (Gefügeschaden), verbrennt aber nicht.
	var f: ForgeData = Catalog.FORGES[0]
	assert_true(f.t_max > cfg.optimal_max, "T_max liegt über dem Schmiedefenster")
	assert_true(f.t_max < cfg.burn_limit, "aber unter der Verbrennungsgrenze")
	var s := _sim(_job(1000), f.k_heat, f.t_max, 1)
	s.load_raw()
	_run(s, 40.0)
	assert_true(s.job.pieces[0].damage > 0.0, "Überhitzung schadet dem Gefüge")
	assert_eq(s.job.pieces[0].location, "forge", "nicht verbrannt")


func _step_job(fp: int, steps: Array, material: String = "iron", precise: bool = false) -> JobInstance:
	var j := _job(fp, 1, "normal", precise)
	j.steps = steps
	j.material = material
	return j


func test_steps_change_window() -> void:
	# Hufeisen: Strecken 40 %, Biegen 35 %, Lochen 25 %
	var j := _step_job(100, [{"id": "draw", "share": 0.4}, {"id": "bend", "share": 0.35}, {"id": "punch", "share": 0.25}])
	var s := _sim(j)
	var changes := []
	s.step_changed.connect(func(_i: int, k: int) -> void: changes.append(k))
	var p: JobInstance.Piece = j.pieces[0]
	s.load_raw()
	s.transit.clear()
	s.move_slot_to_anvil(0)
	s.transit.clear()
	assert_eq(s.step_window(0), Vector2(950, 1100), "Strecken: 950–1100 °C")
	p.temp = 1000.0
	assert_eq(_hit(s), "good")
	p.temp = 800.0
	assert_eq(_hit(s), "off", "800 °C ist zu kühl zum Strecken")
	assert_near(p.points_in_window, 10.0, 0.001, "nur der Schlag im Fenster zählt für die Qualität")
	for k in 3:
		_hit(s)
	assert_eq(s.step_index(0), 1, "nach 40 % beginnt das Biegen")
	assert_eq(changes, [1], "Wechsel wird gemeldet")
	assert_eq(s.step_window(0), Vector2(750, 900), "Biegen: 750–900 °C")
	p.temp = 1000.0
	assert_eq(_hit(s), "off", "1000 °C ist zu heiß zum Biegen")


func test_steel_offset_and_burn() -> void:
	var j := _step_job(1000, [{"id": "draw", "share": 1.0}], "steel")
	var s := _sim(j, 100.0, 1450.0)
	assert_eq(s.step_window(0), Vector2(900, 1050), "Stahl wird 50 °C kühler gestreckt")
	assert_near(s.burn_temp(), 1250.0, 0.001, "Stahl verbrennt ab 1250 °C")
	var reasons := []
	s.piece_ruined.connect(func(_i: int, r: String) -> void: reasons.append(r))
	s.load_raw()
	_run(s, 13.0)
	assert_eq(reasons, ["burned"], "verbrennt vor 1300 °C")


func test_precision_narrows_step_window() -> void:
	var s := _sim(_step_job(100, [{"id": "draw", "share": 1.0}], "iron", true))
	var w: Vector2 = s.step_window(0)
	assert_near(w.x, 980.0, 0.01, "mittlere 60 % von 950–1100")
	assert_near(w.y, 1070.0, 0.01)


func test_reference_player_handles_steps() -> void:
	var j := _step_job(600, [{"id": "draw", "share": 0.4}, {"id": "bend", "share": 0.35}, {"id": "planish", "share": 0.25}])
	var d := ReferencePlayer.estimate_job(cfg, j, {"k_heat": 60.0, "t_max": 1200.0, "slots": 1, "hammer_power": 10.0})
	assert_true(d < 600.0, "Referenzspieler schließt Aufträge mit Arbeitsgängen ab (%.0f s)" % d)


# ------------------------------------------------------------------ Schlagstärke

func _force_sim(steps: Array, epoch: int = 2) -> WorkshopSim:
	var j := _step_job(1000, steps)
	j.epoch = epoch
	var s := _sim(j)
	s.auto_force = false
	s.load_raw()
	s.transit.clear()
	s.move_slot_to_anvil(0)
	s.transit.clear()
	return s


func test_force_required_per_step() -> void:
	var s := _force_sim([{"id": "draw", "share": 0.5}, {"id": "planish", "share": 0.5}])
	assert_eq(s.required_force(0), WorkshopSim.FORCE_HEAVY, "Strecken verlangt schwer")
	s.job.pieces[0].progress = 600.0
	assert_eq(s.required_force(0), WorkshopSim.FORCE_LIGHT, "Schlichten verlangt leicht")
	var m := _force_sim([{"id": "cut", "share": 1.0}], 2)
	assert_eq(m.required_force(0), WorkshopSim.FORCE_MEDIUM, "Abschroten verlangt mittel")
	var e1 := _force_sim([{"id": "cut", "share": 1.0}], 1)
	assert_eq(e1.required_force(0), WorkshopSim.FORCE_HEAVY, "Epoche 1: mittel wird als schwer verlangt")


func test_force_effects() -> void:
	var s := _force_sim([{"id": "draw", "share": 1.0}])
	var p: JobInstance.Piece = s.job.pieces[0]
	p.temp = 1000.0
	s.force = WorkshopSim.FORCE_HEAVY
	assert_eq(_hit(s), "good", "richtige Stärke")
	assert_near(p.progress, 10.0, 0.001, "volle Wirkung")
	s.force = WorkshopSim.FORCE_MEDIUM
	assert_eq(_hit(s), "too_soft", "eine Stufe zu leicht")
	assert_near(p.progress, 10.0 + 10.0 * cfg.force_gain_off_one, 0.001, "verminderte Wirkung")
	assert_near(p.points_in_window, 10.0, 0.001, "falsche Stärke zählt nicht für die Qualität")
	var before := p.progress
	s.force = WorkshopSim.FORCE_LIGHT
	assert_eq(_hit(s), "too_soft")
	assert_near(p.progress - before, 10.0 * cfg.force_gain_too_soft, 0.001, "leicht statt schwer")
	assert_near(p.damage, 0.0, 0.0001, "zu sanft schadet nicht")


func test_force_too_hard_damages() -> void:
	var s := _force_sim([{"id": "planish", "share": 1.0}])
	var p: JobInstance.Piece = s.job.pieces[0]
	p.temp = 800.0
	s.force = WorkshopSim.FORCE_HEAVY
	assert_eq(_hit(s), "too_hard")
	assert_near(p.damage, cfg.force_too_hard_damage, 0.0001, "schwer statt leicht verursacht Gefügeschaden")
	assert_near(p.progress, 10.0 * cfg.force_gain_too_hard, 0.001)
	s.force_enabled = false
	var d := p.damage
	assert_eq(_hit(s), "good", "ohne Schlagstärke (Tutorial) passt jeder Schlag")
	assert_near(p.damage, d, 0.0001)


func test_machines_follow_force() -> void:
	var helve := MachineData.new()
	helve.p_base = 100.0
	helve.hits_per_s = 1.0
	helve.force_mode = "heavy"
	var s := _force_sim([{"id": "bend", "share": 1.0}])
	s.machine = helve
	s.job.pieces[0].temp = 850.0
	assert_true(not s.machine_engaged(), "Schwanzhammer pausiert beim Biegen (leicht)")
	var s2 := _force_sim([{"id": "draw", "share": 1.0}])
	s2.machine = helve
	s2.job.pieces[0].temp = 1050.0
	assert_true(s2.machine_engaged(), "Schwanzhammer arbeitet beim Strecken (schwer)")
	var steam := MachineData.new()
	steam.p_base = 100.0
	steam.hits_per_s = 1.0
	steam.force_mode = "adjustable"
	s.machine = steam
	assert_true(s.machine_engaged(), "Dampfhammer arbeitet in jedem Arbeitsgang")
	s.force = WorkshopSim.FORCE_LIGHT
	var kinds := []
	s.machine_hit.connect(func(k: String) -> void: kinds.append(k))
	_run(s, 1.05)
	assert_eq(kinds, ["good"], "Dampfhammer schlägt mit der gewählten (leichten) Stärke")
	var striker := StaffData.new()
	striker.p_base = 20.0
	striker.hit_interval_s = 2.0
	s.striker = striker
	assert_true(not s.striker_engaged(), "Zuschläger nur in schweren Arbeitsgängen")
