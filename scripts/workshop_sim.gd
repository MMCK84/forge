extends RefCounted
## Simulation der Werkstatt: Esse, Amboss, Löschtrog, Maschine und Personal
## (Lastenheft 2.3–2.5, 4.4, 5.5). Rein logisch, ohne Darstellung – damit
## testbar und für das Referenzmodell (Schätzungen, Balancing) nutzbar.
## Wird in GameManager._physics_process mit festem Zeitschritt fortgeschrieben.

const HeatModel = preload("res://scripts/heat_model.gd")
const Economy = preload("res://scripts/economy.gd")

## kind: "good", "weak", "overheat", "cold", "weld", "weld_miss", "none"
signal hit_landed(kind: String, gain: float)
signal piece_moved(piece_index: int, to: String)
signal piece_ruined(piece_index: int, reason: String)
signal piece_finished(piece_index: int)
signal weld_phase_started(piece_index: int)
## Ein Stück beginnt einen neuen Arbeitsgang (Index in job.steps)
signal step_changed(piece_index: int, step: int)
signal weld_completed(piece_index: int)
signal ready_to_quench(piece_index: int)
signal quench_done(piece_index: int, result: String, temp: float)
signal job_finished()
signal machine_hit(kind: String)
signal striker_hit(kind: String)
## Kosten, die während der Arbeit entstehen (Ausschuss, Dampf-Betriebskosten)
signal cost_incurred(pence: int, reason: String)

const EPS := 0.0001

var cfg: BalanceConfig
var job: JobInstance = null

# --- Ausrüstung ---
var k_heat: float = 25.0
var t_max: float = 1100.0
var slot_count: int = 1
var hammer_power: float = 5.0
var machine: MachineData = null
var has_trough: bool = false
var has_apprentice: bool = false
var striker: StaffData = null
var apprentice_to_forge_below: float = 750.0
var apprentice_to_anvil_at: float = 1050.0
# --- Werkstatt-Einrichtung (scripts/furnishings.gd) ---
## Zielfenster je Seite breiter (°C)
var window_bonus: float = 0.0
## Faktor auf jeden Gefügeschaden
var damage_factor: float = 1.0
## Faktor auf die Materialkosten bei Ausschuss
var ruin_cost_factor: float = 1.0
## Faktor auf die Handarbeit an großen Schmiedestücken (Kran)
var big_factor_mult: float = 1.0

# --- Zustand ---
var forge_slots: Array = []
var anvil: int = -1
## Stückindex -> verbleibende Umlegezeit
var transit: Dictionary = {}
var selected_slot: int = 0
var sim_time: float = 0.0
var last_player_hit: float = -10.0
var machine_timer: float = 0.0
## Maschinen schlagen nur auf Kommando: gehalten = fortlaufend
var machine_hold: bool = false
var last_machine_blow: float = -10.0
## Zeitpunkt des letzten getippten Maschinenschlags (gegen einen Doppelschlag direkt danach)
var last_machine_tap: float = -10.0
var striker_timer: float = 0.0
var steam_cost_accum: float = 0.0
var water_level: float = 1.0
var water_timer: float = 240.0
var apprentice_timer: float = 0.0
## Zähler für Statistik
var pieces_ruined: int = 0

## Schlagstärke: 0 = leicht, 1 = mittel, 2 = schwer
const FORCE_LIGHT := 0
const FORCE_MEDIUM := 1
const FORCE_HEAVY := 2
## Vom Spieler gewählte Stärke
var force: int = FORCE_MEDIUM
## false: Stärke spielt keine Rolle (Tutorial) – jeder Schlag gilt als passend
var force_enabled: bool = true
## true: immer die verlangte Stärke (Referenzspieler, Schätzungen)
var auto_force: bool = false

var rng := RandomNumberGenerator.new()


func _init(config: BalanceConfig = null) -> void:
	cfg = config
	rng.randomize()
	set_forge(25.0, 1100.0, 1)


