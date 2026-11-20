extends Node
## GameManager (Lastenheft 8.2): hält den Spielzustand (Geld, Ausrüstung, Personal,
## Epoche, Aufträge) und verteilt Änderungen über Signale. Formeln liegen in
## scripts/economy.gd und scripts/heat_model.gd, die Werkstatt-Logik in scripts/workshop_sim.gd.

const Economy = preload("res://scripts/economy.gd")
const HeatModel = preload("res://scripts/heat_model.gd")
const WorkshopSim = preload("res://scripts/workshop_sim.gd")
const JobGenerator = preload("res://scripts/job_generator.gd")
const ReferencePlayer = preload("res://scripts/reference_player.gd")
const Catalog = preload("res://scripts/catalog.gd")
const Localization = preload("res://scripts/localization.gd")
const Furnishings = preload("res://scripts/furnishings.gd")
const Mastery = preload("res://scripts/mastery.gd")
const Masterpieces = preload("res://scripts/masterpieces.gd")

const GAME_VERSION := "0.1.0"
const EPOCH_YEARS := ["1700–1715", "1715–1735", "1735–1750", "1750–1765", "1765–1785", "1785–1800", "1800–1820", "1820–1839", "1839–1860", "1860–1880"]
## Anzahl der Epochen
const EPOCH_COUNT := 10

# --- Signale (8.3) ---
signal pence_changed(new_total: int, delta: int)
signal temp_changed(piece_index: int, temp: float)
signal job_progress_changed(piece_index: int, progress: float, total: float)
signal piece_ruined(piece_index: int, reason: String)
signal job_completed(job: JobInstance, stars: int, payout: int)
signal purchase_made(item_id: String, price: int)
signal epoch_unlocked(epoch: int)
# --- Zusätzliche Signale für UI und Audio ---
signal state_changed()
signal offers_changed()
signal active_job_changed()
signal settlement_ready(report: Dictionary)
signal hint_requested(hint_id: String)
signal offline_earnings_ready(pence: int, seconds: float)
## kind z. B. "hit_good", "hit_cold", "move", "weld", "quench_good", "machine", "ruin_burned" ...
signal sim_event(kind: String, data: Dictionary)
signal settings_changed()
signal message(text_key: String, args: Dictionary)

var cfg: BalanceConfig = Catalog.BALANCE
var hammers: Dictionary = {}
var forges: Dictionary = {}
var machines: Dictionary = {}
var staff: Dictionary = {}
var items: Dictionary = {}
var customers: Dictionary = {}
var milestones: Dictionary = {}
## Epoche -> nach index sortierte Meilensteine
var milestones_by_epoch: Dictionary = {}

var sim: WorkshopSim
var generator: JobGenerator

# --- Spielzustand ---
var in_game: bool = false
var sim_paused: bool = false
var created_at: int = 0
var playtime_seconds: float = 0.0
var total_pence: int = 0
var lifetime_pence: int = 0
var equipped_hammer_id: String = "hammer_hand"
var hammer_levels: Dictionary = {}
var owned_hammer_ids: Array = []
var equipped_forge_id: String = "forge_clay"
var owned_forge_ids: Array = []
var active_machine_id: String = ""
var owned_machine_ids: Array = []
var hired_ids: Array = []
var apprentice_to_forge_below: float = 750.0
var apprentice_to_anvil_at: float = 1050.0
var current_epoch: int = 1
## Werkstatt-Einrichtung der aktuellen Epoche: gekaufte Plätze (scripts/furnishings.gd)
var furnished: Array = []
## Meisterschaft je Werkstück: item_id -> {"jobs": n, "best": Sterne}
var mastery: Dictionary = {}
## Meisterstück: Abschluss-Meilenstein -> Anzahl bestandener Teile
var masterpiece_progress: Dictionary = {}
## Meisterstück: Abschluss-Meilenstein -> nicht bestandene Versuche am aktuellen Teil
var masterpiece_fails: Dictionary = {}
var jobs_completed_in_epoch: int = 0
var completed_milestone_ids: Array = []
var generator_seed: int = 0
var reroll_available_at: int = 0
var free_play: bool = false
var job_offers: Array = []
var active_job: JobInstance = null
var stats: Dictionary = {}
var seen_hints: Array = []
var cosmetics: Array = []
var settings: Dictionary = {}

var _journeyman_accum: float = 0.0
var _journeyman_timer: float = 0.0
var _pending_finish: bool = false
var pending_offline: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Localization.load_translations()
	_index_catalog()
	_setup_input()
	settings = default_settings()
	sim = WorkshopSim.new(cfg)
	generator = JobGenerator.new(cfg, Catalog.ITEMS, Catalog.CUSTOMERS)
	_connect_sim()
	apply_settings()


func _index_catalog() -> void:
	for h in Catalog.HAMMERS:
		hammers[h.id] = h
	for f in Catalog.FORGES:
		forges[f.id] = f
	for m in Catalog.MACHINES:
		machines[m.id] = m
	for s in Catalog.STAFF:
		staff[s.id] = s
	for it in Catalog.ITEMS:
		items[it.id] = it
	for c in Catalog.CUSTOMERS:
		customers[c.id] = c
	for ms in Catalog.MILESTONES:
		milestones[ms.id] = ms
		if not milestones_by_epoch.has(ms.epoch):
			milestones_by_epoch[ms.epoch] = []
		milestones_by_epoch[ms.epoch].append(ms)
	for e in milestones_by_epoch.keys():
		milestones_by_epoch[e].sort_custom(func(a, b): return a.index < b.index)


func _setup_input() -> void:
	var keys := {
		"hammer": [KEY_SPACE], "move_piece": [KEY_E], "load_raw": [KEY_R],
		"select_1": [KEY_1], "select_2": [KEY_2], "select_3": [KEY_3],
		"quench": [KEY_Q], "open_jobs": [KEY_J], "open_shop": [KEY_S],
		"open_staff": [KEY_P], "pause": [KEY_ESCAPE], "test_menu": [KEY_F12],
	}
	for action in keys:
		if InputMap.has_action(action):
			continue
		InputMap.add_action(action)
		for k in keys[action]:
			var ev := InputEventKey.new()
			ev.physical_keycode = k
			InputMap.action_add_event(action, ev)


