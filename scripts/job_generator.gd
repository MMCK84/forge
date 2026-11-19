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


func _pick_type(epoch: int, n: int) -> String:
	if epoch == 1 and n < cfg.tutorial_standard_only_jobs:
		return JobInstance.TYPE_STANDARD
	var w: Array = cfg.type_weights[clampi(epoch, 1, cfg.type_weights.size()) - 1]
	match _weighted_index(w):
		1:
			return JobInstance.TYPE_PRECISION
		2:
			return JobInstance.TYPE_RUSH
	return JobInstance.TYPE_STANDARD


## ctx: {"can_weld": bool, "can_harden": bool, "can_big": bool}
func _pick_category(epoch: int, ctx: Dictionary) -> String:
	var e := clampi(epoch, 1, 6) - 1
	var r := rng.randf()
	var weld: float = cfg.weld_share[e] if ctx.get("can_weld", true) else 0.0
	var harden: float = cfg.harden_share[e] if ctx.get("can_harden", true) else 0.0
	var big: float = cfg.big_share[e] if ctx.get("can_big", true) else 0.0
	if r < weld:
		return "weld"
	if r < weld + harden:
		return "harden"
	if r < weld + harden + big:
		return "big"
	return "normal"


func _pick_item(epoch: int, category: String) -> ItemData:
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
	return pool[rng.randi_range(0, pool.size() - 1)]


func _pick_quality(epoch: int) -> Dictionary:
	var tiers: Array = []
	var weights: Array = []
	for t in cfg.quality_tiers:
		if int(t.get("min_epoch", 1)) <= epoch:
			tiers.append(t)
			weights.append(float(t.get("weight", 1.0)))
	return tiers[_weighted_index(weights)]


func _pick_customer(epoch: int) -> CustomerData:
	var pool: Array = []
	for c in customers:
		if c.min_epoch <= epoch and epoch <= c.max_epoch:
			pool.append(c)
	if pool.is_empty():
		pool = customers.duplicate()
	return pool[rng.randi_range(0, pool.size() - 1)]


func _pick_quantity(epoch: int, item: ItemData, category: String) -> int:
	if category == "big" or not item.allow_quantity:
		return 1
	var chance: float = cfg.quantity_chance[clampi(epoch, 1, 6) - 1]
	if rng.randf() >= chance:
		return 1
	return cfg.quantity_values[_weighted_index(Array(cfg.quantity_weights))]


func _next_uid(epoch: int) -> String:
	uid_counter += 1
	return "gen_e%d_%04d" % [epoch, uid_counter]


## Erzeugt einen generierten Auftrag. n = in der Epoche abgeschlossene Aufträge.
func generate(epoch: int, n: int, free_play: bool, ctx: Dictionary) -> JobInstance:
	var j := JobInstance.new()
	j.epoch = epoch
	j.type = _pick_type(epoch, n)
	j.precise = j.type == JobInstance.TYPE_PRECISION
	var category := _pick_category(epoch, ctx)
	var item := _pick_item(epoch, category)
	j.category = item.category
	j.template_id = item.id
	var q := _pick_quality(epoch)
	j.quality = str(q.get("id", "solid"))
	j.customer_id = _pick_customer(epoch).id
	j.quantity = _pick_quantity(epoch, item, j.category)
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
	var ne: int = cfg.epoch_job_counts[clampi(epoch, 1, 6) - 1]
	return int(round(float(index) * float(ne - 1) / float(maxi(1, count))))