func set_forge(heat_rate: float, max_temp: float, slots: int) -> void:
	k_heat = heat_rate
	t_max = max_temp
	slot_count = maxi(1, slots)
	var old: Array = forge_slots.duplicate()
	forge_slots.clear()
	for i in slot_count:
		forge_slots.append(-1)
	# Werkstücke in überzähligen Plätzen landen in freien Plätzen oder zurück auf dem Stapel
	for idx in old:
		if idx is int and idx >= 0:
			var s := free_slot()
			if s >= 0:
				forge_slots[s] = idx
				_piece(idx).slot = s
			elif job != null:
				_piece(idx).location = JobInstance.LOC_RAW
				_piece(idx).slot = -1
	selected_slot = clampi(selected_slot, 0, slot_count - 1)


## Neuen (oder geladenen) Auftrag übernehmen. Positionen werden aus den Stücken rekonstruiert.
func load_job(j: JobInstance) -> void:
	job = j
	anvil = -1
	transit.clear()
	machine_timer = 0.0
	striker_timer = 0.0
	for i in slot_count:
		forge_slots[i] = -1
	if job == null:
		return
	if job.pieces.is_empty():
		job.reset_pieces(cfg.room_temp)
	for i in job.pieces.size():
		var p: JobInstance.Piece = job.pieces[i]
		if p.location == JobInstance.LOC_ANVIL:
			if anvil < 0:
				anvil = i
			else:
				_place_in_forge_or_raw(i)
		elif p.location == JobInstance.LOC_FORGE:
			if p.slot >= 0 and p.slot < slot_count and forge_slots[p.slot] == -1:
				forge_slots[p.slot] = i
			else:
				_place_in_forge_or_raw(i)


func _place_in_forge_or_raw(i: int) -> void:
	var p: JobInstance.Piece = _piece(i)
	var s := free_slot()
	if s >= 0:
		forge_slots[s] = i
		p.location = JobInstance.LOC_FORGE
		p.slot = s
	else:
		p.location = JobInstance.LOC_RAW
		p.slot = -1


func clear_job() -> void:
	job = null
	anvil = -1
	transit.clear()
	for i in slot_count:
		forge_slots[i] = -1


func _piece(i: int) -> JobInstance.Piece:
	return job.pieces[i]


# ------------------------------------------------------------------ Abfragen

func has_job() -> bool:
	return job != null


func free_slot() -> int:
	for i in forge_slots.size():
		if forge_slots[i] == -1:
			return i
	return -1


func raw_count() -> int:
	if job == null:
		return 0
	var n := 0
	for p in job.pieces:
		if p.location == JobInstance.LOC_RAW:
			n += 1
	return n


func next_raw() -> int:
	if job == null:
		return -1
	for i in job.pieces.size():
		if _piece(i).location == JobInstance.LOC_RAW:
			return i
	return -1


func in_transit(i: int) -> bool:
	return transit.has(i)


func is_complete(i: int) -> bool:
	return _piece(i).progress >= job.piece_fp() - EPS


func awaiting_quench(i: int) -> bool:
	var p: JobInstance.Piece = _piece(i)
	return job.needs_harden() and is_complete(i) and not p.quenched and p.location != JobInstance.LOC_DONE


func in_weld_phase(i: int) -> bool:
	if job == null or not job.needs_weld():
		return false
	var p: JobInstance.Piece = _piece(i)
	return p.weld_hits < cfg.weld_hits_required and p.progress >= job.piece_fp() * cfg.weld_at_progress - EPS


## Stahl wird kühler geschmiedet: alle Temperaturgrenzen liegen um diesen Betrag tiefer.
func temp_offset() -> float:
	if job != null and job.is_steel():
		return cfg.steel_temp_offset
	return 0.0


## Temperatur, ab der das Werkstück verbrennt (Werkstoff berücksichtigt).
func burn_temp() -> float:
	return cfg.burn_limit - temp_offset()