func _connect_sim() -> void:
	sim.hit_landed.connect(_on_hit_landed)
	sim.piece_moved.connect(func(i: int, to: String) -> void: sim_event.emit("move", {"piece": i, "to": to}))
	sim.piece_ruined.connect(_on_piece_ruined)
	sim.piece_finished.connect(func(i: int) -> void: sim_event.emit("piece_done", {"piece": i}))
	sim.weld_phase_started.connect(func(i: int) -> void: sim_event.emit("weld_phase", {"piece": i}))
	sim.step_changed.connect(_on_step_changed)
	sim.weld_completed.connect(func(i: int) -> void: sim_event.emit("weld_done", {"piece": i}))
	sim.ready_to_quench.connect(func(i: int) -> void: sim_event.emit("ready_to_quench", {"piece": i}))
	sim.quench_done.connect(_on_quench_done)
	sim.machine_hit.connect(func(kind: String) -> void: sim_event.emit("machine", {"kind": kind}))
	sim.striker_hit.connect(func(kind: String) -> void: sim_event.emit("striker", {"kind": kind}))
	sim.cost_incurred.connect(_on_cost)
	sim.streak_changed.connect(func(n: int, lv: int, broke: bool) -> void: sim_event.emit("streak", {"count": n, "level": lv, "broke": broke}))
	sim.job_finished.connect(func() -> void: _pending_finish = true)


func _on_hit_landed(kind: String, gain: float) -> void:
	stats["hits"] = int(stats.get("hits", 0)) + 1
	sim_event.emit("hit_" + kind, {"gain": gain})


func _on_step_changed(i: int, step: int) -> void:
	if active_job != null:
		sim_event.emit("step", {"piece": i, "step": step, "id": active_job.step_id(step)})


func _on_quench_done(i: int, result: String, t: float) -> void:
	sim_event.emit("quench_" + result, {"piece": i, "temp": t})


# ================================================================== Ablauf

func _physics_process(delta: float) -> void:
	if not in_game or sim_paused:
		return
	playtime_seconds += delta
	sim.step(delta)
	if active_job != null and not _pending_finish:
		for i in active_job.pieces.size():
			var p: JobInstance.Piece = active_job.pieces[i]
			if p.location == JobInstance.LOC_FORGE or p.location == JobInstance.LOC_ANVIL:
				temp_changed.emit(i, p.temp)
	if _pending_finish:
		_pending_finish = false
		_complete_active_job()
	_step_journeyman(delta)


func default_settings() -> Dictionary:
	var lang := "de" if OS.get_locale_language() == "de" else "en"
	return {
		"sfx_volume": 0.8, "music_volume": 0.6, "language": lang,
		"show_celsius": false, "hold_to_hammer": false, "screen_shake": true,
		"flash_effects": true, "fullscreen": false, "tutorial": true,
	}


func apply_settings() -> void:
	TranslationServer.set_locale(str(settings.get("language", "de")))
	if not OS.has_feature("web") and not OS.has_feature("mobile"):
		var fs := bool(settings.get("fullscreen", false))
		var mode := DisplayServer.window_get_mode()
		var is_fs := mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		if fs != is_fs:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fs else DisplayServer.WINDOW_MODE_WINDOWED)
	settings_changed.emit()


func set_setting(key: String, value) -> void:
	settings[key] = value
	apply_settings()


# ================================================================== Neues Spiel / Sitzung

func new_game() -> void:
	created_at = int(Time.get_unix_time_from_system())
	playtime_seconds = 0.0
	total_pence = 0
	lifetime_pence = 0
	equipped_hammer_id = "hammer_hand"
	hammer_levels = {"hammer_hand": 0}
	owned_hammer_ids = ["hammer_hand"]
	equipped_forge_id = "forge_clay"
	owned_forge_ids = ["forge_clay"]
	active_machine_id = ""
	owned_machine_ids = []
	hired_ids = []
	apprentice_to_forge_below = cfg.apprentice_to_forge_below
	apprentice_to_anvil_at = cfg.apprentice_to_anvil_at
	current_epoch = 1
	furnished = []
	mastery = {}
	masterpiece_progress = {}
	masterpiece_fails = {}
	jobs_completed_in_epoch = 0
	completed_milestone_ids = []
	var r := RandomNumberGenerator.new()
	r.randomize()
	generator_seed = r.randi()
	generator.set_seed(generator_seed)
	generator.uid_counter = 0
	reroll_available_at = 0
	free_play = false
	job_offers = []
	active_job = null
	stats = {"jobs_completed": 0, "stars_total": 0, "pieces_ruined": 0, "hits": 0,
		"milestones": 0, "journeyman_pence": 0, "best_payout": 0, "three_star_jobs": 0}
	seen_hints = []
	cosmetics = []
	pending_offline = {}
	start_session()


## Nach Neues Spiel / Laden: Ausrüstung in die Simulation übernehmen.
func start_session() -> void:
	_apply_equipment()
	sim.load_job(active_job)
	_pending_finish = false
	refresh_offers()
	in_game = true
	sim_paused = false
	state_changed.emit()
	active_job_changed.emit()
	pence_changed.emit(total_pence, 0)


func end_session() -> void:
	in_game = false


func _apply_equipment() -> void:
	var f: ForgeData = forges.get(equipped_forge_id, forges["forge_clay"])
	sim.set_forge(f.k_heat * heat_factor(), f.t_max, f.slots)
	sim.hammer_power = current_hammer_power()
	sim.machine = machines.get(active_machine_id, null)
	sim.has_trough = has_trough()
	sim.has_apprentice = hired_ids.has("staff_apprentice")
	sim.striker = staff["staff_striker"] if hired_ids.has("staff_striker") else null
	sim.apprentice_to_forge_below = apprentice_to_forge_below
	sim.apprentice_to_anvil_at = apprentice_to_anvil_at
	sim.force_enabled = force_counts()
	var fx := furnish_effects()
	sim.window_bonus = fx["window_bonus"]
	sim.damage_factor = fx["damage_factor"]
	sim.ruin_cost_factor = fx["ruin_cost_factor"]
	sim.big_factor_mult = fx["big_factor_mult"]


## Der Heizer (Personal ab Epoche 7) und der Brennstoff-Platz der Einrichtung lassen die Esse schneller heizen.
func heat_factor() -> float:
	var f: float = cfg.stoker_heat_factor if hired_ids.has("staff_stoker") else 1.0
	return f * float(furnish_effects()["heat_factor"])


## Wirkungen der Werkstatt-Einrichtung der aktuellen Epoche.
func furnish_effects() -> Dictionary:
	return Furnishings.effects(furnished, current_epoch)


