extends "res://tests/test_base.gd"
## Werkstatt-Einrichtung (scripts/furnishings.gd): Preise, Wirkungen, Kauf, Prämie, Epochenwechsel, Speichern.

const Furnishings = preload("res://scripts/furnishings.gd")
const WorkshopSim = preload("res://scripts/workshop_sim.gd")
const Catalog = preload("res://scripts/catalog.gd")


func _gm():
	return (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameManager")


func test_names_for_all_epochs() -> void:
	for e in range(1, 11):
		for sl in Furnishings.SLOTS:
			assert_true(Furnishings.NAMES.has(e) and Furnishings.NAMES[e].has(sl), "Name für Epoche %d, Platz %s" % [e, sl])
			assert_true(TranslationServer.translate(Furnishings.name_key(e, sl)) != Furnishings.name_key(e, sl), "Übersetzung %s" % Furnishings.name_key(e, sl))


func test_prices() -> void:
	var cfg: BalanceConfig = Catalog.BALANCE
	var share := 0.0
	for sl in Furnishings.SLOTS:
		share += float(Furnishings.PRICE_SHARE[sl])
	assert_near(share, 0.40, 0.0001, "alle fünf zusammen 40 % der Basis")
	for e in range(1, 11):
		var last := 0
		for sl in Furnishings.slots_by_price():
			var p := Furnishings.price(cfg, e, sl)
			assert_true(p > 0 and p >= last, "Preise steigen (Epoche %d, %s)" % [e, sl])
			last = p
	assert_eq(Furnishings.base(cfg, 1), cfg.epoch_fees[0], "Basis = Meistergebühr")
	assert_eq(Furnishings.base(cfg, 10), Furnishings.LAST_EPOCH_BASE, "Epoche 10 ohne Gebühr")


func test_effects() -> void:
	var none := Furnishings.effects([], 3)
	assert_eq(none["heat_factor"], 1.0)
	assert_eq(none["offers_count"], -1)
	var all := Furnishings.effects(Furnishings.SLOTS, 3)
	assert_near(all["heat_factor"], 1.15, 0.0001)
	assert_near(all["power_factor"], 1.10, 0.0001)
	assert_eq(all["big_factor_mult"], 1.0, "Kran erst ab Epoche 9")
	assert_near(Furnishings.effects(["tools"], 9)["big_factor_mult"], Furnishings.BIG_FACTOR_MULT, 0.0001)
	assert_eq(all["offers_count"], 4)
	assert_near(all["payout_factor"], 1.05, 0.0001)


func test_sim_window_and_damage() -> void:
	var cfg: BalanceConfig = Catalog.BALANCE
	var s := WorkshopSim.new(cfg)
	var w0: Vector2 = s.window_for_step("draw")
	s.window_bonus = 25.0
	var w1: Vector2 = s.window_for_step("draw")
	assert_near(w1.x, w0.x - 25.0, 0.001, "Fenster unten breiter")
	assert_near(w1.y, w0.y + 25.0, 0.001, "Fenster oben breiter")


func test_buy_and_bonus() -> void:
	var gm = _gm()
	if gm == null:
		return
	gm.new_game()
	assert_true(not gm.buy_furnishing("fuel"), "ohne Geld kein Kauf")
	var k0: float = gm.sim.k_heat
	var p0: float = gm.current_hammer_power()
	gm.debug_add_money(1000000)
	assert_true(gm.buy_furnishing("fuel"), "Brennstoff gekauft")
	assert_true(not gm.buy_furnishing("fuel"), "nicht doppelt")
	assert_true(not gm.buy_furnishing("mithril"), "unbekannter Platz")
	assert_near(gm.sim.k_heat, k0 * 1.15, 0.001, "Esse heizt schneller")
	gm.buy_furnishing("tools")
	assert_near(gm.current_hammer_power(), p0 * 1.10, 0.001, "Schlagkraft +10 %")
	gm.buy_furnishing("bench")
	assert_near(gm.sim.window_bonus, 25.0, 0.001)
	assert_near(gm.sim.damage_factor, 0.8, 0.001)
	assert_eq(gm.job_offers.size(), 3)
	gm.buy_furnishing("trade")
	assert_eq(gm.job_offers.size(), 4, "vier Angebote")
	assert_eq(gm.reroll_cooldown_s(), 30)
	var before: int = gm.total_pence
	var price: int = gm.furnish_price("light")
	assert_true(gm.buy_furnishing("light"))
	assert_true(gm.fully_furnished(), "vollständig eingerichtet")
	assert_eq(gm.total_pence, before - price + Furnishings.complete_bonus(gm.cfg, 1), "Prämie der Zunft")
	assert_eq(int(gm.stats.get("workshops_furnished", 0)), 1)
	# Speichern und Laden
	var d: Dictionary = JSON.parse_string(JSON.stringify(gm.to_save_dict()))
	gm.new_game()
	assert_true(gm.furnished.is_empty(), "neues Spiel ohne Einrichtung")
	d["progress"]["furnished"].append("mithril")
	gm.load_from_dict(d)
	assert_eq(gm.furnished.size(), 5, "Einrichtung geladen, unbekannte Plätze ignoriert")
	assert_near(gm.sim.k_heat, k0 * 1.15, 0.001, "Wirkung nach dem Laden")
	# Neue Epoche: Einrichtung beginnt von vorn
	gm.debug_set_epoch(2, 0.0, false)
	assert_true(gm.furnished.is_empty(), "neue Epoche ohne Einrichtung")
	assert_eq(gm.job_offers.size(), 3)
	gm.end_session()