## Verlangte Schlagstärke für den aktuellen Arbeitsgang eines Stücks (-1 = beliebig,
## z. B. Aufträge ohne Arbeitsgänge).
func required_force(i: int) -> int:
	if job == null:
		return -1
	var sid := job.step_id(step_index(i))
	if sid == "" or not cfg.step_force.has(sid):
		return -1
	var f := int(cfg.step_force[sid])
	if f == FORCE_MEDIUM and job.epoch <= cfg.force_simple_until_epoch:
		f = FORCE_HEAVY
	return f


## Stärke, mit der tatsächlich geschlagen wird (Spieler-Wahl oder automatisch passend).
func effective_force(i: int) -> int:
	var req := required_force(i)
	if req >= 0 and (auto_force or not force_enabled):
		return req
	return clampi(force, FORCE_LIGHT, FORCE_HEAVY)


## Anteil der Form-Punkte bei gewählter vs. verlangter Stärke.
func force_factor(used: int, req: int) -> float:
	if req < 0:
		return 1.0
	var d := used - req
	if d == 0:
		return 1.0
	if absi(d) == 1:
		return cfg.force_gain_off_one
	return cfg.force_gain_too_hard if d > 0 else cfg.force_gain_too_soft


func step_index(i: int) -> int:
	if job == null:
		return 0
	return job.step_index_at(_piece(i).progress / maxf(job.piece_fp(), EPS))


## Zielfenster (min, max) des aktuellen Arbeitsgangs eines Stücks.
func step_window(i: int) -> Vector2:
	if job == null:
		return HeatModel.window(cfg, false)
	return window_for_step(job.step_id(step_index(i)))


func window_for_step(step_id: String) -> Vector2:
	var w: Vector2
	if step_id == "" or not cfg.step_windows.has(step_id):
		w = HeatModel.window(cfg, job.is_precision() if job != null else false)
		return w + Vector2(-window_bonus, window_bonus)
	var arr: Array = cfg.step_windows[step_id]
	w = Vector2(float(arr[0]), float(arr[1])) - Vector2.ONE * temp_offset()
	if job != null and job.is_precision():
		var mid := (w.x + w.y) * 0.5
		var half := (w.y - w.x) * 0.5 * cfg.precision_window_keep
		w = Vector2(mid - half, mid + half)
	return w + Vector2(-window_bonus, window_bonus)


func anvil_piece() -> JobInstance.Piece:
	if job == null or anvil < 0:
		return null
	return _piece(anvil)


## Index des Werkstücks, das Anzeigen (Glutskala) zeigen sollen.
func focus_piece() -> int:
	if job == null:
		return -1
	if anvil >= 0:
		return anvil
	if selected_slot < forge_slots.size() and forge_slots[selected_slot] >= 0:
		return forge_slots[selected_slot]
	var best := -1
	for idx in forge_slots:
		if idx >= 0 and (best < 0 or _piece(idx).temp > _piece(best).temp):
			best = idx
	return best


func hottest_forge_piece() -> int:
	var best := -1
	for idx in forge_slots:
		if idx >= 0 and not in_transit(idx) and (best < 0 or _piece(idx).temp > _piece(best).temp):
			best = idx
	return best


func total_progress_ratio() -> float:
	if job == null or job.pieces.is_empty():
		return 0.0
	var sum := 0.0
	for i in job.pieces.size():
		var p: JobInstance.Piece = _piece(i)
		if p.location == JobInstance.LOC_DONE:
			sum += 1.0
		else:
			sum += clampf(p.progress / maxf(job.piece_fp(), EPS), 0.0, 1.0)
	return sum / float(job.pieces.size())


func water_factor() -> float:
	if machine != null and machine.water_powered:
		return water_level
	return 1.0


# ------------------------------------------------------------------ Aktionen

## Rohling in einen freien Esse-Platz legen. Gibt den Stückindex zurück oder -1.
func load_raw(slot: int = -1) -> int:
	if job == null:
		return -1
	var idx := next_raw()
	if idx < 0:
		return -1
	if slot < 0 or slot >= slot_count or forge_slots[slot] != -1:
		slot = free_slot()
	if slot < 0:
		return -1
	var p: JobInstance.Piece = _piece(idx)
	forge_slots[slot] = idx
	p.location = JobInstance.LOC_FORGE
	p.slot = slot
	transit[idx] = cfg.transfer_time
	piece_moved.emit(idx, JobInstance.LOC_FORGE)
	return idx


