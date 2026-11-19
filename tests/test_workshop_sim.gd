extends "res://tests/test_base.gd"
## Werkstatt-Simulation: Temperatur, Schläge, Ausschuss, Schweißen, Härten, Personal, Maschinen.

const WorkshopSim = preload("res://scripts/workshop_sim.gd")
const Catalog = preload("res://scripts/catalog.gd")
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
