extends RefCounted
## Wirtschaftsformeln und £-s-d-Formatierung (Lastenheft 2.2, 2.6, 3.3, 5.2).
## Alle Geldbeträge sind Ganzzahlen in Pence.

const PENCE_PER_SHILLING := 12
const PENCE_PER_POUND := 240


## Kaufmännische Rundung auf ganze Pence.
static func round_half_up(x: float) -> int:
	if x >= 0.0:
		return int(floor(x + 0.5))
	return -int(floor(-x + 0.5))


## Historische Schreibweise: "£12 5s 6d", Nullstellen werden weggelassen.
## Ab £10.000 mit Tausendertrennzeichen (de: ".", en: ",").
static func format_lsd(pence: int, locale: String = "") -> String:
	if locale == "":
		locale = TranslationServer.get_locale()
	var negative := pence < 0
	var v: int = absi(pence)
	var pounds: int = v / PENCE_PER_POUND
	var rest: int = v % PENCE_PER_POUND
	var shillings: int = rest / PENCE_PER_SHILLING
	var d: int = rest % PENCE_PER_SHILLING
	var parts: PackedStringArray = []
	if pounds > 0:
		var ps := str(pounds)
		if pounds >= 10000:
			ps = group_thousands(pounds, "." if locale.begins_with("de") else ",")
		parts.append("£" + ps)
	if shillings > 0:
		parts.append(str(shillings) + "s")
	if v == 0:
		return "£0"
	if d > 0 or parts.is_empty():
		parts.append(str(d) + "d")
	var s := " ".join(parts)
	return ("-" + s) if negative else s


static func group_thousands(value: int, sep: String) -> String:
	var s := str(value)
	var out := ""
	var count := 0
	for i in range(s.length() - 1, -1, -1):
		out = s[i] + out
		count += 1
		if count % 3 == 0 and i > 0:
			out = sep + out
	return out


## Exponent der Skalierung innerhalb einer Epoche: n / (N_e − 1),
## gedeckelt bei 1 (bzw. im Freien Spiel nach Epoche 6 bei free_play_exponent_cap).
static func scale_exponent(cfg: BalanceConfig, epoch: int, n: int, free_play: bool = false) -> float:
	var ne: int = cfg.epoch_job_counts[clampi(epoch, 1, cfg.epoch_job_counts.size()) - 1]
	var x := float(n) / float(maxi(1, ne - 1))
	var cap := cfg.free_play_exponent_cap if free_play else 1.0
	return clampf(x, 0.0, cap)


## Form-Punkte = FP_Start(e) × Gegenstands-Faktor × Q_FP × 5^(n/(N_e−1)) [× 1,5 bei Meilensteinen]
static func job_form_points(cfg: BalanceConfig, epoch: int, n: int, item_factor: float, q_fp: float, milestone: bool, free_play: bool = false) -> int:
	var e := clampi(epoch, 1, cfg.epoch_job_counts.size())
	var fp := cfg.fp_start[e - 1] * item_factor * q_fp * pow(cfg.scale_per_epoch, scale_exponent(cfg, e, n, free_play))
	if milestone:
		fp *= cfg.milestone_fp_factor
	return maxi(1, round_half_up(fp))


static func type_factor(cfg: BalanceConfig, job_type: String) -> float:
	match job_type:
		"precision":
			return cfg.type_factor_precision
		"rush":
			return cfg.type_factor_rush
		"milestone":
			return cfg.type_factor_milestone
	return cfg.type_factor_standard


## Lohn (d) bei 2 Sternen (Sternefaktor 1,0) und rechtzeitiger Lieferung.
static func reward_base(cfg: BalanceConfig, epoch: int, form_points: int, q_l: float, job_type: String) -> int:
	var e := clampi(epoch, 1, cfg.epoch_job_counts.size())
	return round_half_up(float(form_points) * cfg.rate_per_fp[e - 1] * q_l * type_factor(cfg, job_type))


## Q = Trefferquote − 0,5 × D − Härte-Abzug
static func quality_value(cfg: BalanceConfig, hit_quote: float, avg_damage: float, quench_penalty: float = 0.0) -> float:
	return hit_quote - cfg.q_damage_weight * avg_damage - quench_penalty


static func star_count(cfg: BalanceConfig, q: float) -> int:
	var stars := 0
	for i in cfg.star_thresholds.size():
		if q >= cfg.star_thresholds[i] - 0.000001:
			stars = i + 1
	return stars


static func star_factor(cfg: BalanceConfig, stars: int, precision: bool, late: bool) -> float:
	var table := cfg.star_factor_precision if precision else cfg.star_factor_standard
	var f: float = table[clampi(stars, 0, table.size() - 1)]
	if late:
		f = minf(f, 1.0)
	return f


## Auszahlungsbetrag vor Personalabzügen.
static func job_payout(cfg: BalanceConfig, reward_base_pence: int, precise: bool, stars: int, late: bool) -> int:
	var f := star_factor(cfg, stars, precise, late)
	var amount := float(reward_base_pence) * f
	if late:
		amount *= cfg.type_factor_rush_late / cfg.type_factor_rush
	return round_half_up(amount)


static func hammer_power(cfg: BalanceConfig, p_base: float, level: int) -> float:
	return p_base * (1.0 + cfg.upgrade_step * float(clampi(level, 0, cfg.upgrade_max_level)))


## Kosten der nächsten Verbesserungsstufe: Basis(e) × 1,4^L
static func upgrade_cost(cfg: BalanceConfig, epoch: int, level: int) -> int:
	var e := clampi(epoch, 1, cfg.epoch_job_counts.size())
	return round_half_up(float(cfg.upgrade_base[e - 1]) * pow(cfg.upgrade_growth, level))


## Meistergebühr für den Wechsel von Epoche `from_epoch` in die nächste; -1 wenn keine.
static func epoch_fee(cfg: BalanceConfig, from_epoch: int) -> int:
	if from_epoch < 1 or from_epoch > cfg.epoch_fees.size():
		return -1
	return cfg.epoch_fees[from_epoch - 1]


## Kosten für einen neuen Rohling nach Ausschuss (20 % des Auftragslohns).
static func ruin_cost(cfg: BalanceConfig, reward_base_pence: int) -> int:
	return round_half_up(float(reward_base_pence) * cfg.ruin_material_cost)


static func format_duration(seconds: float) -> String:
	var s := maxi(0, int(round(seconds)))
	if s >= 3600:
		return "%d:%02d:%02d" % [s / 3600, (s % 3600) / 60, s % 60]
	return "%d:%02d" % [s / 60, s % 60]
