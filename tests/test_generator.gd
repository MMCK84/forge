extends "res://tests/test_base.gd"
## Auftrags-Generator: Seed-Determinismus, Tutorial-Phase, Meilensteine.

const JobGenerator = preload("res://scripts/job_generator.gd")
const Catalog = preload("res://scripts/catalog.gd")
var cfg: BalanceConfig = Catalog.BALANCE


func _gen() -> JobGenerator:
	return JobGenerator.new(cfg, Catalog.ITEMS, Catalog.CUSTOMERS)


func test_deterministic_seed() -> void:
	var a := _gen()
	var b := _gen()
	a.set_seed(918273645)
	b.set_seed(918273645)
	for i in 20:
		var ja := a.generate(3, i, false, {"can_weld": true})
		var jb := b.generate(3, i, false, {"can_weld": true})
		assert_eq(ja.to_dict(false), jb.to_dict(false), "gleicher Seed, gleicher Auftrag")


func test_state_restore() -> void:
	var a := _gen()
	a.set_seed(42)
	a.generate(2, 0, false, {})
	var state := a.get_state()
	var next_a := a.generate(2, 1, false, {}).to_dict(false)
	var b := _gen()
	b.set_seed(42, state)
	b.uid_counter = 1
	assert_eq(b.generate(2, 1, false, {}).to_dict(false), next_a, "Zustand wiederherstellbar")


func test_tutorial_standard_only() -> void:
	var g := _gen()
	g.set_seed(7)
	for i in 10:
		var j := g.generate(1, i, false, {})
		assert_eq(j.type, "standard", "die ersten 10 Aufträge nur Standard")
		assert_eq(j.quantity, 1, "keine Mengenaufträge in Epoche 1")


func test_epoch_items_and_ranges() -> void:
	var g := _gen()
	g.set_seed(99)
	for e in range(1, 7):
		for i in 30:
			var j := g.generate(e, i, false, {"can_weld": true, "can_harden": true, "can_big": true})
			assert_true(j.form_points > 0)
			assert_true(j.reward_base_pence > 0, "Lohn > 0")
			if e < 3:
				assert_true(j.category == "normal", "Spezialmechaniken erst ab Epoche 3")
			if j.quality == "masterly":
				assert_true(e >= 2, "Meisterlich erst ab Epoche 2")


func test_weld_gated_by_forge() -> void:
	var g := _gen()
	g.set_seed(5)
	for i in 50:
		var j := g.generate(3, i, false, {"can_weld": false})
		assert_true(j.category != "weld", "ohne heiße Esse keine Schweißaufträge")


func test_milestones_count_and_unlock() -> void:
	var per_epoch := {}
	for ms in Catalog.MILESTONES:
		per_epoch[ms.epoch] = int(per_epoch.get(ms.epoch, 0)) + 1
	assert_eq(Catalog.MILESTONES.size(), 86, "86 Meilensteine")
	assert_eq(per_epoch, {1: 5, 2: 7, 3: 8, 4: 9, 5: 10, 6: 11, 7: 9, 8: 9, 9: 9, 10: 9})
	assert_eq(JobGenerator.milestone_unlock_n(cfg, 1, 5, 5), 29, "Abschluss-Meilenstein beim letzten Auftrag")
	assert_eq(JobGenerator.milestone_unlock_n(cfg, 1, 1, 5), 6)
	var g := _gen()
	var ms: MilestoneData = Catalog.MILESTONES[0]
	var item: ItemData = null
	for it in Catalog.ITEMS:
		if it.id == ms.item_id:
			item = it
	var j := g.make_milestone(ms, item, 0)
	assert_eq(j.type, "milestone")
	assert_eq(j.form_points, int(round(cfg.fp_start[0] * item.factor * 1.5)))