## Werkstück aus einem Esse-Platz auf den Amboss legen (tauscht, falls der Amboss belegt ist).
func move_slot_to_anvil(slot: int) -> bool:
	if job == null or slot < 0 or slot >= slot_count:
		return false
	var idx: int = forge_slots[slot]
	if idx < 0 or in_transit(idx):
		return false
	if anvil >= 0:
		if in_transit(anvil):
			return false
		var old := anvil
		var po: JobInstance.Piece = _piece(old)
		po.location = JobInstance.LOC_FORGE
		po.slot = slot
		forge_slots[slot] = old
		transit[old] = cfg.transfer_time
		piece_moved.emit(old, JobInstance.LOC_FORGE)
	else:
		forge_slots[slot] = -1
	var p: JobInstance.Piece = _piece(idx)
	p.location = JobInstance.LOC_ANVIL
	p.slot = -1
	anvil = idx
	transit[idx] = cfg.transfer_time
	piece_moved.emit(idx, JobInstance.LOC_ANVIL)
	return true


## Werkstück vom Amboss in die Esse legen (freier oder angegebener Platz; tauscht bei belegtem Platz).
func move_anvil_to_forge(slot: int = -1) -> bool:
	if job == null or anvil < 0 or in_transit(anvil):
		return false
	if slot >= 0 and slot < slot_count and forge_slots[slot] != -1:
		return move_slot_to_anvil(slot)
	if slot < 0 or slot >= slot_count:
		slot = free_slot()
	if slot < 0:
		return false
	var idx := anvil
	var p: JobInstance.Piece = _piece(idx)
	p.location = JobInstance.LOC_FORGE
	p.slot = slot
	forge_slots[slot] = idx
	anvil = -1
	transit[idx] = cfg.transfer_time
	piece_moved.emit(idx, JobInstance.LOC_FORGE)
	return true


## Tastatur "E": sinnvolle Umlege-Aktion je nach Lage.
func smart_move() -> bool:
	if job == null:
		return false
	if anvil >= 0:
		if free_slot() >= 0:
			return move_anvil_to_forge(-1)
		# Esse voll: mit dem gewählten (sonst dem heißesten) Stück tauschen
		var sw := selected_slot if selected_slot < slot_count and forge_slots[selected_slot] >= 0 else -1
		if sw < 0:
			var h0 := hottest_forge_piece()
			sw = _piece(h0).slot if h0 >= 0 else -1
		return move_slot_to_anvil(sw) if sw >= 0 else false
	var s := selected_slot
	if s < slot_count and forge_slots[s] >= 0:
		return move_slot_to_anvil(s)
	var h := hottest_forge_piece()
	if h >= 0:
		return move_slot_to_anvil(_piece(h).slot)
	return load_raw() >= 0


## Abschrecken im Löschtrog (4.4.2). Bevorzugt das Amboss-Stück, sonst das gewählte bzw. heißeste fertige Stück.
func quench(piece_index: int = -1) -> bool:
	if job == null or not has_trough or not job.needs_harden():
		return false
	var idx := piece_index
	if idx < 0:
		if anvil >= 0 and awaiting_quench(anvil):
			idx = anvil
		else:
			for s in forge_slots:
				if s >= 0 and awaiting_quench(s) and (idx < 0 or _piece(s).temp > _piece(idx).temp):
					idx = s
	if idx < 0 or not awaiting_quench(idx) or in_transit(idx):
		return false
	var p: JobInstance.Piece = _piece(idx)
	var t := p.temp
	var res: Dictionary = HeatModel.quench_result(cfg, t)
	p.quench_penalty = float(res["penalty"])
	p.quenched = true
	job.quench_temp = t
	p.temp = cfg.room_temp
	quench_done.emit(idx, str(res["result"]), t)
	_finish_piece(idx)
	return true


