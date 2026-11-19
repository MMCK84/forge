extends "res://tests/test_base.gd"
## Temperatur-Multiplikator M(T), Gefügeschaden, Härten (2.4, 2.5, 4.4.2).

const HeatModel = preload("res://scripts/heat_model.gd")
const Catalog = preload("res://scripts/catalog.gd")
var cfg: BalanceConfig = Catalog.BALANCE


func test_multiplier() -> void:
	assert_near(HeatModel.multiplier(cfg, 399.0), 0.0, 0.0001, "kalt")
	assert_near(HeatModel.multiplier(cfg, 400.0), 0.1, 0.0001, "Anwärmbereich Beginn")
	assert_near(HeatModel.multiplier(cfg, 550.0), 0.55, 0.0001, "Anwärmbereich Mitte")
	assert_near(HeatModel.multiplier(cfg, 700.0), 1.0, 0.0001)
	assert_near(HeatModel.multiplier(cfg, 1100.0), 1.0, 0.0001)
	assert_near(HeatModel.multiplier(cfg, 1200.0), 0.75, 0.0001, "überhitzt")
	assert_near(HeatModel.multiplier(cfg, 1300.0), 0.5, 0.0001)


func test_zones() -> void:
	assert_eq(HeatModel.zone(cfg, 100.0), "cold")
	assert_eq(HeatModel.zone(cfg, 500.0), "warm")
	assert_eq(HeatModel.zone(cfg, 900.0), "optimal")
	assert_eq(HeatModel.zone(cfg, 1200.0), "overheat")
	assert_eq(HeatModel.zone(cfg, 1301.0), "burned")


func test_overheat_damage() -> void:
	assert_near(HeatModel.overheat_damage_rate(cfg, 1100.0), 0.0, 0.0001)
	assert_near(HeatModel.overheat_damage_rate(cfg, 1200.0), 0.03, 0.0001)
	assert_near(HeatModel.overheat_damage_rate(cfg, 1300.0), 0.06, 0.0001)


func test_windows() -> void:
	assert_true(HeatModel.in_window(cfg, 750.0, false))
	assert_true(not HeatModel.in_window(cfg, 750.0, true), "Präzision 850–1000")
	assert_true(HeatModel.in_window(cfg, 900.0, true))
	assert_true(HeatModel.in_weld_window(cfg, 1250.0))
	assert_true(not HeatModel.in_weld_window(cfg, 1150.0))


func test_quench() -> void:
	assert_eq(HeatModel.quench_result(cfg, 800.0)["result"], "good")
	assert_eq(HeatModel.quench_result(cfg, 720.0)["result"], "uneven")
	assert_eq(HeatModel.quench_result(cfg, 880.0)["result"], "uneven")
	assert_eq(HeatModel.quench_result(cfg, 650.0)["result"], "soft")
	assert_eq(HeatModel.quench_result(cfg, 950.0)["result"], "crack")
	assert_near(HeatModel.quench_result(cfg, 950.0)["penalty"], 0.35, 0.0001)


func test_glow_colors_continuous() -> void:
	var prev := HeatModel.glow_color(20.0)
	for t in range(30, 1450, 10):
		var c := HeatModel.glow_color(float(t))
		var diff := absf(c.r - prev.r) + absf(c.g - prev.g) + absf(c.b - prev.b)
		assert_true(diff < 0.2, "kein Sprung bei %d °C" % t)
		prev = c
