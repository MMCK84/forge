extends "res://scenes/ui/overlay.gd"
## Statistik (6.3): Spielzeit, Aufträge, Sterne, verdientes Geld, Ausschuss.

const Economy = preload("res://scripts/economy.gd")


func _init() -> void:
	title_key = "UI_STATS"
	panel_width = 900.0


func build(box: VBoxContainer) -> void:
	var gm := GameManager
	var st: Dictionary = gm.stats
	var jobs := int(st.get("jobs_completed", 0))
	var stars := int(st.get("stars_total", 0))
	var avg := float(stars) / float(jobs) if jobs > 0 else 0.0
	var rows := [
		["STAT_PLAYTIME", Economy.format_duration(gm.playtime_seconds)],
		["STAT_EPOCH", "%d – %s" % [gm.current_epoch, gm.epoch_name()]],
		["STAT_JOBS", str(jobs)],
		["STAT_MILESTONES", "%d / %d" % [int(st.get("milestones", 0)), gm.milestones.size()]],
		["STAT_STARS", "%d (Ø %.2f)" % [stars, avg]],
		["STAT_THREE_STARS", str(int(st.get("three_star_jobs", 0)))],
		["STAT_REPUTATION", tr(gm.reputation_title_key())],
		["STAT_EARNED", Economy.format_lsd(gm.lifetime_pence)],
		["STAT_BEST", Economy.format_lsd(int(st.get("best_payout", 0)))],
		["STAT_JOURNEYMAN", Economy.format_lsd(int(st.get("journeyman_pence", 0)))],
		["STAT_RUINED", str(int(st.get("pieces_ruined", 0)))],
		["STAT_HITS", str(int(st.get("hits", 0)))],
	]
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 24)
	grid.add_theme_constant_override("v_separation", 8)
	for r in rows:
		grid.add_child(UIKit.label(tr(r[0]), 22, UIKit.INK_LIGHT))
		grid.add_child(UIKit.label(str(r[1]), 22, UIKit.INK))
	box.add_child(grid)
