extends "res://tests/test_base.gd"
## Währungsformatierung, Auftragsformeln, Sterne, Verbesserungen (9.4).

const Economy = preload("res://scripts/economy.gd")
const Catalog = preload("res://scripts/catalog.gd")
var cfg: BalanceConfig = Catalog.BALANCE


func test_format_lsd_table() -> void:
	# Tabelle aus Lastenheft 2.2
	assert_eq(Economy.format_lsd(0, "de"), "0d")
	assert_eq(Economy.format_lsd(6, "de"), "6d")
	assert_eq(Economy.format_lsd(120, "de"), "10s")
	assert_eq(Economy.format_lsd(126, "de"), "10s 6d")
	assert_eq(Economy.format_lsd(2940, "de"), "£12 5s")
	assert_eq(Economy.format_lsd(2946, "de"), "£12 5s 6d")
	assert_eq(Economy.format_lsd(96000, "de"), "£400")
	assert_eq(Economy.format_lsd(240 * 26 + 10, "de"), "£26 10d", "Nullstellen weggelassen")


func test_format_thousands() -> void:
	var v := 12480 * 240 + 5 * 12
	assert_eq(Economy.format_lsd(v, "de"), "£12.480 5s")
	assert_eq(Economy.format_lsd(v, "en"), "£12,480 5s")
	assert_eq(Economy.format_lsd(9999 * 240, "de"), "£9999", "unter £10.000 ohne Trennzeichen")
	assert_eq(Economy.format_lsd(-126, "de"), "-10s 6d")


func test_round_half_up() -> void:
	assert_eq(Economy.round_half_up(2.5), 3)
	assert_eq(Economy.round_half_up(2.4999), 2)
	assert_eq(Economy.round_half_up(-2.5), -3)
	assert_eq(Economy.round_half_up(0.0), 0)


func test_wage_table() -> void:
	# Lastenheft 3.3: Lohn erster/letzter Auftrag (Faktor 1,0, Solide, 2 Sterne, Standard)
	var expected := [[12, 60], [72, 360], [210, 1050], [540, 2700], [1250, 6250], [2600, 13000]]
	for e in range(1, 7):
		var ne: int = cfg.epoch_job_counts[e - 1]
		var fp_first := Economy.job_form_points(cfg, e, 0, 1.0, 1.0, false)
		var fp_last := Economy.job_form_points(cfg, e, ne - 1, 1.0, 1.0, false)
		assert_eq(fp_last, fp_first * 5, "Faktor 5 in Epoche %d" % e)
		var w1 := Economy.job_payout(cfg, Economy.reward_base(cfg, e, fp_first, 1.0, "standard"), false, 2, false)
		var w2 := Economy.job_payout(cfg, Economy.reward_base(cfg, e, fp_last, 1.0, "standard"), false, 2, false)
		assert_eq(w1, expected[e - 1][0], "erster Lohn Epoche %d" % e)
		assert_eq(w2, expected[e - 1][1], "letzter Lohn Epoche %d" % e)


func test_exponent_capped() -> void:
	assert_near(Economy.scale_exponent(cfg, 1, 100), 1.0, 0.0001)
	assert_near(Economy.scale_exponent(cfg, 6, 500, true), cfg.free_play_exponent_cap, 0.0001)
	assert_near(Economy.scale_exponent(cfg, 6, 69, true), 1.0, 0.0001)


func test_milestone_factors() -> void:
	var fp := Economy.job_form_points(cfg, 1, 0, 1.0, 1.0, true)
	assert_eq(fp, Economy.round_half_up(cfg.fp_start[0] * 1.5), "Meilenstein × 1,5")
	# Lohn: 1,5-facher Aufwand × Typfaktor 2,0 = dreifacher Lohn des ersten Auftrags (12d)
	assert_eq(Economy.reward_base(cfg, 1, fp, 1.0, "milestone"), 36, "Typfaktor 2,0")


func test_stars() -> void:
	assert_eq(Economy.star_count(cfg, 0.95), 3)
	assert_eq(Economy.star_count(cfg, 0.90), 3)
	assert_eq(Economy.star_count(cfg, 0.80), 2)
	assert_eq(Economy.star_count(cfg, 0.60), 1)
	assert_eq(Economy.star_count(cfg, 0.20), 0)
	assert_near(Economy.star_factor(cfg, 3, false, false), 1.10, 0.0001)
	assert_near(Economy.star_factor(cfg, 3, true, false), 1.25, 0.0001)
	assert_near(Economy.star_factor(cfg, 0, true, false), 0.60, 0.0001)
	assert_near(Economy.star_factor(cfg, 3, false, true), 1.0, 0.0001, "verspätet: kein Sterne-Bonus")


func test_rush_payout() -> void:
	# Eilauftrag mit dem Aufwand des ersten Auftrags in Epoche 2 (Lohn Standard 72d)
	var fp := int(cfg.fp_start[1])
	var base := Economy.reward_base(cfg, 2, fp, 1.0, "rush")
	assert_eq(base, 108, "72d × Typfaktor 1,5")
	assert_eq(Economy.job_payout(cfg, base, false, 2, false), 108)
	assert_eq(Economy.job_payout(cfg, base, false, 3, true), 36, "verspätet: Typfaktor 0,5 statt 1,5, kein Trinkgeld")


func test_quality_value() -> void:
	assert_near(Economy.quality_value(cfg, 1.0, 0.1), 0.95, 0.0001)
	assert_near(Economy.quality_value(cfg, 0.9, 0.0, 0.15), 0.75, 0.0001)


func test_upgrades() -> void:
	assert_eq(Economy.upgrade_cost(cfg, 1, 0), 30)
	assert_eq(Economy.upgrade_cost(cfg, 1, 1), 42)
	assert_eq(Economy.upgrade_cost(cfg, 6, 0), 15000)
	assert_near(Economy.hammer_power(cfg, 5.0, 10), 10.0, 0.0001, "Stufe 10 = ×2,0")
	assert_near(Economy.hammer_power(cfg, 12.0, 3), 15.6, 0.0001)


func test_fees() -> void:
	assert_eq(Economy.epoch_fee(cfg, 1), 480)
	assert_eq(Economy.epoch_fee(cfg, 5), 96000)
	assert_eq(Economy.epoch_fee(cfg, 6), 240000, "Wechsel 6 → 7")
	assert_eq(Economy.epoch_fee(cfg, 9), 960000, "Wechsel 9 → 10")
	assert_eq(Economy.epoch_fee(cfg, 10), -1, "nach der letzten Epoche keine Gebühr")


func test_items_have_valid_steps() -> void:
	for it in Catalog.ITEMS:
		var total := 0.0
		for s in it.steps:
			assert_true(cfg.step_windows.has(str(s["id"])), "%s: Arbeitsgang %s bekannt" % [it.id, s["id"]])
			total += float(s["share"])
		assert_near(total, 1.0, 0.0001, "%s: Anteile ergeben 1" % it.id)
		if it.category == "weld":
			var cum := 0.0
			var boundary := false
			for s in it.steps:
				cum += float(s["share"])
				if absf(cum - cfg.weld_at_progress) < 0.0001:
					boundary = true
			assert_true(boundary, "%s: Schweißen liegt an einer Arbeitsgang-Grenze" % it.id)
		if it.category == "harden":
			assert_eq(it.material, "steel", "%s: gehärtet wird Stahl" % it.id)
