extends RefCounted
## Referenzspieler aus Lastenheft 5.8: 5 Schläge/s, nimmt das Werkstück bei
## min(1100 °C; T_max) aus der Esse, legt es bei 700 °C zurück, 1 s Verlust pro Umlegen.
## Dient für die geschätzte Dauer im Auftragsbuch, das Zeitlimit von Eilaufträgen,
## die Gesellen-Leistung und die Balancing-Simulation (tools/balance_sim.gd).

const WorkshopSim = preload("res://scripts/workshop_sim.gd")

var cfg: BalanceConfig
var sim: WorkshopSim
var hit_accum: float = 0.0
## Wartezeit nach dem Umlegen (Referenzverlust minus Animationsdauer)
var wait: float = 0.0


func _init(config: BalanceConfig, workshop_sim: WorkshopSim) -> void:
	cfg = config
	sim = workshop_sim


func take_temp() -> float:
	return minf(cfg.ref_take_temp, sim.t_max)


## Ein Zeitschritt des Bots (vor sim.step aufrufen).
func act(dt: float) -> void:
	if sim.job == null:
		return
	if wait > 0.0:
		wait -= dt
		return
	var moved := false
	# 1) Amboss-Stück auswerten
	if sim.anvil >= 0 and not sim.in_transit(sim.anvil):
		var i := sim.anvil
		var t: float = sim.job.pieces[i].temp
		if sim.awaiting_quench(i):
			if t <= cfg.quench_good_max - 10.0 and t >= cfg.quench_good_min:
				sim.quench(i)
				moved = true
			elif t < cfg.quench_good_min:
				moved = _reheat_anvil()
		elif sim.in_weld_phase(i):
			if t < cfg.weld_min:
				moved = _reheat_anvil()
		elif t < _return_temp(i):
			moved = _reheat_anvil()
	# 2) Rohlinge rechtzeitig nachlegen: höchstens ein Stück wartet in der Esse, und erst dann,
	#    wenn das Amboss-Stück fertig ist, bevor der neue Rohling überhitzt.
	if sim.free_slot() >= 0 and sim.next_raw() >= 0:
		var in_forge := 0
		for idx in sim.forge_slots:
			if idx >= 0:
				in_forge += 1
		if sim.anvil < 0 and in_forge == 0:
			sim.load_raw()
		elif sim.anvil >= 0 and in_forge == 0 and not sim.has_apprentice:
			var t_anvil: float = sim.job.pieces[sim.anvil].temp
			var work_left := maxf(0.0, t_anvil - cfg.ref_return_temp) / cfg.k_cool
			var heat_time := (take_temp() - cfg.room_temp) / sim.k_heat
			if work_left <= heat_time:
				sim.load_raw()
	# 3) Amboss frei: heißestes fertig aufgeheiztes Stück holen
	if sim.anvil < 0:
		var best := -1
		for idx in sim.forge_slots:
			if idx < 0 or sim.in_transit(idx):
				continue
			if sim.job.pieces[idx].temp >= _target_temp(idx) - 0.01:
				if best < 0 or sim.job.pieces[idx].temp > sim.job.pieces[best].temp:
					best = idx
		if best >= 0:
			moved = sim.move_slot_to_anvil(sim.job.pieces[best].slot) or moved
	if moved:
		wait = maxf(0.0, cfg.ref_move_loss_s - cfg.transfer_time)
		return
	# 4) Schlagen
	if sim.anvil >= 0 and not sim.in_transit(sim.anvil) and not sim.awaiting_quench(sim.anvil):
		var t2: float = sim.job.pieces[sim.anvil].temp
		var w: Vector2 = sim.step_window(sim.anvil)
		var ok := t2 >= w.x and t2 <= w.y
		if sim.in_weld_phase(sim.anvil):
			ok = t2 >= cfg.weld_min and t2 <= cfg.weld_max
		if ok:
			hit_accum += dt * cfg.reference_hits_per_s
			while hit_accum >= 1.0:
				hit_accum -= 1.0
				sim.last_player_hit = -10.0
				sim.player_hit()
				if sim.job == null or sim.anvil < 0:
					hit_accum = 0.0
					break
		else:
			hit_accum = 0.0