func current_setup() -> Dictionary:
	var f: ForgeData = forges.get(equipped_forge_id, forges["forge_clay"])
	return {
		"k_heat": f.k_heat * heat_factor(), "t_max": f.t_max, "slots": f.slots,
		"hammer_power": current_hammer_power(),
		"machine": machines.get(active_machine_id, null),
		"striker": staff["staff_striker"] if hired_ids.has("staff_striker") else null,
		"has_apprentice": hired_ids.has("staff_apprentice"),
		"has_trough": has_trough(),
		"apprentice_to_forge_below": apprentice_to_forge_below,
		"apprentice_to_anvil_at": apprentice_to_anvil_at,
		"window_bonus": furnish_effects()["window_bonus"],
		"damage_factor": furnish_effects()["damage_factor"],
		"ruin_cost_factor": furnish_effects()["ruin_cost_factor"],
		"big_factor_mult": furnish_effects()["big_factor_mult"],
	}


# ================================================================== Abfragen

func current_hammer() -> HammerData:
	return hammers.get(equipped_hammer_id, hammers["hammer_hand"])


func current_forge() -> ForgeData:
	return forges.get(equipped_forge_id, forges["forge_clay"])


func current_machine() -> MachineData:
	return machines.get(active_machine_id, null)


func hammer_level(id: String) -> int:
	return int(hammer_levels.get(id, 0))


func current_hammer_power() -> float:
	var h := current_hammer()
	return Economy.hammer_power(cfg, h.p_base, hammer_level(h.id)) * float(furnish_effects()["power_factor"])


func has_trough() -> bool:
	return current_epoch >= 4


func has_pyrometer() -> bool:
	return cosmetics.has("pyrometer")


func is_hired(id: String) -> bool:
	return hired_ids.has(id)


func format_money(pence: int) -> String:
	return Economy.format_lsd(pence)


func epoch_job_count(epoch: int = -1) -> int:
	if epoch < 0:
		epoch = current_epoch
	return cfg.epoch_job_counts[clampi(epoch, 1, EPOCH_COUNT) - 1]


func final_milestone(epoch: int) -> MilestoneData:
	var arr: Array = milestones_by_epoch.get(epoch, [])
	return arr[arr.size() - 1] if not arr.is_empty() else null


func epoch_finished() -> bool:
	var ms := final_milestone(current_epoch)
	return ms != null and completed_milestone_ids.has(ms.id)


func can_advance_epoch() -> bool:
	return current_epoch < EPOCH_COUNT and epoch_finished()


func next_epoch_fee() -> int:
	return Economy.epoch_fee(cfg, current_epoch)


func reputation_title_key() -> String:
	var s := int(stats.get("stars_total", 0))
	if s >= 600:
		return "REP_5"
	if s >= 300:
		return "REP_4"
	if s >= 120:
		return "REP_3"
	if s >= 40:
		return "REP_2"
	return "REP_1"


## Nächster offener, freigeschalteter Meilenstein der Epoche (oder null).
func open_milestone() -> MilestoneData:
	var arr: Array = milestones_by_epoch.get(current_epoch, [])
	for ms in arr:
		if completed_milestone_ids.has(ms.id):
			continue
		var unlock := JobGenerator.milestone_unlock_n(cfg, current_epoch, ms.index, arr.size())
		if jobs_completed_in_epoch >= unlock:
			return ms
		return null
	return null


## Prüft, ob die Ausrüstung für einen Auftrag reicht. Leerer String = ok, sonst Übersetzungsschlüssel.
func job_requirement_issue(job: JobInstance) -> String:
	if job.needs_weld() and current_forge().t_max < cfg.weld_forge_min_tmax:
		return "REQ_WELD_FORGE"
	if job.is_precision() and current_forge().t_max < cfg.precision_forge_min_tmax:
		return "REQ_PRECISION_FORGE"
	if job.needs_harden() and not has_trough():
		return "REQ_TROUGH"
	return ""


# ================================================================== Auftragsbuch (3.1)

func _gen_ctx() -> Dictionary:
	return {
		"can_weld": current_forge().t_max >= cfg.weld_forge_min_tmax,
		"can_harden": has_trough(),
		"can_big": not owned_machine_ids.is_empty(),
	}


func _finalize_offer(j: JobInstance) -> void:
	j.reset_pieces(cfg.room_temp)
	j.estimate_s = _estimate(j)
	if j.is_rush():
		j.time_limit_s = maxf(cfg.rush_min_time_s, cfg.rush_time_factor * maxf(j.estimate_s, 0.0))
	j.pieces.clear()


func _estimate(j: JobInstance) -> float:
	if job_requirement_issue(j) != "":
		return -1.0
	return ReferencePlayer.estimate_job(cfg, j, current_setup())


func _make_generated_offer() -> JobInstance:
	var j := generator.generate(current_epoch, jobs_completed_in_epoch, free_play, _gen_ctx())
	_finalize_offer(j)
	return j


func _make_milestone_offer(ms: MilestoneData) -> JobInstance:
	var j: JobInstance
	if Masterpieces.is_masterpiece(ms.id):
		var done := int(masterpiece_progress.get(ms.id, 0))
		var n_parts := Masterpieces.part_count(ms.id)
		var pt: Array = Masterpieces.part(ms.id, done)
		if not pt.is_empty() and items.has(str(pt[0])):
			j = generator.make_masterpiece_part(ms, items[str(pt[0])], int(pt[1]), bool(pt[2]), jobs_completed_in_epoch, done + 1, n_parts)
		else:
			j = generator.make_milestone(ms, items.get(ms.item_id, null), jobs_completed_in_epoch)
			j.part = n_parts
			j.parts = n_parts
	else:
		j = generator.make_milestone(ms, items.get(ms.item_id, null), jobs_completed_in_epoch)
	_finalize_offer(j)
	if j.is_masterpiece():
		request_hint("masterpiece")
	return j


## Stellt sicher, dass 3 Angebote vorliegen und ein offener Meilenstein darunter ist.
func refresh_offers() -> void:
	var ms: MilestoneData = null if free_play else open_milestone()
	# Veraltete Meilenstein-Angebote entfernen
	var keep: Array = []
	for o in job_offers:
		if o.is_milestone() and (ms == null or o.milestone_id != ms.id):
			continue
		# Ältere Spielstände: Meisterstück-Angebot ohne Teile neu erzeugen
		if o.is_milestone() and Masterpieces.is_masterpiece(o.milestone_id) and not o.is_masterpiece():
			continue
		if o.epoch != current_epoch:
			continue
		keep.append(o)
	job_offers = keep
	var has_ms := false
	for o in job_offers:
		if o.is_milestone():
			has_ms = true
	if ms != null and not has_ms and (active_job == null or active_job.milestone_id != ms.id):
		if job_offers.size() >= offers_count():
			job_offers.pop_back()
		job_offers.push_front(_make_milestone_offer(ms))
	while job_offers.size() < offers_count():
		job_offers.append(_make_generated_offer())
	offers_changed.emit()


