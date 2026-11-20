extends "res://scenes/ui/overlay.gd"
## Abrechnung nach jedem Auftrag (6.3): Sterne, Trefferquote, Schaden, Lohn, Abzüge, Trinkgeld.

const Economy = preload("res://scripts/economy.gd")
const Assets = preload("res://scripts/assets.gd")
const JobBook = preload("res://scenes/ui/job_book.gd")
const Mastery = preload("res://scripts/mastery.gd")
const Seal = preload("res://scenes/ui/mastery_seal.gd")
const Masterpieces = preload("res://scripts/masterpieces.gd")

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
	_masterpiece_row(box, j)
	_mastery_row(box, j)
	var lines: Array = []
	lines.append(["SET_HIT_QUOTE", "%d %%" % int(round(float(report["hit_quote"]) * 100.0))])
	if int(report.get("best_streak", 0)) >= 3:
		lines.append(["SET_BEST_STREAK", str(int(report["best_streak"]))])
	lines.append(["SET_DAMAGE", "%d %%" % int(round(float(report["damage"]) * 100.0))])
	if j.needs_harden():
		lines.append(["SET_QUENCH", "-%.2f" % float(report["quench_penalty"])])
	lines.append(["SET_QUALITY", "%.2f" % float(report["q"])])
	if bool(report["late"]):
		lines.append(["SET_LATE", ""])
	lines.append(["SET_WAGE", Economy.format_lsd(int(report["gross"]) - int(report["tip"]))])
	if float(report.get("mastery_bonus", 0.0)) > 0.0001:
		lines.append(["SET_MASTERY_BONUS", "+%d %%" % int(round(float(report["mastery_bonus"]) * 100.0))])
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


## Meisterschaft des Werkstücks: neues Siegel groß, sonst Fortschritt bis zur nächsten Stufe.
func _mastery_row(box: VBoxContainer, j: JobInstance) -> void:
	if not report.has("mastery_after"):
		return
	var gm := GameManager
	var before := int(report["mastery_before"])
	var after := int(report["mastery_after"])
	var jobs := int(report.get("mastery_jobs", 0))
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 14)
	var item := gm.item_name(j.template_id)
	if after > before:
		row.add_child(Seal.make(after, 72.0))
		var pct := int(round((Mastery.payout_factor(gm.cfg, after) - 1.0) * 100.0))
		row.add_child(UIKit.wrap_label(tr("SET_MASTERY_NEW").format({"level": tr(Mastery.LEVEL_KEYS[after]), "item": item, "p": pct}), 24, UIKit.GREEN, 440))
		GameManager.sim_event.emit("mastery_up", {"level": after})
	else:
		row.add_child(Seal.make(after, 40.0))
		var nt := Mastery.next_threshold(gm.cfg, jobs)
		var text := ""
		if nt > 0:
			text = tr("SET_MASTERY_PROGRESS").format({"item": item, "n": jobs, "t": nt, "level": tr(Mastery.LEVEL_KEYS[after + 1])})
		else:
			text = tr("SET_MASTERY_MAX").format({"item": item, "n": jobs})
		row.add_child(UIKit.wrap_label(text, 20, UIKit.INK_LIGHT, 440))
	box.add_child(row)


## Meisterstück: Teil bestanden / Meisterbrief / Prüfung nicht bestanden.
func _masterpiece_row(box: VBoxContainer, j: JobInstance) -> void:
	if j.parts <= 0:
		return
	var passed := bool(report.get("masterpiece_passed", true))
	var text := ""
	var col := UIKit.GREEN
	if not passed:
		text = tr("MP_FAILED").format({"n": Masterpieces.MIN_STARS})
		col = UIKit.RED
	elif j.part >= j.parts:
		text = tr("MP_DONE").format({"title": tr("MS_" + j.milestone_id.to_upper() + "_TITLE")})
		GameManager.sim_event.emit("mastery_up", {"level": 3})
	else:
		text = tr("MP_PART_DONE").format({"k": j.part, "n": j.parts})
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 14)
	if passed and j.part >= j.parts:
		row.add_child(Seal.make(3, 72.0))
	row.add_child(UIKit.wrap_label(text, 24 if passed else 22, col, 460))
	box.add_child(row)
