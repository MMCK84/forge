extends "res://scenes/ui/overlay.gd"
## Abrechnung nach jedem Auftrag (6.3): Sterne, Trefferquote, Schaden, Lohn, Abzüge, Trinkgeld.

const Economy = preload("res://scripts/economy.gd")
const Assets = preload("res://scripts/assets.gd")
const JobBook = preload("res://scenes/ui/job_book.gd")

var report: Dictionary = {}
var _continue_btn: Button
signal continue_pressed(report: Dictionary)
signal menu_pressed(report: Dictionary)
signal repeat_pressed(report: Dictionary)


func _init() -> void:
	title_key = "UI_SETTLEMENT"
	panel_width = 900.0


func build(box: VBoxContainer) -> void:
	var gm := GameManager
	var j: JobInstance = report["job"]
	var head := HBoxContainer.new()
	box.add_child(head)
	var title := UIKit.label(gm.job_title(j), 28, UIKit.INK)
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.custom_minimum_size.x = 400
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(title)
	var seal := ""
	if j.is_milestone():
		seal = "seal_victoria.png" if j.epoch >= 9 else "seal_george_iii.png"
	elif JobBook.NAVY.has(j.customer_id):
		seal = "seal_admiralty.png"
	if seal != "" and Assets.user(seal) != null:
		head.add_child(UIKit.icon("ui/user/" + seal, 96.0))
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
	var net_row := HBoxContainer.new()
	net_row.add_child(UIKit.label(tr("SET_NET") + ": " + Economy.format_lsd(int(report["net"])), 32, UIKit.GREEN))
	net_row.add_child(_coins(int(report["net"])))
	box.add_child(net_row)
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_END
	row.add_theme_constant_override("separation", 10)
	row.add_child(UIKit.button(tr("UI_SETTLE_MENU"), _menu, Vector2(150, 64), 22))
	if not j.is_milestone():
		var rep := UIKit.button(tr("UI_REPEAT_JOB"), _repeat, Vector2(270, 64), 22)
		rep.disabled = gm.job_requirement_issue(j) != ""
		row.add_child(rep)
	_continue_btn = UIKit.button(tr("UI_CONTINUE"), _continue, Vector2(180, 64))
	row.add_child(_continue_btn)
	box.add_child(row)


## Münzen passend zum Betrag: Guinee für Pfund, Shilling, Halfpenny für Pence.
func _coins(pence: int) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", -14)
	if pence <= 0:
		return row
	var parts := [[pence >= 240, "coin_guinea.png"], [(pence % 240) >= 12, "coin_shilling.png"], [pence % 12 > 0, "coin_halfpenny.png"]]
	for p in parts:
		if bool(p[0]) and Assets.user(str(p[1])) != null:
			row.add_child(UIKit.icon("ui/user/" + str(p[1]), 52.0))
	return row


## „Weiter“ ist vorausgewählt (Enter/Leertaste wie gewohnt).
func _focus_first() -> void:
	if _continue_btn != null:
		_continue_btn.grab_focus()


func _menu() -> void:
	var r := report
	close()
	menu_pressed.emit(r)


func _repeat() -> void:
	var r := report
	close()
	repeat_pressed.emit(r)


func _continue() -> void:
	var r := report
	close()
	continue_pressed.emit(r)
