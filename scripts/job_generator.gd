extends RefCounted
## Prozeduraler Auftrags-Generator (Lastenheft 3.2): Qualitätsstufe + Basis-Gegenstand
## + Kunde (+ Menge). Seed-basiert; der Zustand des Zufallsgenerators wird gespeichert.

const Economy = preload("res://scripts/economy.gd")

var cfg: BalanceConfig
var items: Array = []
var customers: Array = []
var rng := RandomNumberGenerator.new()
var uid_counter: int = 0


func _init(config: BalanceConfig, item_list: Array, customer_list: Array) -> void:
	cfg = config
	items = item_list
	customers = customer_list


func set_seed(seed_value: int, state = null) -> void:
	rng.seed = seed_value
	if state != null:
		rng.state = int(state)


func get_state() -> int:
	return rng.state


func _weighted_index(weights: Array) -> int:
	var total := 0.0
	for w in weights:
		total += float(w)
	if total <= 0.0:
		return 0
	var r := rng.randf() * total
	for i in weights.size():
		r -= float(weights[i])
		if r < 0.0:
			return i
	return weights.size() - 1


## Gewichtung seltener Merkmale nach Komplexitätsgrad c (0..1).
func ramp(c: float) -> float:
	return lerpf(cfg.complexity_ramp_min, cfg.complexity_ramp_max, clampf(c, 0.0, 1.0))


static func complexity_grade(cfg_: BalanceConfig, epoch: int, n: int, free_play: bool) -> float:
	if free_play:
		return 1.0
	var ne: int = cfg_.epoch_job_counts[clampi(epoch, 1, cfg_.epoch_job_counts.size()) - 1]
	return clampf(float(n) / float(maxi(1, ne - 1)), 0.0, 1.0)


## Komplexität eines Gegenstands: Arbeitsgänge, Werkstoff, Aufwand, Sondermechanik.
static func item_complexity(it: ItemData) -> float:
	var score := float(it.steps.size()) + it.factor
	if it.material == "steel":
		score += 0.6
	if it.category != "normal":
		score += 0.5
	return score


func _pick_type(epoch: int, n: int, c: float = 0.5) -> String:
	if epoch == 1 and n < cfg.tutorial_standard_only_jobs:
		return JobInstance.TYPE_STANDARD
	var base: Array = cfg.type_weights[clampi(epoch, 1, cfg.type_weights.size()) - 1]
	var w := [float(base[0]), float(base[1]) * ramp(c), float(base[2]) * ramp(c)]
	match _weighted_index(w):
		1:
			return JobInstance.TYPE_PRECISION
		2:
			return JobInstance.TYPE_RUSH
	return JobInstance.TYPE_STANDARD


## ctx: {"can_weld": bool, "can_harden": bool, "can_big": bool}
func _pick_category(epoch: int, ctx: Dictionary, c: float = 0.5) -> String:
	var e := clampi(epoch, 1, cfg.epoch_job_counts.size()) - 1
	var r := rng.randf()
	var k := ramp(c)
	var weld: float = cfg.weld_share[e] * k if ctx.get("can_weld", true) else 0.0
	var harden: float = cfg.harden_share[e] * k if ctx.get("can_harden", true) else 0.0
	var big: float = cfg.big_share[e] * k if ctx.get("can_big", true) else 0.0
	var total := weld + harden + big
	if total > 0.95:
		weld *= 0.95 / total
		harden *= 0.95 / total
		big *= 0.95 / total
	if r < weld:
		return "weld"
	if r < weld + harden:
		return "harden"
	if r < weld + harden + big:
		return "big"
	return "normal"


func _pick_item(epoch: int, category: String, c: float = -1.0) -> ItemData:
	var pool: Array = []
	for it in items:
		if it.epoch == epoch and it.category == category:
			pool.append(it)
	if pool.is_empty():
		for it in items:
			if it.epoch <= epoch and it.category == category:
				pool.append(it)
	if pool.is_empty():
		for it in items:
			if it.epoch == epoch and it.category == "normal":
				pool.append(it)
	if pool.is_empty():
		pool = items.duplicate()
	if c < 0.0 or pool.size() == 1:
		return pool[rng.randi_range(0, pool.size() - 1)]
	# Nach Komplexität sortieren und bevorzugt Gegenstände nahe am aktuellen Grad wählen
	pool.sort_custom(func(a, b): return item_complexity(a) < item_complexity(b))
	var weights: Array = []
	for i in pool.size():
		var rank := float(i) / float(pool.size() - 1)
		var d := (rank - c) / maxf(cfg.item_complexity_spread, 0.05)
		weights.append(exp(-d * d))
	return pool[_weighted_index(weights)]