## Hammerschlag des Spielers. Gibt die Art des Schlags zurück ("none", wenn ignoriert).
func player_hit() -> String:
	if job == null or anvil < 0 or in_transit(anvil):
		return "none"
	var min_interval := 1.0 / cfg.max_hits_per_s
	if sim_time - last_player_hit < min_interval - EPS:
		return "none"
	last_player_hit = sim_time
	var power := hammer_power
	if job.is_big():
		power *= minf(1.0, cfg.big_manual_factor * big_factor_mult)
	return _strike(anvil, power, true, effective_force(anvil))


func _strike(idx: int, power: float, is_player: bool, used_force: int = -1) -> String:
	var p: JobInstance.Piece = _piece(idx)
	if p.location == JobInstance.LOC_DONE or is_complete(idx):
		return "none"
	var t := p.temp
	var te := t + temp_offset()
	var kind := "none"
	if te < cfg.cold_limit:
		p.damage += cfg.cold_hit_damage * damage_factor
		kind = "cold"
		if is_player:
			hit_landed.emit(kind, 0.0)
		_check_damage(idx)
		return kind
	if in_weld_phase(idx):
		if not is_player:
			return "none"
		if HeatModel.in_weld_window(cfg, t):
			p.weld_hits += 1
			kind = "weld"
			hit_landed.emit(kind, 0.0)
			if p.weld_hits >= cfg.weld_hits_required:
				weld_completed.emit(idx)
				step_changed.emit(idx, step_index(idx))
		else:
			kind = "weld_miss"
			hit_landed.emit(kind, 0.0)
		return kind
	var fp := job.piece_fp()
	var cap := fp
	var weld_pending := job.needs_weld() and p.weld_hits < cfg.weld_hits_required
	if weld_pending:
		cap = fp * cfg.weld_at_progress
	var req := required_force(idx)
	var used := req if used_force < 0 else used_force
	var fdiff := 0 if req < 0 else used - req
	if fdiff >= 2:
		p.damage += cfg.force_too_hard_damage * damage_factor
	var gain := power * HeatModel.multiplier(cfg, te) * force_factor(used, req)
	gain = clampf(gain, 0.0, maxf(0.0, cap - p.progress))
	var step_before := step_index(idx)
	var w := step_window(idx)
	p.progress += gain
	var in_win := t >= w.x and t <= w.y and fdiff == 0
	if in_win:
		p.points_in_window += gain
	var z := HeatModel.zone(cfg, te)
	if z == HeatModel.ZONE_OVERHEAT:
		kind = "overheat"
	elif fdiff > 0:
		kind = "too_hard"
	elif fdiff < 0:
		kind = "too_soft"
	elif in_win:
		kind = "good"
	elif z == HeatModel.ZONE_OPTIMAL:
		kind = "off"
	else:
		kind = "weak"
	if is_player:
		hit_landed.emit(kind, gain)
	var step_after := step_index(idx)
	if step_after != step_before and p.progress < fp - EPS and not (weld_pending and p.progress >= cap - EPS):
		step_changed.emit(idx, step_after)
	if weld_pending and p.progress >= cap - EPS:
		p.progress = cap
		weld_phase_started.emit(idx)
	elif p.progress >= fp - EPS:
		p.progress = fp
		if job.needs_harden() and not p.quenched:
			ready_to_quench.emit(idx)
		else:
			_finish_piece(idx)
			return kind
	if fdiff >= 2:
		_check_damage(idx)
	return kind


func _finish_piece(idx: int) -> void:
	var p: JobInstance.Piece = _piece(idx)
	if anvil == idx:
		anvil = -1
	if p.slot >= 0 and p.slot < slot_count and forge_slots[p.slot] == idx:
		forge_slots[p.slot] = -1
	p.location = JobInstance.LOC_DONE
	p.slot = -1
	transit.erase(idx)
	piece_finished.emit(idx)
	if job.all_done():
		job_finished.emit()


