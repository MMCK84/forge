extends SceneTree
## Balancing-Simulation (Lastenheft 5.8 / 9.4): spielt das gesamte Spiel mit dem
## Referenzspieler durch und vergleicht Spielzeit und Einnahmen je Epoche mit den Zielwerten.
##
## Aufruf (nach einmaligem Öffnen des Projekts im Editor):
##   godot --headless --path . -s res://tools/balance_sim.gd
##   godot --headless --path . -s res://tools/balance_sim.gd -- --mixed   (echter Auftragsmix)

const Catalog = preload("res://scripts/catalog.gd")
const Economy = preload("res://scripts/economy.gd")
const ReferencePlayer = preload("res://scripts/reference_player.gd")
const JobGenerator = preload("res://scripts/job_generator.gd")

## Zielwerte aus 5.8: [Minuten, Einnahmen in Pence]
const TARGETS := [[12, 900], [23, 7200], [56, 26160], [83, 67440], [131, 186960], [157, 453600]]

var cfg: BalanceConfig = Catalog.BALANCE
var money: int = 0
var hammer: HammerData
var levels: Dictionary = {}
var forge: ForgeData
var machine: MachineData = null
var staff: Array = []


func _init() -> void:
	var mixed := OS.get_cmdline_user_args().has("--mixed")
	hammer = Catalog.HAMMERS[0]
	forge = Catalog.FORGES[0]
	levels[hammer.id] = 0
	var gen := JobGenerator.new(cfg, Catalog.ITEMS, Catalog.CUSTOMERS)
	# Referenzauftrag: Hufeisen (Strecken, Biegen, Lochen), Schmiedeeisen
	var ref_item: ItemData = null
	for it in Catalog.ITEMS:
		if it.id == "horseshoe":
			ref_item = it
	var seed_value := 12345
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--seed="):
			seed_value = int(a.substr(7))
	gen.set_seed(seed_value)
	var total_s := 0.0
	print("Epoche | Spielzeit (Ziel)      | Einnahmen (Ziel)              | erster → letzter Auftrag | Ausrüstung")
	for e in range(1, 7):
		var ep_time := 0.0
		var ep_income := 0
		var first := 0.0
		var last := 0.0
		var n := 0
		var ne: int = cfg.epoch_job_counts[e - 1]
		var fee := Economy.epoch_fee(cfg, e) if e < 6 else 0
		while true:
			_shop(e, fee)
			if n >= ne and (e == 6 or money >= fee):
				break
			var job: JobInstance
			if mixed:
				job = gen.generate(e, mini(n, ne - 1), false, {"can_weld": forge.t_max >= cfg.weld_forge_min_tmax, "can_harden": e >= 4, "can_big": machine != null})
			else:
				job = JobInstance.new()
				job.template_id = "horseshoe"
				job.steps = ref_item.steps.duplicate(true)
				job.material = ref_item.material
				job.form_points = Economy.job_form_points(cfg, e, mini(n, ne - 1), 1.0, 1.0, false)
				job.reward_base_pence = Economy.reward_base(cfg, e, job.form_points, 1.0, "standard")
			var d := ReferencePlayer.estimate_job(cfg, job, _setup(e), 0.05)
			if d > 1500.0:
				_dump_stuck(job, _setup(e))
				print("WARNUNG: Auftrag hängt (%.0f s): Epoche %d, %s, Kategorie %s, Menge %d, %s, Präzision %s, Esse %s" % [d, e, job.template_id, job.category, job.quantity, job.material, job.is_precision(), forge.id])
			var gross := Economy.job_payout(cfg, job.reward_base_pence, job.is_precision(), 2, false)
			var wages := 0
			for s in staff:
				if s.id != "staff_journeyman":
					wages += Economy.round_half_up(float(gross) * s.wage_share)
			var net := gross - wages
			if machine != null and machine.cost_per_minute > 0:
				net -= int(d / 60.0 * machine.cost_per_minute * 0.8)
			money += net
			ep_income += net
			ep_time += d
			if n == 0:
				first = d
			if n == ne - 1:
				last = d
			n += 1
		if e < 6:
			money -= fee
		total_s += ep_time
		var tgt: Array = TARGETS[e - 1]
		print("  %d    | %6.1f min (%3d, %+4d %%) | %-14s (%-8s, %+4d %%) | %4.0f s → %4.0f s          | %s +%d, %s%s" % [
			e, ep_time / 60.0, tgt[0], int(round((ep_time / 60.0 / float(tgt[0]) - 1.0) * 100.0)),
			Economy.format_lsd(ep_income, "de"), Economy.format_lsd(int(tgt[1]), "de"), int(round((float(ep_income) / float(tgt[1]) - 1.0) * 100.0)),
			first, last, hammer.id, int(levels[hammer.id]), forge.id, (", " + machine.id) if machine != null else ""])
	print("Gesamt: %.2f h (Ziel ca. 7,7 h)" % (total_s / 3600.0))
	quit()


