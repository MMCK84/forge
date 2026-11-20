extends RefCounted
## Meisterschaft je Werkstück (Kernausbau, docs/Roter_Faden.md): Wer ein Werkstück immer wieder
## schmiedet, erreicht Bronze-, Silber- und Goldsiegel. Jede Stufe bringt für dieses Werkstück
## etwas mehr Lohn. Gezählt werden fertige Aufträge (unabhängig von der Stückzahl).

const LEVEL_KEYS := ["", "MASTERY_BRONZE", "MASTERY_SILVER", "MASTERY_GOLD"]
const LEVEL_COLORS := [Color(0.35, 0.3, 0.26), Color("b9783f"), Color("c9ccd4"), Color("e8b84a")]


## Stufe (0–3) nach Anzahl fertiger Aufträge.
static func level(cfg: BalanceConfig, jobs: int) -> int:
	var lv := 0
	for k in cfg.mastery_jobs.size():
		if jobs >= int(cfg.mastery_jobs[k]):
			lv = k + 1
	return lv


## Aufträge bis zur nächsten Stufe (-1: höchste Stufe erreicht).
static func next_threshold(cfg: BalanceConfig, jobs: int) -> int:
	for t in cfg.mastery_jobs:
		if jobs < int(t):
			return int(t)
	return -1


## Lohnfaktor einer Stufe.
static func payout_factor(cfg: BalanceConfig, lv: int) -> float:
	return 1.0 + cfg.mastery_bonus_per_level * float(clampi(lv, 0, cfg.mastery_jobs.size()))


## Eintrag nach einem fertigen Auftrag fortschreiben (Anzahl, beste Sternezahl).
static func record(entry: Dictionary, stars: int) -> void:
	entry["jobs"] = int(entry.get("jobs", 0)) + 1
	entry["best"] = maxi(int(entry.get("best", 0)), stars)