func _ruin(idx: int, reason: String) -> void:
	var p: JobInstance.Piece = _piece(idx)
	if anvil == idx:
		anvil = -1
	if p.slot >= 0 and p.slot < slot_count and forge_slots[p.slot] == idx:
		forge_slots[p.slot] = -1
	transit.erase(idx)
	p.progress = 0.0
	p.points_in_window = 0.0
	p.damage = 0.0
	p.weld_hits = 0
	p.quenched = false
	p.quench_penalty = 0.0
	p.temp = cfg.room_temp
	p.location = JobInstance.LOC_RAW
	p.slot = -1
	pieces_ruined += 1
	piece_ruined.emit(idx, reason)
	var per_piece := float(job.reward_base_pence) / float(maxi(1, job.quantity))
	cost_incurred.emit(Economy.round_half_up(per_piece * cfg.ruin_material_cost * ruin_cost_factor), "ruin")


func _check_damage(idx: int) -> void:
	if _piece(idx).damage >= 1.0 - EPS:
		_ruin(idx, "damage")


# ------------------------------------------------------------------ Zeitschritt

func step(dt: float) -> void:
	sim_time += dt
	_update_water(dt)
	if job == null:
		return
	job.elapsed_s += dt
	var release := _hold_release_piece()
	for i in job.pieces.size():
		var p: JobInstance.Piece = _piece(i)
		if p.location == JobInstance.LOC_DONE or p.location == JobInstance.LOC_RAW:
			continue
		if in_transit(i):
			continue
		if p.location == JobInstance.LOC_FORGE:
			var cap := t_max
			# Der Lehrling passt auf die Esse auf: Schweißstücke lässt er bis zur Schweißhitze kommen
			# (auch wenn der Amboss belegt ist – sonst kämen sie nie an die Reihe), alle anderen Stücke
			# hält er auf Arbeitshitze, damit nichts unbemerkt überhitzt.
			if has_apprentice and i != release:
				if in_weld_phase(i):
					cap = minf(cap, apprentice_take_temp(i))
				elif anvil != i:
					cap = minf(cap, apprentice_hold_temp(i))
			if p.temp < cap:
				var rate := k_heat if p.temp < cfg.optimal_max else minf(k_heat, cfg.white_heat_rate)
				var t_new := p.temp + rate * dt
				# Übergang in die Weißglut innerhalb eines Zeitschritts: ab optimal_max langsamer weiter
				if p.temp < cfg.optimal_max and t_new > cfg.optimal_max:
					var rest := dt - (cfg.optimal_max - p.temp) / k_heat
					t_new = cfg.optimal_max + minf(k_heat, cfg.white_heat_rate) * rest
				p.temp = minf(t_new, cap)
		elif p.location == JobInstance.LOC_ANVIL:
			p.temp = maxf(p.temp - cfg.k_cool * dt, cfg.room_temp)
		var te := p.temp + temp_offset()
		if te > cfg.optimal_max:
			p.damage += HeatModel.overheat_damage_rate(cfg, te) * dt * damage_factor
		if te > cfg.burn_limit:
			_ruin(i, "burned")
			continue
		_check_damage(i)
	if job == null:
		return
	# Umlegezeit erst nach der Physik herunterzählen: genau transfer_time ohne Temperaturänderung.
	for k in transit.keys():
		transit[k] = float(transit[k]) - dt
		if transit[k] <= 0.000001:
			transit.erase(k)
	_step_machine(dt)
	_step_striker(dt)
	_step_apprentice(dt)


func _update_water(dt: float) -> void:
	water_timer -= dt
	if water_timer <= 0.0:
		water_timer = rng.randf_range(cfg.water_change_min_s, cfg.water_change_max_s)
		water_level = rng.randf_range(cfg.water_level_min, cfg.water_level_max)


func _auto_target_ok() -> bool:
	if anvil < 0 or in_transit(anvil) or is_complete(anvil):
		return false
	return _piece(anvil).temp + temp_offset() >= cfg.auto_hit_min_temp