func _pick_quality(epoch: int, c: float = -1.0) -> Dictionary:
	var tiers: Array = []
	var weights: Array = []
	for i in cfg.quality_tiers.size():
		var t: Dictionary = cfg.quality_tiers[i]
		if int(t.get("min_epoch", 1)) <= epoch:
			tiers.append(t)
			var w := float(t.get("weight", 1.0))
			if c >= 0.0 and i < cfg.quality_weights_start.size():
				w = lerpf(cfg.quality_weights_start[i], cfg.quality_weights_end[i], c)
			weights.append(w)
	return tiers[_weighted_index(weights)]


func _pick_customer(epoch: int) -> CustomerData:
	var pool: Array = []
	for c in customers:
		if c.min_epoch <= epoch and epoch <= c.max_epoch:
			pool.append(c)
	if pool.is_empty():
		pool = customers.duplicate()
	return pool[rng.randi_range(0, pool.size() - 1)]


func _pick_quantity(epoch: int, item: ItemData, category: String, c: float = 0.5) -> int:
	if category == "big" or not item.allow_quantity:
		return 1
	var chance: float = cfg.quantity_chance[clampi(epoch, 1, cfg.epoch_job_counts.size()) - 1] * ramp(c)
	if rng.randf() >= chance:
		return 1
	# Am Epochenanfang nur kleine Mengen, später bis zur größten
	var max_idx := clampi(int(round(c * float(cfg.quantity_values.size() - 1))), 0, cfg.quantity_values.size() - 1)
	var weights: Array = []
	for i in max_idx + 1:
		weights.append(cfg.quantity_weights[i])
	return cfg.quantity_values[_weighted_index(weights)]


func _next_uid(epoch: int) -> String:
	uid_counter += 1
	return "gen_e%d_%04d" % [epoch, uid_counter]


## Erzeugt einen generierten Auftrag. n = in der Epoche abgeschlossene Aufträge.
func generate(epoch: int, n: int, free_play: bool, ctx: Dictionary) -> JobInstance:
	var j := JobInstance.new()
	var c := complexity_grade(cfg, epoch, n, free_play)
	j.epoch = epoch
	j.type = _pick_type(epoch, n, c)
	j.precise = j.type == JobInstance.TYPE_PRECISION
	var category := _pick_category(epoch, ctx, c)
	var item := _pick_item(epoch, category, c)
	j.category = item.category
	j.template_id = item.id
	j.steps = item.steps.duplicate(true)
	j.material = item.material
	var q := _pick_quality(epoch, c)
	j.quality = str(q.get("id", "solid"))
	j.customer_id = _pick_customer(epoch).id
	j.quantity = _pick_quantity(epoch, item, j.category, c)
	j.form_points = Economy.job_form_points(cfg, epoch, n, item.factor, float(q.get("fp", 1.0)), false, free_play)
	j.reward_base_pence = Economy.reward_base(cfg, epoch, j.form_points, float(q.get("wage", 1.0)), j.type)
	j.uid = _next_uid(epoch)
	return j


## Erzeugt den Auftrag zu einem Story-Meilenstein (3.5).
func make_milestone(ms: MilestoneData, item: ItemData, n: int) -> JobInstance:
	var j := JobInstance.new()
	j.epoch = ms.epoch
	j.type = JobInstance.TYPE_MILESTONE
	j.precise = ms.precision
	j.milestone_id = ms.id
	j.template_id = ms.item_id
	j.category = item.category if item != null else "normal"
	if item != null:
		j.steps = item.steps.duplicate(true)
		j.material = item.material
	j.quality = "solid"
	j.customer_id = ms.customer_id
	j.quantity = maxi(1, ms.quantity)
	var factor := (item.factor if item != null else 1.0) * ms.fp_factor
	j.form_points = Economy.job_form_points(cfg, ms.epoch, n, factor, 1.0, true)
	j.reward_base_pence = Economy.reward_base(cfg, ms.epoch, j.form_points, 1.0, j.type)
	j.uid = ms.id
	return j


## Ab welchem n (abgeschlossene Aufträge der Epoche) der Meilenstein mit `index` von `count` angeboten wird.
static func milestone_unlock_n(cfg: BalanceConfig, epoch: int, index: int, count: int) -> int:
	var ne: int = cfg.epoch_job_counts[clampi(epoch, 1, cfg.epoch_job_counts.size()) - 1]
	return int(round(float(index) * float(ne - 1) / float(maxi(1, count))))
