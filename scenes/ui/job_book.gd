extends "res://scenes/ui/overlay.gd"
## Auftragsbuch (3.1, 6.3): 3 Angebote, Neu würfeln (60 s), aktiver Auftrag.

const Economy = preload("res://scripts/economy.gd")
const Assets = preload("res://scripts/assets.gd")
var _reroll_btn: Button


func _init() -> void:
	title_key = "UI_JOB_BOOK"
	panel_width = 1400.0


func build(box: VBoxContainer) -> void:
	var gm := GameManager
	if gm.active_job != null:
		var row := HBoxContainer.new()
		box.add_child(row)
		var l := UIKit.label(tr("UI_ACTIVE_JOB") + ": " + gm.job_title(gm.active_job), 26, UIKit.INK)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		row.add_child(l)
		row.add_child(UIKit.button(tr("UI_ABORT_JOB"), _confirm_abort, Vector2(240, 64)))
		box.add_child(UIKit.hsep())
	if gm.free_play:
		box.add_child(UIKit.label(tr("UI_FREE_PLAY_NOTE"), 22, UIKit.INK_LIGHT))
	for i in gm.job_offers.size():
		box.add_child(_offer_card(i, gm.job_offers[i]))
	var foot := HBoxContainer.new()
	box.add_child(foot)
	var info := UIKit.label(tr("UI_EPOCH_PROGRESS").format({"n": gm.jobs_completed_in_epoch, "total": gm.epoch_job_count()}), 22, UIKit.INK_LIGHT)
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	foot.add_child(info)
	_reroll_btn = UIKit.button(tr("UI_REROLL"), _reroll, Vector2(320, 64))
	foot.add_child(_reroll_btn)
	_update_reroll()


func _offer_card(i: int, j: JobInstance) -> Control:
	var gm := GameManager
	var card := PanelContainer.new()
	var bg := UIKit.PARCHMENT_DARK if not j.is_milestone() else Color("e3cf9a")
	card.add_theme_stylebox_override("panel", UIKit.panel_box(bg, UIKit.BRASS if not j.is_milestone() else UIKit.GOLD, 3, 10, 16))
	var row := HBoxContainer.new()
	card.add_child(row)
	var ptex := Assets.portrait(j.customer_id)
	if ptex != null:
		var pr := TextureRect.new()
		pr.texture = ptex
		pr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pr.custom_minimum_size = Vector2(100, 122)
		row.add_child(pr)
	else:
		var portrait := ColorRect.new()
		var cust: CustomerData = gm.customers.get(j.customer_id, null)
		portrait.color = cust.portrait_color if cust != null else UIKit.LEATHER
		portrait.custom_minimum_size = Vector2(90, 110)
		var initial := UIKit.label(tr("CUST_" + j.customer_id.to_upper()).substr(0, 1).to_upper(), 48, UIKit.TEXT_LIGHT, HORIZONTAL_ALIGNMENT_CENTER)
		initial.set_anchors_preset(Control.PRESET_FULL_RECT)
		initial.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		portrait.add_child(initial)
		row.add_child(portrait)
	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 4)
	row.add_child(col)
	var title := UIKit.label(gm.job_title(j), 28, UIKit.INK)
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	col.add_child(title)
	if j.is_milestone():
		col.add_child(UIKit.wrap_label(tr("MS_" + j.milestone_id.to_upper() + "_TEXT"), 21, UIKit.INK_LIGHT, 800.0))
	var tags: PackedStringArray = [tr("TYPE_" + j.type.to_upper())]
	if j.is_milestone() and j.precise:
		tags.append(tr("TYPE_PRECISION"))
	if j.category != "normal":
		tags.append(tr("CAT_" + j.category.to_upper()))
	if j.quantity > 1:
		tags.append(tr("UI_QUANTITY").format({"n": j.quantity}))
	col.add_child(UIKit.label(" · ".join(tags), 22, UIKit.LEATHER))
	var details := tr("UI_OFFER_DETAILS").format({
		"fp": Economy.group_thousands(j.form_points, "." if TranslationServer.get_locale().begins_with("de") else ","),
		"wage": Economy.format_lsd(j.reward_base_pence),
		"time": Economy.format_duration(j.estimate_s) if j.estimate_s >= 0.0 else "–",
	})
	if j.is_rush():
		details += "  ·  " + tr("UI_TIME_LIMIT").format({"time": Economy.format_duration(j.time_limit_s)})
	col.add_child(UIKit.label(details, 22, UIKit.INK))
	var issue := gm.job_requirement_issue(j)
	if issue != "":
		col.add_child(UIKit.label(tr(issue), 22, UIKit.RED))
	var accept := UIKit.button(tr("UI_ACCEPT"), _accept.bind(i), Vector2(220, 64))
	accept.disabled = gm.active_job != null or issue != ""
	accept.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(accept)
	return card


func _process(_delta: float) -> void:
	_update_reroll()


func _update_reroll() -> void:
	if _reroll_btn == null or not is_instance_valid(_reroll_btn):
		return
	var left := GameManager.reroll_seconds_left()
	_reroll_btn.disabled = left > 0
	_reroll_btn.text = tr("UI_REROLL") if left <= 0 else tr("UI_REROLL_WAIT").format({"s": left})


func _reroll() -> void:
	if GameManager.reroll_offers():
		rebuild()


func _accept(i: int) -> void:
	var err := GameManager.accept_offer(i)
	if err == "":
		close()
	else:
		rebuild()


func _confirm_abort() -> void:
	var p = load("res://scenes/ui/info_panel.gd").new()
	p.setup("UI_ABORT_JOB", tr("UI_ABORT_CONFIRM"), [[tr("UI_CANCEL"), Callable()], [tr("UI_ABORT_JOB"), _do_abort]])
	get_parent().add_child(p)


func _do_abort() -> void:
	GameManager.abort_job()
	rebuild()