## Schlägt die Maschine im aktuellen Arbeitsgang mit? Schwanzhämmer nur bei schweren
## Arbeitsgängen, Dampfhämmer (einstellbare Stärke) immer.
func machine_engaged() -> bool:
	if machine == null or not _auto_target_ok():
		return false
	if machine.force_mode == "adjustable":
		# Dampfhammer: bei viel zu harter Wahl (schwer statt leicht) hält der Hammerführer an,
		# statt das Werkstück zu beschädigen – der Spieler muss umstellen
		var r := required_force(anvil)
		return r < 0 or effective_force(anvil) - r < 2
	if job.is_big():
		return true
	var req := required_force(anvil)
	return req < 0 or req == FORCE_HEAVY


## Schlagstärke der Maschine: Dampfhämmer nach Wahl; Schwanzhämmer schwer – bei
## Großschmiedestücken dosiert der Hammerschmied den Schlag über den Antrieb (passend).
func _machine_force() -> int:
	if machine.force_mode == "adjustable":
		return effective_force(anvil)
	if job.is_big():
		return required_force(anvil)
	return FORCE_HEAVY


## Alle Maschinen bedient der Spieler selbst (einheitliche Steuerung): Tippen = ein Schlag,
## Halten = fortlaufend. Schwanzhämmer schlagen dabei nur schwer und ruhen in leichten Arbeitsgängen.
func machine_commanded() -> bool:
	return machine != null


## Ein Dampfhammer-Schlag auf Kommando (Tippen). Gibt die Art des Schlags zurück ("none", wenn nicht möglich).
func command_machine_blow() -> String:
	if job == null or not machine_commanded() or not machine_engaged():
		return "none"
	if sim_time - last_machine_blow < 1.0 / maxf(machine.hits_per_s, 0.01) - EPS:
		return "none"
	last_machine_blow = sim_time
	last_machine_tap = sim_time
	var kind := _strike(anvil, machine.p_base * water_factor(), false, _machine_force())
	machine_hit.emit(kind)
	if machine.cost_per_minute > 0:
		steam_cost_accum += float(machine.cost_per_minute) / 60.0 / maxf(machine.hits_per_s, 0.01)
	return kind


func _step_machine(dt: float) -> void:
	if not machine_engaged() or (machine_commanded() and not machine_hold):
		machine_timer = 0.0
		return
	machine_timer += dt
	var interval := 1.0 / maxf(machine.hits_per_s, 0.01)
	while machine_timer >= interval and machine_engaged():
		machine_timer -= interval
		if sim_time - last_machine_tap < interval - EPS:
			continue
		last_machine_blow = sim_time
		var kind := _strike(anvil, machine.p_base * water_factor(), false, _machine_force())
		machine_hit.emit(kind)
		if job == null:
			return
	if machine.cost_per_minute > 0:
		steam_cost_accum += float(machine.cost_per_minute) / 60.0 * dt
		if steam_cost_accum >= 1.0:
			var whole := int(floor(steam_cost_accum))
			steam_cost_accum -= whole
			cost_incurred.emit(whole, "steam")


## Der Zuschläger schlägt mit dem Vorschlaghammer nur in schweren Arbeitsgängen mit.
func striker_engaged() -> bool:
	if striker == null or striker.hit_interval_s <= 0.0 or not _auto_target_ok():
		return false
	var req := required_force(anvil)
	return req < 0 or req == FORCE_HEAVY


func _step_striker(dt: float) -> void:
	if not striker_engaged():
		striker_timer = 0.0
		return
	striker_timer += dt
	while striker_timer >= striker.hit_interval_s and striker_engaged():
		striker_timer -= striker.hit_interval_s
		var power := striker.p_base
		if job.is_big():
			power *= minf(1.0, cfg.big_manual_factor * big_factor_mult)
		var kind := _strike(anvil, power, false, FORCE_HEAVY)
		striker_hit.emit(kind)
		if job == null:
			return