## Anzahl der Angebote im Auftragsbuch (Kundschafts-Platz der Einrichtung: eines mehr).
## In der Lehrzeit: beim allerersten Auftrag genau eines, danach zwei.
func offers_count() -> int:
	if in_tutorial():
		return 1 if jobs_completed_in_epoch == 0 else 2
	var n: int = furnish_effects()["offers_count"]
	return n if n > 0 else cfg.offers_count


## Zählt die Schlagstärke? Nicht in den Lehrzeit-Aufträgen (Epoche 1, erste Aufträge) – auch nicht,
## wenn die Lehrzeit-Hilfe übersprungen wurde (dann wäre die Voreinstellung sonst oft falsch).
func force_counts() -> bool:
	return not (current_epoch == 1 and not free_play and jobs_completed_in_epoch < cfg.tutorial_standard_only_jobs)


## Lehrzeit aktiv? (Epoche 1, erste Aufträge, Tutorial eingeschaltet und nicht übersprungen)
func in_tutorial() -> bool:
	return current_epoch == 1 and not free_play and jobs_completed_in_epoch < cfg.tutorial_standard_only_jobs \
		and bool(settings.get("tutorial", true)) and not seen_hints.has("tutorial_done")


func reroll_cooldown_s() -> int:
	var n: int = furnish_effects()["reroll_cooldown_s"]
	return n if n > 0 else cfg.reroll_cooldown_s


func reroll_seconds_left() -> int:
	return maxi(0, reroll_available_at - int(Time.get_unix_time_from_system()))


func reroll_offers() -> bool:
	if reroll_seconds_left() > 0:
		return false
	var keep: Array = []
	for o in job_offers:
		if o.is_milestone():
			keep.append(o)
	job_offers = keep
	reroll_available_at = int(Time.get_unix_time_from_system()) + reroll_cooldown_s()
	refresh_offers()
	sim_event.emit("page", {})
	return true


## Schätzungen nach Ausrüstungswechsel aktualisieren (Zeitlimits bleiben fest).
func update_estimates() -> void:
	for o in job_offers:
		o.reset_pieces(cfg.room_temp)
		o.estimate_s = _estimate(o)
		o.pieces.clear()
	offers_changed.emit()


func accept_offer(index: int) -> String:
	if active_job != null:
		return "ERR_JOB_ACTIVE"
	if index < 0 or index >= job_offers.size():
		return "ERR_INVALID"
	var j: JobInstance = job_offers[index]
	var issue := job_requirement_issue(j)
	if issue != "":
		return issue
	job_offers.remove_at(index)
	j.reset_pieces(cfg.room_temp)
	j.elapsed_s = 0.0
	j.costs_pence = 0
	active_job = j
	sim.load_job(active_job)
	refresh_offers()
	_request_job_hints(j)
	active_job_changed.emit()
	state_changed.emit()
	sim_event.emit("page", {})
	return ""


## Kann ein abgeschlossener Auftrag noch einmal angenommen werden? (nicht bei Meilensteinen)
func can_repeat_job(j: JobInstance) -> bool:
	return j != null and active_job == null and not j.is_milestone() and j.epoch == current_epoch \
		and job_requirement_issue(j) == ""


## Denselben Auftrag (Werkstück, Menge, Qualität, Kunde, Lohn) noch einmal annehmen.
func repeat_job(j: JobInstance) -> String:
	if not can_repeat_job(j):
		return "ERR_INVALID"
	var nj := j.duplicate_offer()
	generator.uid_counter += 1
	nj.uid = "gen_e%d_%04d" % [current_epoch, generator.uid_counter]
	nj.elapsed_s = 0.0
	nj.costs_pence = 0
	_finalize_offer(nj)
	job_offers.push_front(nj)
	return accept_offer(0)


func abort_job() -> void:
	if active_job == null:
		return
	var j := active_job
	active_job = null
	sim.clear_job()
	if j.is_milestone():
		refresh_offers()
	active_job_changed.emit()
	state_changed.emit()


func _request_job_hints(j: JobInstance) -> void:
	if j.steps.size() > 1:
		request_hint("steps")
	if j.is_steel():
		request_hint("steel")
	if j.quantity > 1:
		request_hint("quantity")
	if j.is_rush():
		request_hint("rush")
	if j.is_precision():
		request_hint("precision")
	if j.needs_weld():
		request_hint("weld")
	if j.needs_harden():
		request_hint("harden")
	if j.is_big():
		request_hint("big")


func request_hint(id: String) -> void:
	if seen_hints.has(id) or not bool(settings.get("tutorial", true)):
		return
	hint_requested.emit(id)


func mark_hint_seen(id: String) -> void:
	if not seen_hints.has(id):
		seen_hints.append(id)


# ================================================================== Auftragsabschluss

