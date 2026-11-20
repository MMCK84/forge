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
	# Epoche 2 bringt schon Zweiplatz-Esse, Mengenaufträge, mittlere Schläge und den Lehrling:
	# Eilaufträge kommen erst in der zweiten Hälfte dazu
	if epoch == cfg.rush_from_epoch and c < cfg.rush_from_grade:
		w[2] = 0.0
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


## Drehbuch der Lehrzeit (Epoche 1, Aufträge 1–5): vom Einfachsten zum Vollständigen.
## Jeder Eintrag: Werkstück und die Arbeitsgänge, die verlangt werden.
##   1. Haken biegen – ein Arbeitsgang, niedrige Hitze (Kirschrot)
##   2. Nagel anspitzen – ein Arbeitsgang, etwas heißer
##   3. Nagel strecken und anspitzen – zwei Zielfenster nacheinander
##   4. Hufeisen strecken und biegen – zwei Arbeitsgänge mit großem Hitzeunterschied
##   5. Hufeisen vollständig (strecken, biegen, lochen) – alle Arbeitsgänge
const TUTORIAL_SCRIPT := [
	["hook", ["bend"]],
	["nail", ["point"]],
	["nail", ["draw", "point"]],
	["horseshoe", ["draw", "bend"]],
	["horseshoe", ["draw", "bend", "punch"]],
]


## Lehrzeit-Auftrag nach Drehbuch? (nur Epoche 1, nicht im Freien Spiel)
static func tutorial_entry(epoch: int, n: int, free_play: bool) -> Array:
	if epoch != 1 or free_play or n < 0 or n >= TUTORIAL_SCRIPT.size():
		return []
	return TUTORIAL_SCRIPT[n]


## Nur die genannten Arbeitsgänge (Reihenfolge des Werkstücks); ihre Anteile werden auf 1 hochgerechnet.
static func select_steps(steps: Array, ids: Array) -> Array:
	var out: Array = []
	for st in steps:
		if ids.has(str(st.get("id", ""))):
			out.append(st.duplicate(true))
	if out.is_empty():
		return steps.duplicate(true)
	var total := 0.0
	for st in out:
		total += float(st.get("share", 0.0))
	for st in out:
		st["share"] = float(st.get("share", 0.0)) / maxf(total, 0.0001)
	return out


## Erzeugt einen generierten Auftrag. n = in der Epoche abgeschlossene Aufträge.
func generate(epoch: int, n: int, free_play: bool, ctx: Dictionary) -> JobInstance:
	var j := JobInstance.new()
	var c := complexity_grade(cfg, epoch, n, free_play)
	j.epoch = epoch
	var script := tutorial_entry(epoch, n, free_play)
	var item: ItemData = null
	if not script.is_empty():
		for it in items:
			if it.id == str(script[0]):
				item = it
	if item != null:
		# Lehrzeit nach Drehbuch: Standardauftrag, ein Stück, einfache Qualität
		j.type = JobInstance.TYPE_STANDARD
		j.precise = false
		j.category = item.category
		j.template_id = item.id
		j.steps = select_steps(item.steps, script[1])
		j.material = item.material
		var q0: Dictionary = cfg.quality_tiers[0]
		j.quality = str(q0.get("id", "simple"))
		j.customer_id = _pick_customer(epoch).id
		j.quantity = 1
		j.form_points = Economy.job_form_points(cfg, epoch, n, item.factor, float(q0.get("fp", 1.0)), false, free_play)
		j.reward_base_pence = Economy.reward_base(cfg, epoch, j.form_points, float(q0.get("wage", 1.0)), j.type)
		j.uid = _next_uid(epoch)
		return j
	j.type = _pick_type(epoch, n, c)
	j.precise = j.type == JobInstance.TYPE_PRECISION
	var category := _pick_category(epoch, ctx, c)
	item = _pick_item(epoch, category, c)
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


## Vorarbeit eines Meisterstücks: eigener Gegenstand und eigene Menge, sonst wie der Meilenstein.
func make_masterpiece_part(ms: MilestoneData, item: ItemData, qty: int, precise: bool, n: int, part: int, parts: int) -> JobInstance:
	var j := JobInstance.new()
	j.epoch = ms.epoch
	j.type = JobInstance.TYPE_MILESTONE
	j.precise = precise
	j.milestone_id = ms.id
	j.template_id = item.id
	j.category = item.category
	j.steps = item.steps.duplicate(true)
	j.material = item.material
	j.quality = "solid"
	j.customer_id = ms.customer_id
	j.quantity = maxi(1, qty)
	j.form_points = Economy.job_form_points(cfg, ms.epoch, n, item.factor, 1.0, true)
	j.reward_base_pence = Economy.reward_base(cfg, ms.epoch, j.form_points, 1.0, j.type)
	j.uid = "%s_p%d" % [ms.id, part]
	j.part = part
	j.parts = parts
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