## Lehrling: legt Werkstücke nach einstellbaren Schwellen um (5.5).
func _step_apprentice(dt: float) -> void:
	if not has_apprentice or job == null:
		return
	apprentice_timer += dt
	if apprentice_timer < 0.1:
		return
	apprentice_timer = 0.0
	if anvil >= 0 and not in_transit(anvil) and _anvil_needs_reheat():
		if free_slot() >= 0:
			move_anvil_to_forge(-1)
		else:
			# Esse voll: gegen das heißeste bereite Stück tauschen
			var swap := _apprentice_ready_piece()
			if swap >= 0:
				move_slot_to_anvil(_piece(swap).slot)
	if anvil < 0:
		# Fertig geschmiedete Härte-Stücke bei Abschrecktemperatur auf den Amboss holen (sonst verbrennen sie).
		for idx in forge_slots:
			if idx >= 0 and not in_transit(idx) and awaiting_quench(idx) and _piece(idx).temp >= cfg.quench_good_max - 10.0:
				move_slot_to_anvil(_piece(idx).slot)
				break
	if anvil < 0:
		var best := _apprentice_ready_piece()
		if best >= 0:
			move_slot_to_anvil(_piece(best).slot)
	if free_slot() >= 0 and next_raw() >= 0:
		load_raw()


## Muss das Amboss-Stück nachgewärmt werden, darf genau ein wartendes Stück (das heißeste) weiter aufheizen.
func _hold_release_piece() -> int:
	if not has_apprentice or anvil < 0 or not _anvil_needs_reheat():
		return -1
	var best := -1
	for idx in forge_slots:
		if idx < 0 or awaiting_quench(idx):
			continue
		if best < 0 or _piece(idx).temp > _piece(best).temp:
			best = idx
	return best


func _apprentice_ready_piece() -> int:
	var best := -1
	for idx in forge_slots:
		if idx < 0 or in_transit(idx) or awaiting_quench(idx):
			continue
		if _piece(idx).temp >= apprentice_take_temp(idx) - EPS:
			if best < 0 or _piece(idx).temp > _piece(best).temp:
				best = idx
	return best


## Muss das Amboss-Stück zurück ins Feuer? (Härte-Stücke bleiben dem Spieler überlassen)
func _anvil_needs_reheat() -> bool:
	if anvil < 0:
		return false
	if awaiting_quench(anvil):
		# Fertiges Härte-Stück ist unter die Abschrecktemperatur abgekühlt: nachwärmen
		return _piece(anvil).temp < cfg.quench_good_min
	return _piece(anvil).temp < low_temp_for(anvil)


func low_temp_for(idx: int) -> float:
	if in_weld_phase(idx):
		return cfg.weld_min + 5.0
	return maxf(apprentice_to_forge_below - temp_offset(), step_window(idx).x)


## Solange der Amboss belegt ist, hält der Lehrling wartende Stücke am Rand des Feuers bei dieser Temperatur.
func apprentice_hold_temp(idx: int) -> float:
	if awaiting_quench(idx):
		return cfg.quench_good_max - 10.0
	if in_weld_phase(idx):
		return cfg.optimal_max
	return apprentice_take_temp(idx)


func apprentice_take_temp(idx: int) -> float:
	if in_weld_phase(idx):
		return minf(t_max, cfg.weld_max) - 15.0
	return minf(minf(apprentice_to_anvil_at - temp_offset(), step_window(idx).y), t_max - 1.0)


# ------------------------------------------------------------------ Bewertung

## Ergebnis eines fertigen Auftrags: Trefferquote, Schaden, Q, Sterne (2.6).
func evaluate() -> Dictionary:
	var total := 0.0
	var in_win := 0.0
	var dmg := 0.0
	var pen := 0.0
	var n := 0
	for p in job.pieces:
		total += p.progress
		in_win += p.points_in_window
		dmg += p.damage
		pen += p.quench_penalty
		n += 1
	var quote := in_win / total if total > EPS else 0.0
	var avg_dmg := dmg / float(maxi(1, n))
	var avg_pen := pen / float(maxi(1, n))
	var q := Economy.quality_value(cfg, quote, avg_dmg, avg_pen)
	return {
		"hit_quote": quote, "damage": avg_dmg, "quench_penalty": avg_pen,
		"q": q, "stars": Economy.star_count(cfg, q),
	}