func _complete_active_job() -> void:
	if active_job == null:
		return
	var j := active_job
	var ev := sim.evaluate()
	var stars: int = ev["stars"]
	var late := j.is_late()
	var lv_before := mastery_level(j.template_id)
	var pf: float = furnish_effects()["payout_factor"] * Mastery.payout_factor(cfg, lv_before)
	var gross := Economy.round_half_up(float(Economy.job_payout(cfg, j.reward_base_pence, j.is_precision(), stars, late)) * pf)
	var base2 := Economy.round_half_up(float(Economy.job_payout(cfg, j.reward_base_pence, j.is_precision(), 2, late)) * pf)
	var wages := {}
	var wage_total := 0
	for sid in ["staff_apprentice", "staff_striker"]:
		if hired_ids.has(sid):
			var w := Economy.round_half_up(float(gross) * staff[sid].wage_share)
			wages[sid] = w
			wage_total += w
	var net := gross - wage_total
	_add_pence(net, true)
	stats["jobs_completed"] = int(stats.get("jobs_completed", 0)) + 1
	stats["stars_total"] = int(stats.get("stars_total", 0)) + stars
	if stars == 3:
		stats["three_star_jobs"] = int(stats.get("three_star_jobs", 0)) + 1
	stats["best_payout"] = maxi(int(stats.get("best_payout", 0)), net)
	stats["best_streak"] = maxi(int(stats.get("best_streak", 0)), int(ev.get("best_streak", 0)))
	var m_entry: Dictionary = mastery.get(j.template_id, {})
	Mastery.record(m_entry, stars)
	mastery[j.template_id] = m_entry
	var lv_after := mastery_level(j.template_id)
	if lv_after > lv_before:
		request_hint("mastery")
	jobs_completed_in_epoch += 1
	sim.force_enabled = force_counts()
	# Lehrzeit-Drehbuch: Folgeangebote neu erzeugen, damit sie zum nächsten Auftrag passen
	# (beim Annehmen wurden sie noch mit dem alten Stand erzeugt)
	if current_epoch == 1 and not free_play and jobs_completed_in_epoch <= cfg.tutorial_standard_only_jobs:
		var keep: Array = []
		for o in job_offers:
			if o.is_milestone():
				keep.append(o)
		job_offers = keep
	# Ende der Lehrzeit: auf die Einrichtung der Werkstatt hinweisen
	if current_epoch == 1 and jobs_completed_in_epoch == cfg.tutorial_standard_only_jobs:
		request_hint("furnish_intro")
	var epoch_done := false
	var game_done := false
	# Meisterstück: Die Zunft prüft jeden Teil; bestandene Vorarbeiten zählen, erst das Hauptstück schließt ab
	var mp_passed := true
	var milestone_done := j.is_milestone()
	if j.is_masterpiece():
		mp_passed = stars >= masterpiece_required_stars(j.milestone_id)
		if mp_passed:
			masterpiece_progress[j.milestone_id] = j.part
			masterpiece_fails.erase(j.milestone_id)
		else:
			masterpiece_fails[j.milestone_id] = int(masterpiece_fails.get(j.milestone_id, 0)) + 1
		milestone_done = mp_passed and j.part >= j.parts
		if milestone_done:
			stats["masterpieces"] = int(stats.get("masterpieces", 0)) + 1
	if milestone_done:
		completed_milestone_ids.append(j.milestone_id)
		stats["milestones"] = int(stats.get("milestones", 0)) + 1
		if j.milestone_id == "ms_e5_09_wedgwood" and not cosmetics.has("pyrometer"):
			cosmetics.append("pyrometer")
		var fm := final_milestone(current_epoch)
		if fm != null and fm.id == j.milestone_id:
			if current_epoch < EPOCH_COUNT:
				epoch_done = true
			else:
				game_done = true
				free_play = true
	var report := {
		"job": j, "stars": stars, "hit_quote": ev["hit_quote"], "damage": ev["damage"],
		"quench_penalty": ev["quench_penalty"], "q": ev["q"], "best_streak": int(ev.get("best_streak", 0)),
		"gross": gross, "tip": maxi(0, gross - base2), "late": late,
		"wages": wages, "costs": j.costs_pence, "net": net,
		"epoch_done": epoch_done, "game_done": game_done,
		"mastery_before": lv_before, "mastery_after": lv_after, "mastery_jobs": int(m_entry.get("jobs", 0)),
		"mastery_bonus": Mastery.payout_factor(cfg, lv_before) - 1.0,
		"masterpiece_part": j.part, "masterpiece_parts": j.parts, "masterpiece_passed": mp_passed,
		"masterpiece_next_required": masterpiece_required_stars(j.milestone_id) if j.is_masterpiece() else 0,
	}
	active_job = null
	sim.clear_job()
	refresh_offers()
	job_completed.emit(j, stars, gross)
	settlement_ready.emit(report)
	active_job_changed.emit()
	state_changed.emit()
	sim_event.emit("coins", {})
	SaveManager.request_save()


func _on_piece_ruined(i: int, reason: String) -> void:
	stats["pieces_ruined"] = int(stats.get("pieces_ruined", 0)) + 1
	piece_ruined.emit(i, reason)
	sim_event.emit("ruin_" + reason, {"piece": i})


func _on_cost(pence: int, reason: String) -> void:
	if active_job != null:
		active_job.costs_pence += pence
	_add_pence(-pence, false)
	if reason == "ruin":
		message.emit("MSG_RUIN_COST", {"cost": Economy.format_lsd(pence)})


func _add_pence(delta: int, earned: bool) -> void:
	if delta == 0:
		return
	var before := total_pence
	total_pence = maxi(0, total_pence + delta)
	if earned and delta > 0:
		lifetime_pence += delta
	pence_changed.emit(total_pence, total_pence - before)


# ================================================================== Laden (5.1–5.5)

func can_afford(price: int) -> bool:
	return total_pence >= price


func _pay(price: int, item_id: String) -> void:
	_add_pence(-price, false)
	purchase_made.emit(item_id, price)
	sim_event.emit("coins", {})


func buy_hammer(id: String) -> bool:
	var h: HammerData = hammers.get(id, null)
	if h == null or owned_hammer_ids.has(id) or h.min_epoch > current_epoch or not can_afford(h.price):
		return false
	_pay(h.price, id)
	owned_hammer_ids.append(id)
	hammer_levels[id] = 0
	equipped_hammer_id = id
	_after_purchase()
	return true


func equip_hammer(id: String) -> void:
	if owned_hammer_ids.has(id):
		equipped_hammer_id = id
		_after_purchase(false)


func next_upgrade_cost(id: String) -> int:
	var lvl := hammer_level(id)
	if lvl >= cfg.upgrade_max_level:
		return -1
	return Economy.upgrade_cost(cfg, current_epoch, lvl)


func upgrade_hammer(id: String) -> bool:
	if not owned_hammer_ids.has(id):
		return false
	var cost := next_upgrade_cost(id)
	if cost < 0 or not can_afford(cost):
		return false
	_pay(cost, id + "_upgrade")
	hammer_levels[id] = hammer_level(id) + 1
	_after_purchase()
	return true


func buy_forge(id: String) -> bool:
	var f: ForgeData = forges.get(id, null)
	if f == null or owned_forge_ids.has(id) or f.min_epoch > current_epoch or not can_afford(f.price):
		return false
	_pay(f.price, id)
	owned_forge_ids.append(id)
	equipped_forge_id = id
	_after_purchase()
	return true


func equip_forge(id: String) -> void:
	if owned_forge_ids.has(id):
		equipped_forge_id = id
		_after_purchase(false)


func buy_machine(id: String) -> bool:
	var m: MachineData = machines.get(id, null)
	if m == null or owned_machine_ids.has(id) or m.min_epoch > current_epoch or not can_afford(m.price):
		return false
	_pay(m.price, id)
	owned_machine_ids.append(id)
	active_machine_id = id
	request_hint("steam_hammer" if m.force_mode == "adjustable" else "machine")
	_after_purchase()
	return true


func activate_machine(id: String) -> void:
	if owned_machine_ids.has(id):
		active_machine_id = id
		if machines[id].force_mode == "adjustable":
			request_hint("steam_hammer")
		_after_purchase(false)