func test_catalog_references() -> void:
	var ids := {}
	for it in Catalog.ITEMS:
		ids[it.id] = true
	var cust := {}
	for c in Catalog.CUSTOMERS:
		cust[c.id] = true
	for ms in Catalog.MILESTONES:
		assert_true(ids.has(ms.item_id), "Meilenstein %s: Gegenstand vorhanden" % ms.id)
		assert_true(cust.has(ms.customer_id), "Meilenstein %s: Kunde vorhanden" % ms.id)


func _stats(epoch: int, n: int, count: int, seed_value: int) -> Dictionary:
	var g := _gen()
	g.set_seed(seed_value)
	var cx := 0.0
	var qty := 0.0
	var prec := 0
	var special := 0
	var fine := 0
	for i in count:
		var j := g.generate(epoch, n, false, {"can_weld": true, "can_harden": true, "can_big": true})
		var it: ItemData = null
		for x in Catalog.ITEMS:
			if x.id == j.template_id:
				it = x
		cx += JobGenerator.item_complexity(it)
		qty += j.quantity
		if j.is_precision():
			prec += 1
		if j.category != "normal":
			special += 1
		if j.quality == "fine" or j.quality == "masterly":
			fine += 1
	return {"cx": cx / count, "qty": qty / count, "prec": prec, "special": special, "fine": fine}


func test_complexity_rises_within_epoch() -> void:
	for e in [3, 5]:
		var ne: int = cfg.epoch_job_counts[e - 1]
		var early := _stats(e, 0, 300, 11)
		var late := _stats(e, ne - 1, 300, 11)
		assert_true(late["cx"] > early["cx"] + 0.3, "Epoche %d: spätere Gegenstände sind komplexer (%.2f → %.2f)" % [e, early["cx"], late["cx"]])
		assert_true(late["qty"] > early["qty"], "Epoche %d: größere Mengen" % e)
		assert_true(late["prec"] > early["prec"] * 2, "Epoche %d: mehr Präzisionsaufträge" % e)
		assert_true(late["special"] > early["special"] * 2, "Epoche %d: mehr Spezialaufträge" % e)
		assert_true(late["fine"] > early["fine"] * 2, "Epoche %d: höhere Qualitätsstufen" % e)


func test_early_quantities_small() -> void:
	var g := _gen()
	g.set_seed(3)
	for i in 200:
		var j := g.generate(2, 0, false, {})
		assert_true(j.quantity <= 2, "am Epochenanfang höchstens ×2")


func test_jobs_carry_steps() -> void:
	var g := _gen()
	g.set_seed(1)
	for e in range(1, 7):
		var j := g.generate(e, 5, false, {"can_weld": true, "can_harden": true, "can_big": true})
		assert_true(j.steps.size() >= 2, "jeder Auftrag hat Arbeitsgänge")
		var back := JobInstance.from_dict(j.to_dict())
		assert_eq(back.steps, j.steps, "Arbeitsgänge werden gespeichert")
		assert_eq(back.material, j.material)


func test_tutorial_script() -> void:
	var gen := JobGenerator.new(Catalog.BALANCE, Catalog.ITEMS, Catalog.CUSTOMERS)
	gen.set_seed(7)
	var ctx := {"can_weld": false, "can_harden": false, "can_big": false}
	var expect := [["hook", 1], ["nail", 1], ["nail", 2], ["horseshoe", 2], ["horseshoe", 3]]
	for n in expect.size():
		var j: JobInstance = gen.generate(1, n, false, ctx)
		assert_eq(j.template_id, str(expect[n][0]), "Lehrzeit Auftrag %d: Werkstück" % (n + 1))
		assert_eq(j.steps.size(), int(expect[n][1]), "Lehrzeit Auftrag %d: Arbeitsgänge" % (n + 1))
		assert_eq(j.quantity, 1, "Lehrzeit: ein Stück")
		assert_eq(j.type, JobInstance.TYPE_STANDARD, "Lehrzeit: Standardauftrag")
		var total := 0.0
		for st in j.steps:
			total += float(st["share"])
		assert_near(total, 1.0, 0.0001, "Anteile ergeben 1")
	assert_eq(gen.generate(1, 0, false, ctx).step_id(0), "bend", "erster Auftrag: nur Biegen")
	# danach frei gewürfelt mit allen Arbeitsgängen
	var later: JobInstance = gen.generate(1, 10, false, ctx)
	var item: ItemData = null
	for it in Catalog.ITEMS:
		if it.id == later.template_id:
			item = it
	assert_eq(later.steps.size(), item.steps.size(), "nach der Lehrzeit alle Arbeitsgänge")
	# Epoche 2: Eilaufträge erst in der zweiten Hälfte
	for k in 200:
		assert_true(not gen.generate(2, 3, false, ctx).is_rush(), "Epoche 2 Anfang ohne Eilauftrag")


