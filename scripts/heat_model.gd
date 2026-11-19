extends RefCounted
## Temperaturmodell, Temperatur-Multiplikator M(T), Gefügeschaden, Härten
## und Glutfarben (Lastenheft 2.3–2.5, 4.4.2, 6.5).

const ZONE_COLD := "cold"
const ZONE_WARM := "warm"
const ZONE_OPTIMAL := "optimal"
const ZONE_OVERHEAT := "overheat"
const ZONE_BURNED := "burned"

## Stützpunkte der Glutfarben (6.5); stufenlos interpoliert.
const GLOW_STOPS := [
	[20.0, Color(0.42, 0.42, 0.44)],
	[450.0, Color(0.36, 0.33, 0.33)],
	[500.0, Color(0.33, 0.10, 0.07)],
	[600.0, Color(0.52, 0.06, 0.04)],
	[700.0, Color(0.75, 0.08, 0.06)],
	[800.0, Color(0.92, 0.18, 0.10)],
	[900.0, Color(1.00, 0.36, 0.10)],
	[1000.0, Color(1.00, 0.52, 0.12)],
	[1100.0, Color(1.00, 0.68, 0.18)],
	[1200.0, Color(1.00, 0.88, 0.32)],
	[1300.0, Color(1.00, 0.97, 0.75)],
	[1450.0, Color(1.00, 1.00, 1.00)],
]
const GLOW_T_MAX := 1450.0


static func zone(cfg: BalanceConfig, t: float) -> String:
	if t < cfg.cold_limit:
		return ZONE_COLD
	if t < cfg.optimal_min:
		return ZONE_WARM
	if t <= cfg.optimal_max:
		return ZONE_OPTIMAL
	if t <= cfg.burn_limit:
		return ZONE_OVERHEAT
	return ZONE_BURNED


## Temperatur-Multiplikator M(T) (2.4).
static func multiplier(cfg: BalanceConfig, t: float) -> float:
	if t < cfg.cold_limit:
		return 0.0
	if t < cfg.optimal_min:
		return cfg.warm_min_mult + (1.0 - cfg.warm_min_mult) * (t - cfg.cold_limit) / (cfg.optimal_min - cfg.cold_limit)
	if t <= cfg.optimal_max:
		return 1.0
	if t <= cfg.burn_limit:
		return 1.0 - (1.0 - cfg.overheat_min_mult) * (t - cfg.optimal_max) / (cfg.burn_limit - cfg.optimal_max)
	return 0.0


## Gefügeschaden pro Sekunde durch Überhitzung (2.5): 6 % × (T − 1100) / 200.
static func overheat_damage_rate(cfg: BalanceConfig, t: float) -> float:
	if t <= cfg.optimal_max:
		return 0.0
	return cfg.overheat_damage_per_s * (t - cfg.optimal_max) / (cfg.burn_limit - cfg.optimal_max)


static func window(cfg: BalanceConfig, precision: bool) -> Vector2:
	if precision:
		return Vector2(cfg.precision_window_min, cfg.precision_window_max)
	return Vector2(cfg.optimal_min, cfg.optimal_max)


static func in_window(cfg: BalanceConfig, t: float, precision: bool) -> bool:
	var w := window(cfg, precision)
	return t >= w.x and t <= w.y


static func in_weld_window(cfg: BalanceConfig, t: float) -> bool:
	return t >= cfg.weld_min and t <= cfg.weld_max


## Bewertung des Abschreckens (4.4.2): {"result": String, "penalty": float}
static func quench_result(cfg: BalanceConfig, t: float) -> Dictionary:
	if t >= cfg.quench_good_min and t <= cfg.quench_good_max:
		return {"result": "good", "penalty": 0.0}
	if t >= cfg.quench_ok_min and t <= cfg.quench_ok_max:
		return {"result": "uneven", "penalty": cfg.quench_uneven_penalty}
	if t < cfg.quench_ok_min:
		return {"result": "soft", "penalty": cfg.quench_bad_penalty}
	return {"result": "crack", "penalty": cfg.quench_bad_penalty}


static func glow_color(t: float) -> Color:
	if t <= GLOW_STOPS[0][0]:
		return GLOW_STOPS[0][1]
	for i in range(1, GLOW_STOPS.size()):
		var t1: float = GLOW_STOPS[i][0]
		if t <= t1:
			var t0: float = GLOW_STOPS[i - 1][0]
			var c0: Color = GLOW_STOPS[i - 1][1]
			var c1: Color = GLOW_STOPS[i][1]
			return c0.lerp(c1, (t - t0) / (t1 - t0))
	return GLOW_STOPS[GLOW_STOPS.size() - 1][1]


## Verlaufstextur für den Glow-Shader (x = T / GLOW_T_MAX).
static func make_glow_gradient() -> Gradient:
	var g := Gradient.new()
	var offsets := PackedFloat32Array()
	var colors := PackedColorArray()
	for stop in GLOW_STOPS:
		offsets.append(clampf(float(stop[0]) / GLOW_T_MAX, 0.0, 1.0))
		colors.append(stop[1])
	g.offsets = offsets
	g.colors = colors
	return g


## Leuchtstärke (0..1) für den Glow-Effekt.
static func glow_strength(t: float) -> float:
	return clampf((t - 450.0) / 850.0, 0.0, 1.0)


## Übersetzungsschlüssel der Glutfarbe zur Anzeige.
static func glow_name_key(t: float) -> String:
	if t < 450.0:
		return "GLOW_NONE"
	if t < 550.0:
		return "GLOW_FAINT_RED"
	if t < 650.0:
		return "GLOW_DARK_RED"
	if t < 750.0:
		return "GLOW_CHERRY"
	if t < 850.0:
		return "GLOW_LIGHT_CHERRY"
	if t < 950.0:
		return "GLOW_RED_ORANGE"
	if t < 1050.0:
		return "GLOW_ORANGE"
	if t < 1150.0:
		return "GLOW_YELLOW_ORANGE"
	if t < 1250.0:
		return "GLOW_YELLOW"
	return "GLOW_WHITE"