func hire(id: String) -> bool:
	var s: StaffData = staff.get(id, null)
	if s == null or hired_ids.has(id) or s.min_epoch > current_epoch or not can_afford(s.price):
		return false
	_pay(s.price, id)
	hired_ids.append(id)
	if id == "staff_journeyman":
		request_hint("journeyman")
	_after_purchase()
	return true


# ------------------------------------------------------------------ Werkstatt-Einrichtung

func furnish_price(slot: String) -> int:
	return Furnishings.price(cfg, current_epoch, slot)


func is_furnished(slot: String) -> bool:
	return furnished.has(slot)


func fully_furnished() -> bool:
	for sl in Furnishings.SLOTS:
		if not furnished.has(sl):
			return false
	return true


## Kauft das Einrichtungsstück eines Platzes der aktuellen Epoche. Sind danach alle fünf Plätze
## eingerichtet, zahlt die Zunft eine Prämie.
func buy_furnishing(slot: String) -> bool:
	if not Furnishings.SLOTS.has(slot) or furnished.has(slot):
		return false
	var price := furnish_price(slot)
	if not can_afford(price):
		return false
	_pay(price, Furnishings.item_id(current_epoch, slot))
	furnished.append(slot)
	request_hint("furnish")
	if fully_furnished():
		var bonus := Furnishings.complete_bonus(cfg, current_epoch)
		_add_pence(bonus, true)
		stats["workshops_furnished"] = int(stats.get("workshops_furnished", 0)) + 1
		message.emit("MSG_FURNISHED", {"bonus": Economy.format_lsd(bonus)})
		sim_event.emit("furnished", {})
	_after_purchase()
	refresh_offers()
	return true


func set_apprentice_thresholds(to_forge_below: float, to_anvil_at: float) -> void:
	apprentice_to_forge_below = clampf(to_forge_below, cfg.cold_limit, cfg.optimal_max)
	apprentice_to_anvil_at = clampf(to_anvil_at, apprentice_to_forge_below + 50.0, 1300.0)
	sim.apprentice_to_forge_below = apprentice_to_forge_below
	sim.apprentice_to_anvil_at = apprentice_to_anvil_at
	state_changed.emit()


func _after_purchase(save: bool = true) -> void:
	_apply_equipment()
	update_estimates()
	state_changed.emit()
	if save:
		SaveManager.request_save()


# ================================================================== Epochenwechsel (4.3)

func advance_epoch() -> bool:
	if not can_advance_epoch():
		return false
	var fee := next_epoch_fee()
	if not can_afford(fee):
		return false
	_pay(fee, "epoch_fee_%d" % (current_epoch + 1))
	if active_job != null:
		active_job = null
		sim.clear_job()
	current_epoch += 1
	furnished = []
	jobs_completed_in_epoch = 0
	job_offers.clear()
	_apply_equipment()
	refresh_offers()
	epoch_unlocked.emit(current_epoch)
	active_job_changed.emit()
	state_changed.emit()
	SaveManager.request_save()
	return true


# ================================================================== Geselle & Offline (5.7)

## Netto-Einnahmen des Gesellen in Pence je Sekunde (nach seinem Lohnanteil).
func journeyman_rate() -> float:
	if not hired_ids.has("staff_journeyman"):
		return 0.0
	var s: StaffData = staff["staff_journeyman"]
	var power := ReferencePlayer.reference_power(cfg, current_setup()) * s.performance_share
	var gross := power * cfg.rate_per_fp[clampi(current_epoch, 1, EPOCH_COUNT) - 1]
	return gross * (1.0 - s.wage_share)


func _step_journeyman(delta: float) -> void:
	var rate := journeyman_rate()
	if rate <= 0.0:
		return
	_journeyman_accum += rate * delta
	_journeyman_timer += delta
	if _journeyman_timer >= cfg.journeyman_payout_interval_s and _journeyman_accum >= 1.0:
		_journeyman_timer = 0.0
		var whole := int(floor(_journeyman_accum))
		_journeyman_accum -= whole
		stats["journeyman_pence"] = int(stats.get("journeyman_pence", 0)) + whole
		_add_pence(whole, true)


## Berechnet Offline-Einnahmen seit `last_saved_at` (nur mit Gesellen; max. 8 h; Uhr-Schutz).
func compute_offline(last_saved_at: int) -> void:
	pending_offline = {}
	var now := int(Time.get_unix_time_from_system())
	var dt := float(now - last_saved_at)
	if dt <= 0.0 or last_saved_at <= 0:
		return
	var rate := journeyman_rate()
	if rate <= 0.0:
		return
	var secs := minf(dt, cfg.offline_max_s)
	var pence := int(floor(rate * secs))
	if pence <= 0:
		return
	stats["journeyman_pence"] = int(stats.get("journeyman_pence", 0)) + pence
	_add_pence(pence, true)
	pending_offline = {"pence": pence, "seconds": secs}


func take_pending_offline() -> void:
	if not pending_offline.is_empty():
		offline_earnings_ready.emit(int(pending_offline["pence"]), float(pending_offline["seconds"]))
		pending_offline = {}


# ================================================================== Spielstand (7.5)

func to_save_dict() -> Dictionary:
	var offers: Array = []
	for o in job_offers:
		offers.append(o.to_dict(false))
	return {
		"meta": {
			"save_version": 2, "game_version": GAME_VERSION,
			"created_at": created_at, "last_saved_at": int(Time.get_unix_time_from_system()),
			"playtime_seconds": int(playtime_seconds),
		},
		"economy": {"total_pence": total_pence, "lifetime_pence": lifetime_pence},
		"equipment": {
			"equipped_hammer_id": equipped_hammer_id, "hammer_levels": hammer_levels.duplicate(),
			"owned_hammer_ids": owned_hammer_ids.duplicate(),
			"equipped_forge_id": equipped_forge_id, "owned_forge_ids": owned_forge_ids.duplicate(),
			"active_machine_id": (active_machine_id if active_machine_id != "" else null),
			"owned_machine_ids": owned_machine_ids.duplicate(),
		},
		"staff": {
			"hired_ids": hired_ids.duplicate(),
			"apprentice_thresholds": {"to_forge_below": apprentice_to_forge_below, "to_anvil_at": apprentice_to_anvil_at},
		},
		"progress": {
			"current_epoch": current_epoch, "jobs_completed_in_epoch": jobs_completed_in_epoch,
			"furnished": furnished.duplicate(),
			"mastery": mastery.duplicate(true),
			"masterpiece_progress": masterpiece_progress.duplicate(),
			"masterpiece_fails": masterpiece_fails.duplicate(),
			"completed_milestone_ids": completed_milestone_ids.duplicate(),
			"generator_seed": generator_seed, "generator_state": str(generator.get_state()),
			"generator_uid": generator.uid_counter,
			"reroll_available_at": reroll_available_at, "free_play": free_play,
			"seen_hints": seen_hints.duplicate(), "cosmetics": cosmetics.duplicate(),
		},
		"job_offers": offers,
		"active_job": (active_job.to_dict(true) if active_job != null else null),
		"stats": stats.duplicate(),
		"settings": settings.duplicate(),
	}