func _target_temp(idx: int) -> float:
	if sim.awaiting_quench(idx):
		return (cfg.quench_good_min + cfg.quench_good_max) * 0.5 + 10.0
	if sim.in_weld_phase(idx):
		return minf(sim.t_max, cfg.weld_max) - 15.0
	return minf(sim.step_window(idx).y, sim.t_max - 1.0)


## Amboss-Stück zurück ins Feuer; bei voller Esse nur gegen ein Stück tauschen, das schon heiß genug ist.
func _reheat_anvil() -> bool:
	if sim.free_slot() >= 0:
		return sim.move_anvil_to_forge(-1)
	var best := -1
	for idx in sim.forge_slots:
		if idx < 0 or sim.in_transit(idx):
			continue
		if sim.job.pieces[idx].temp >= _target_temp(idx) - 0.01:
			if best < 0 or sim.job.pieces[idx].temp > sim.job.pieces[best].temp:
				best = idx
	if best < 0:
		return false
	return sim.move_slot_to_anvil(sim.job.pieces[best].slot)


## Zurück in die Esse, sobald das Stück unter das Zielfenster seines Arbeitsgangs fällt.
func _return_temp(idx: int) -> float:
	return sim.step_window(idx).x


## Simuliert einen Auftrag mit dem Referenzspieler. Gibt die Dauer in Sekunden zurück.
## `setup` ist ein Dictionary mit k_heat, t_max, slots, hammer_power, machine, striker,
## has_apprentice, has_trough.
static func estimate_job(cfg: BalanceConfig, job: JobInstance, setup: Dictionary, dt: float = 0.1, limit_s: float = 3600.0) -> float:
	var s := WorkshopSim.new(cfg)
	apply_setup(s, setup)
	s.water_level = (cfg.water_level_min + cfg.water_level_max) * 0.5
	s.water_timer = 1.0e9
	var copy := job.duplicate_offer()
	copy.elapsed_s = 0.0
	copy.reset_pieces(cfg.room_temp)
	s.load_job(copy)
	var bot = load("res://scripts/reference_player.gd").new(cfg, s)
	var state := {"done": false}
	s.job_finished.connect(func() -> void: state["done"] = true)
	var t := 0.0
	while t < limit_s and not state["done"]:
		bot.act(dt)
		s.step(dt)
		t += dt
	return t


static func apply_setup(s: WorkshopSim, setup: Dictionary) -> void:
	s.set_forge(float(setup.get("k_heat", 25.0)), float(setup.get("t_max", 1100.0)), int(setup.get("slots", 1)))
	s.hammer_power = float(setup.get("hammer_power", 5.0))
	s.machine = setup.get("machine", null)
	s.striker = setup.get("striker", null)
	s.has_apprentice = bool(setup.get("has_apprentice", false))
	s.has_trough = bool(setup.get("has_trough", false))
	s.apprentice_to_forge_below = float(setup.get("apprentice_to_forge_below", 750.0))
	s.apprentice_to_anvil_at = float(setup.get("apprentice_to_anvil_at", 1050.0))


## Referenzleistung in Form-Punkten je Sekunde (5.8):
## (P_base × 5 + Maschinen- und Zuschläger-Schläge) × Arbeitsanteil am Amboss.
static func reference_power(cfg: BalanceConfig, setup: Dictionary) -> float:
	var t_take := minf(cfg.ref_take_temp, float(setup.get("t_max", 1100.0)))
	var span := maxf(1.0, t_take - cfg.ref_return_temp)
	var anvil_time := span / cfg.k_cool
	var reheat := span / maxf(1.0, float(setup.get("k_heat", 25.0)))
	var share := anvil_time / (anvil_time + reheat + 2.0 * cfg.ref_move_loss_s)
	var rate := float(setup.get("hammer_power", 5.0)) * cfg.reference_hits_per_s
	var m: MachineData = setup.get("machine", null)
	if m != null:
		var wf := (cfg.water_level_min + cfg.water_level_max) * 0.5 if m.water_powered else 1.0
		rate += m.p_base * m.hits_per_s * wf
	var st: StaffData = setup.get("striker", null)
	if st != null and st.hit_interval_s > 0.0:
		rate += st.p_base / st.hit_interval_s
	return rate * share