func test_tutorial_offers() -> void:
	var gm = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameManager")
	if gm == null:
		return
	gm.new_game()
	assert_eq(gm.job_offers.size(), 1, "erster Auftrag: ein Angebot")
	assert_true(not gm.force_counts() and not gm.sim.force_enabled, "Lehrzeit: Schlagstärke zählt nicht")
	var script := ["hook", "nail", "nail", "horseshoe", "horseshoe"]
	for n in script.size():
		assert_eq(gm.job_offers[0].template_id, script[n], "Lehrzeit Auftrag %d nach Drehbuch" % (n + 1))
		gm.accept_offer(0)
		gm.debug_finish_job()
		if n < script.size() - 1:
			assert_eq(gm.job_offers.size(), 1, "Lehrzeit: immer genau ein Angebot (keine zwei gleichen)")
	assert_true(gm.force_counts() and gm.sim.force_enabled, "nach der Lehrzeit zählt die Schlagstärke")
	assert_eq(gm.job_offers.size(), 3, "nach der Lehrzeit drei Angebote")
	# Keine doppelten Werkstücke unter den Angeboten (über viele Neuwürfe)
	for k in 30:
		var seen := {}
		for o in gm.job_offers:
			assert_true(not seen.has(o.template_id), "Angebote mit verschiedenen Werkstücken (%s)" % o.template_id)
			seen[o.template_id] = true
		gm.reroll_available_at = 0
		gm.reroll_offers()
	# Lehrzeit-Hilfe übersprungen: Schlagstärke zählt in den ersten Aufträgen trotzdem nicht
	gm.new_game()
	gm.mark_hint_seen("tutorial_done")
	gm.refresh_offers()
	assert_eq(gm.job_offers.size(), 3, "ohne Lehrzeit-Hilfe drei Angebote")
	assert_true(not gm.sim.force_enabled, "ohne Lehrzeit-Hilfe: Schlagstärke zählt in den ersten Aufträgen nicht")
	gm.end_session()


func test_rough_shared_targets() -> void:
	# Geteilte Rohformen: beide Werkstücke gibt es, gleiche Grundform, Ziel teilt nicht selbst weiter
	const Assets = preload("res://scripts/assets.gd")
	var ids := {}
	for f in DirAccess.get_files_at("res://data/items"):
		if f.ends_with(".tres"):
			ids[f.get_basename()] = load("res://data/items/" + f)
	for k in Assets.ROUGH_SHARED:
		var target: String = Assets.ROUGH_SHARED[k]
		assert_true(ids.has(k) and ids.has(target), "Rohform geteilt: %s → %s (beide vorhanden)" % [k, target])
		if ids.has(k) and ids.has(target):
			assert_true(ids[k].shape == ids[target].shape, "gleiche Grundform %s / %s" % [k, target])
			assert_true(str(ids[k].steps[0].get("id", "")) == str(ids[target].steps[0].get("id", "")), "gleicher erster Arbeitsgang %s / %s" % [k, target])
		assert_true(not Assets.ROUGH_SHARED.has(target), "%s teilt nicht selbst weiter" % target)
	assert_true(Assets.rough_tex("post_horseshoe") != null, "Postpferd-Hufeisen nutzt die Hufeisen-Rohform")