## Übernimmt einen (bereits migrierten) Spielstand. Unbekannte IDs werden ignoriert und protokolliert.
func load_from_dict(d: Dictionary) -> void:
	var meta: Dictionary = d.get("meta", {})
	created_at = int(meta.get("created_at", Time.get_unix_time_from_system()))
	playtime_seconds = float(meta.get("playtime_seconds", 0))
	var eco: Dictionary = d.get("economy", {})
	total_pence = maxi(0, int(eco.get("total_pence", 0)))
	lifetime_pence = maxi(0, int(eco.get("lifetime_pence", 0)))

	var eq: Dictionary = d.get("equipment", {})
	owned_hammer_ids = _known_ids(eq.get("owned_hammer_ids", []), hammers, "hammer")
	if not owned_hammer_ids.has("hammer_hand"):
		owned_hammer_ids.push_front("hammer_hand")
	hammer_levels = {}
	var hl = eq.get("hammer_levels", {})
	if hl is Dictionary:
		for k in hl:
			if hammers.has(k):
				hammer_levels[k] = clampi(int(hl[k]), 0, cfg.upgrade_max_level)
			else:
				_log_unknown("hammer", str(k))
	equipped_hammer_id = str(eq.get("equipped_hammer_id", "hammer_hand"))
	if not owned_hammer_ids.has(equipped_hammer_id):
		equipped_hammer_id = owned_hammer_ids[owned_hammer_ids.size() - 1]
	owned_forge_ids = _known_ids(eq.get("owned_forge_ids", []), forges, "forge")
	if not owned_forge_ids.has("forge_clay"):
		owned_forge_ids.push_front("forge_clay")
	equipped_forge_id = str(eq.get("equipped_forge_id", "forge_clay"))
	if not owned_forge_ids.has(equipped_forge_id):
		equipped_forge_id = owned_forge_ids[owned_forge_ids.size() - 1]
	owned_machine_ids = _known_ids(eq.get("owned_machine_ids", []), machines, "machine")
	var am = eq.get("active_machine_id", null)
	active_machine_id = str(am) if am != null and owned_machine_ids.has(str(am)) else ""

	var st: Dictionary = d.get("staff", {})
	hired_ids = _known_ids(st.get("hired_ids", []), staff, "staff")
	var th: Dictionary = st.get("apprentice_thresholds", {})
	apprentice_to_forge_below = float(th.get("to_forge_below", cfg.apprentice_to_forge_below))
	apprentice_to_anvil_at = float(th.get("to_anvil_at", cfg.apprentice_to_anvil_at))

	var pr: Dictionary = d.get("progress", {})
	current_epoch = clampi(int(pr.get("current_epoch", 1)), 1, EPOCH_COUNT)
	jobs_completed_in_epoch = maxi(0, int(pr.get("jobs_completed_in_epoch", 0)))
	furnished = []
	var fu = pr.get("furnished", [])
	if fu is Array:
		for v in fu:
			if Furnishings.SLOTS.has(str(v)) and not furnished.has(str(v)):
				furnished.append(str(v))
	mastery = {}
	var ma = pr.get("mastery", {})
	if ma is Dictionary:
		for k in ma:
			if items.has(str(k)) and ma[k] is Dictionary:
				mastery[str(k)] = {"jobs": maxi(0, int(ma[k].get("jobs", 0))), "best": clampi(int(ma[k].get("best", 0)), 0, 3)}
			else:
				_log_unknown("item", str(k))
	masterpiece_progress = {}
	var mpp = pr.get("masterpiece_progress", {})
	if mpp is Dictionary:
		for k in mpp:
			if milestones.has(str(k)) and Masterpieces.is_masterpiece(str(k)):
				masterpiece_progress[str(k)] = clampi(int(mpp[k]), 0, Masterpieces.part_count(str(k)))
	masterpiece_fails = {}
	var mpf = pr.get("masterpiece_fails", {})
	if mpf is Dictionary:
		for k in mpf:
			if Masterpieces.is_masterpiece(str(k)):
				masterpiece_fails[str(k)] = maxi(0, int(mpf[k]))
	completed_milestone_ids = _known_ids(pr.get("completed_milestone_ids", []), milestones, "milestone")
	generator_seed = int(pr.get("generator_seed", 1))
	var gs := str(pr.get("generator_state", ""))
	generator.set_seed(generator_seed, int(gs) if gs.is_valid_int() else null)
	generator.uid_counter = int(pr.get("generator_uid", 0))
	reroll_available_at = int(pr.get("reroll_available_at", 0))
	free_play = bool(pr.get("free_play", false))
	seen_hints = Array(pr.get("seen_hints", []))
	cosmetics = Array(pr.get("cosmetics", []))

	job_offers = []
	var offs = d.get("job_offers", [])
	if offs is Array:
		for od in offs:
			if od is Dictionary:
				var j := JobInstance.from_dict(od)
				if _job_valid(j):
					job_offers.append(j)
	active_job = null
	var aj = d.get("active_job", null)
	if aj is Dictionary:
		var j2 := JobInstance.from_dict(aj)
		if _job_valid(j2):
			if j2.pieces.size() != j2.quantity:
				j2.reset_pieces(cfg.room_temp)
			active_job = j2

	stats = d.get("stats", {}) if d.get("stats", {}) is Dictionary else {}
	var defaults := default_settings()
	var s = d.get("settings", {})
	settings = defaults
	if s is Dictionary:
		for k in s:
			settings[k] = s[k]
	apply_settings()
	start_session()
	compute_offline(int(meta.get("last_saved_at", 0)))


func _known_ids(arr, catalog: Dictionary, kind: String) -> Array:
	var out: Array = []
	if arr is Array:
		for v in arr:
			var id := str(v)
			if catalog.has(id):
				if not out.has(id):
					out.append(id)
			else:
				_log_unknown(kind, id)
	return out


