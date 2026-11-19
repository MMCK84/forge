extends "res://scenes/ui/overlay.gd"
## Abrechnung nach jedem Auftrag (6.3): Sterne, Trefferquote, Schaden, Lohn, Abzüge, Trinkgeld.

const Economy = preload("res://scripts/economy.gd")

var report: Dictionary = {}
signal continue_pressed(report: Dictionary)


func _init() -> void:
	title_key = "UI_SETTLEMENT"
	panel_width = 900.0


func build(box: VBoxContainer) -> void:
	var gm := GameManager
	var j: JobInstance = report["job"]
	var title := UIKit.label(gm.job_title(j), 28, UIKit.INK)
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.custom_minimum_size.x = 800
	box.add_child(title)
	var stars_row := CenterContainer.new()
	stars_row.add_child(UIKit.stars_view(int(report["stars"]), 64.0))
	box.add_child(stars_row)
	var lines: Array = []
	lines.append(["SET_HIT_QUOTE", "%d %%" % int(round(float(report["hit_quote"]) * 100.0))])
	lines.append(["SET_DAMAGE", "%d %%" % int(round(float(report["damage"]) * 100.0))])
	if j.needs_harden():
		lines.append(["SET_QUENCH", "-%.2f" % float(report["quench_penalty"])])
	lines.append(["SET_QUALITY", "%.2f" % float(report["q"])])
	if bool(report["late"]):
		lines.append(["SET_LATE", ""])
	lines.append(["SET_WAGE", Economy.format_lsd(int(report["gross"]) - int(report["tip"]))])
	if int(report["tip"]) > 0:
		lines.append(["SET_TIP", "+" + Economy.format_lsd(int(report["tip"]))])
	var wages: Dictionary = report["wages"]
	for sid in wages:
		lines.append([tr("SET_WAGE_OF").format({"who": tr(str(sid).to_upper())}), "-" + Economy.format_lsd(int(wages[sid]))])
	if int(report["costs"]) > 0:
		lines.append(["SET_COSTS", "-" + Economy.format_lsd(int(report["costs"])) + " " + tr("SET_ALREADY_PAID")])
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 40)
	for l in lines:
		grid.add_child(UIKit.label(tr(l[0]), 24, UIKit.INK_LIGHT))
		grid.add_child(UIKit.label(str(l[1]), 24, UIKit.INK))
	box.add_child(grid)
	box.add_child(UIKit.hsep())
	box.add_child(UIKit.label(tr("SET_NET") + ": " + Economy.format_lsd(int(report["net"])), 32, UIKit.GREEN))
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_END
	row.add_child(UIKit.button(tr("UI_CONTINUE"), _continue, Vector2(240, 64)))
	box.add_child(row)


func _continue() -> void:
	var r := report
	close()
	continue_pressed.emit(r)