func _setup(e: int) -> Dictionary:
	var striker: StaffData = null
	var apprentice := false
	for s in staff:
		if s.id == "staff_striker":
			striker = s
		if s.id == "staff_apprentice":
			apprentice = true
	return {
		"k_heat": forge.k_heat, "t_max": forge.t_max, "slots": forge.slots,
		"hammer_power": Economy.hammer_power(cfg, hammer.p_base, int(levels[hammer.id])),
		"machine": machine, "striker": striker, "has_apprentice": apprentice, "has_trough": e >= 4,
	}


## Kauft Ausrüstung, sobald sie bezahlbar ist; Verbesserungen nur ohne die Meistergebühr anzutasten.
func _shop(e: int, fee: int) -> void:
	var changed := true
	while changed:
		changed = false
		for h in Catalog.HAMMERS:
			if h.tier > hammer.tier and h.min_epoch <= e and money >= h.price:
				money -= h.price
				hammer = h
				levels[h.id] = 0
				changed = true
		for f in Catalog.FORGES:
			if f.tier > forge.tier and f.min_epoch <= e and money >= f.price:
				money -= f.price
				forge = f
				changed = true
		for s in Catalog.STAFF:
			if s.id != "staff_journeyman" and not staff.has(s) and s.min_epoch <= e and money >= s.price:
				money -= s.price
				staff.append(s)
				changed = true
		for m in Catalog.MACHINES:
			if (machine == null or m.tier > machine.tier) and m.min_epoch <= e and money >= m.price:
				money -= m.price
				machine = m
				changed = true
		var lvl: int = levels[hammer.id]
		if lvl < cfg.upgrade_max_level:
			var c := Economy.upgrade_cost(cfg, e, lvl)
			if money - c >= fee:
				money -= c
				levels[hammer.id] = lvl + 1
				changed = true


## Diagnose: hängenden Auftrag erneut simulieren und den Endzustand ausgeben.
func _dump_stuck(job: JobInstance, setup: Dictionary) -> void:
	var s = load("res://scripts/workshop_sim.gd").new(cfg)
	ReferencePlayer.apply_setup(s, setup)
	s.water_level = 0.8
	s.water_timer = 1.0e9
	var copy := job.duplicate_offer()
	copy.reset_pieces(cfg.room_temp)
	s.load_job(copy)
	var bot = load("res://scripts/reference_player.gd").new(cfg, s)
	var t := 0.0
	while t < 600.0:
		bot.act(0.05)
		s.step(0.05)
		t += 0.05
	print("  Setup: ", setup)
	print("  FP %d, Amboss %d, Esse %s, Ausschuss %d" % [copy.form_points, s.anvil, str(s.forge_slots), s.pieces_ruined])
	for i in copy.pieces.size():
		var p = copy.pieces[i]
		print("  Stück %d: %s T=%.0f prog=%.0f/%.0f quench_wait=%s weld=%s step=%d window=%s" % [i, p.location, p.temp, p.progress, copy.piece_fp(), s.awaiting_quench(i), s.in_weld_phase(i), s.step_index(i), s.step_window(i)])