func _job_valid(j: JobInstance) -> bool:
	if not items.has(j.template_id):
		_log_unknown("item", j.template_id)
		return false
	# Spielstände vor Einführung der Arbeitsgänge: aus dem Gegenstand ergänzen
	if j.steps.is_empty():
		j.steps = items[j.template_id].steps.duplicate(true)
		j.material = items[j.template_id].material
	if j.is_milestone() and not milestones.has(j.milestone_id):
		_log_unknown("milestone", j.milestone_id)
		return false
	if not customers.has(j.customer_id):
		_log_unknown("customer", j.customer_id)
		j.customer_id = Catalog.CUSTOMERS[0].id
	return j.form_points > 0


func _log_unknown(kind: String, id: String) -> void:
	push_warning("Spielstand: unbekannte %s-ID '%s' wird ignoriert." % [kind, id])


# ================================================================== Texte

func item_name(item_id: String, plural: bool = false) -> String:
	var key := "ITEM_" + item_id.to_upper() + ("_PL" if plural else "")
	return tr(key)


## Sterne, die die Zunft für den aktuellen Teil eines Meisterstücks verlangt.
func masterpiece_required_stars(ms_id: String) -> int:
	return Masterpieces.required_stars(int(masterpiece_fails.get(ms_id, 0)))


## Meisterschaft eines Werkstücks (0 = keine, 1 Bronze, 2 Silber, 3 Gold).
func mastery_level(item_id: String) -> int:
	return Mastery.level(cfg, int(mastery.get(item_id, {}).get("jobs", 0)))


func mastery_jobs(item_id: String) -> int:
	return int(mastery.get(item_id, {}).get("jobs", 0))


func job_title(j: JobInstance) -> String:
	if j.is_masterpiece():
		return Localization.trf("MP_TITLE", {"title": tr("MS_" + j.milestone_id.to_upper() + "_TITLE"),
			"k": j.part, "n": j.parts, "item": item_name(j.template_id, j.quantity > 1), "qty": j.quantity})
	if j.is_milestone():
		return tr("MS_" + j.milestone_id.to_upper() + "_TITLE")
	var plural := j.quantity > 1
	var gender := tr("ITEM_" + j.template_id.to_upper() + "_G")
	var qkey := "QUALITY_" + j.quality.to_upper() + "_" + ("PL" if plural else gender.to_upper())
	var fmt_key := "JOB_TITLE_QTY" if plural else "JOB_TITLE"
	return Localization.trf(fmt_key, {
		"quality": tr(qkey), "item": item_name(j.template_id, plural),
		"qty": j.quantity, "customer": tr("CUST_" + j.customer_id.to_upper()),
	})


func epoch_name(epoch: int = -1) -> String:
	if epoch < 0:
		epoch = current_epoch
	return tr("EPOCH_%d_NAME" % epoch)


# ================================================================== Testmenü (nur Testversionen)

## Das Testmenü steht nur in Debug-Builds zur Verfügung (Start aus dem Editor, Debug-Export).
func test_tools_enabled() -> bool:
	return OS.is_debug_build()


## Komplexitätsgrad des nächsten Auftrags (0 = Epochenanfang, 1 = Epochenende).
func current_complexity() -> float:
	return JobGenerator.complexity_grade(cfg, current_epoch, jobs_completed_in_epoch, free_play)


## Springt in eine Epoche. progress: 0 = Anfang, 0.5 = Mitte, 1 = Ende (letzter Auftrag).
## Mit equip = true gibt es die typische Ausrüstung und das Personal der Epoche.
func debug_set_epoch(epoch: int, progress: float, equip: bool = true) -> void:
	epoch = clampi(epoch, 1, EPOCH_COUNT)
	if active_job != null:
		active_job = null
		sim.clear_job()
	current_epoch = epoch
	furnished = []
	free_play = false
	var ne := epoch_job_count(epoch)
	jobs_completed_in_epoch = clampi(int(round(clampf(progress, 0.0, 1.0) * float(ne - 1))), 0, ne - 1)
	# Meilensteine: alle früheren Epochen erledigt, in dieser Epoche alle bereits überholten
	completed_milestone_ids = []
	for e in milestones_by_epoch.keys():
		var arr: Array = milestones_by_epoch[e]
		for ms in arr:
			var unlock := JobGenerator.milestone_unlock_n(cfg, e, ms.index, arr.size())
			if e < epoch or (e == epoch and unlock < jobs_completed_in_epoch):
				completed_milestone_ids.append(ms.id)
	if equip:
		_debug_equip(epoch)
	job_offers.clear()
	reroll_available_at = 0
	_apply_equipment()
	refresh_offers()
	epoch_unlocked.emit(current_epoch)
	active_job_changed.emit()
	state_changed.emit()
	pence_changed.emit(total_pence, 0)


func _debug_equip(epoch: int) -> void:
	var best_h: HammerData = null
	for h in Catalog.HAMMERS:
		if h.min_epoch <= epoch:
			if not owned_hammer_ids.has(h.id):
				owned_hammer_ids.append(h.id)
			if best_h == null or h.tier > best_h.tier:
				best_h = h
	equipped_hammer_id = best_h.id
	hammer_levels[best_h.id] = maxi(hammer_level(best_h.id), mini(2 + epoch, cfg.upgrade_max_level))
	var best_f: ForgeData = null
	for f in Catalog.FORGES:
		if f.min_epoch <= epoch:
			if not owned_forge_ids.has(f.id):
				owned_forge_ids.append(f.id)
			if best_f == null or f.tier > best_f.tier:
				best_f = f
	equipped_forge_id = best_f.id
	for s in Catalog.STAFF:
		if s.min_epoch <= epoch and not hired_ids.has(s.id):
			hired_ids.append(s.id)
	for m in Catalog.MACHINES:
		if m.min_epoch <= epoch and not owned_machine_ids.has(m.id):
			owned_machine_ids.append(m.id)
			active_machine_id = m.id
	furnished = Furnishings.SLOTS.duplicate()


func debug_add_money(pence: int) -> void:
	_add_pence(pence, false)


## Schließt den aktiven Auftrag sofort mit drei Sternen ab (Abrechnung wie üblich).
func debug_finish_job() -> void:
	if active_job == null:
		return
	var fp := active_job.piece_fp()
	for p in active_job.pieces:
		p.progress = fp
		p.points_in_window = fp
		p.damage = 0.0
		p.weld_hits = cfg.weld_hits_required
		p.quenched = true
		p.quench_penalty = 0.0
		p.location = JobInstance.LOC_DONE
		p.slot = -1
	sim.load_job(active_job)
	_complete_active_job()


func debug_reroll_now() -> void:
	reroll_available_at = 0
	reroll_offers()


func debug_set_time_scale(scale: float) -> void:
	Engine.time_scale = scale
