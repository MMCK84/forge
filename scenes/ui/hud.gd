extends Control
## HUD (6.2): obere Leiste (Münzbeutel, Hammer, Epoche, Schaltflächen) und
## untere Leiste (Auftragsbuch-Zeile mit Stückzahl, Sternen-Vorschau und Eil-Zeit).

const UIKit = preload("res://scenes/ui/ui_kit.gd")
const Economy = preload("res://scripts/economy.gd")
const Assets = preload("res://scripts/assets.gd")

signal open_jobs()
signal open_shop()
signal open_staff()
signal open_stats()
signal open_menu()
signal open_epoch()

var _money: Label
var _hammer: Label
var _epoch: Label
var _staff_btn: Button
var _epoch_btn: Button
var _job: Label
var _job_info: Label
var _timer: Label
var _stars: Control
var _stars_value: int = 0
var _money_flash: float = 0.0
var _delta_label: Label
var _hourglass: Control


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	theme = UIKit.theme()
	# Obere Leiste
	var top := PanelContainer.new()
	top.add_theme_stylebox_override("panel", UIKit.bar_box())
	top.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	top.custom_minimum_size.y = 88
	add_child(top)
	var tr_row := HBoxContainer.new()
	tr_row.add_theme_constant_override("separation", 18)
	top.add_child(tr_row)
	tr_row.add_child(UIKit.icon("ui/user/coin_pouch.png" if Assets.user("coin_pouch.png") != null else "ui/icon_coin.png", 64))
	_money = UIKit.label("", 34, UIKit.GOLD)
	_money.custom_minimum_size.x = 230
	tr_row.add_child(_money)
	_delta_label = UIKit.label("", 24, UIKit.TEXT_LIGHT)
	_delta_label.custom_minimum_size.x = 110
	tr_row.add_child(_delta_label)
	_hammer = UIKit.label("", 22, UIKit.TEXT_LIGHT)
	_hammer.custom_minimum_size.x = 120
	_hammer.clip_text = true
	_hammer.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	tr_row.add_child(_hammer)
	_epoch = UIKit.label("", 22, UIKit.BRASS_LIGHT)
	_epoch.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_epoch.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_epoch.clip_text = true
	_epoch.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	_epoch.custom_minimum_size.x = 120
	tr_row.add_child(_epoch)
	_epoch_btn = UIKit.button(tr("UI_NEXT_EPOCH"), func() -> void: open_epoch.emit(), Vector2(0, 64), 24)
	tr_row.add_child(_epoch_btn)
	tr_row.add_child(UIKit.button(tr("UI_JOB_BOOK") + " [J]", func() -> void: open_jobs.emit(), Vector2(0, 64), 24))
	tr_row.add_child(UIKit.button(tr("UI_SHOP") + " [S]", func() -> void: open_shop.emit(), Vector2(0, 64), 24))
	_staff_btn = UIKit.button(tr("UI_STAFF") + " [P]", func() -> void: open_staff.emit(), Vector2(0, 64), 24)
	tr_row.add_child(_staff_btn)
	tr_row.add_child(UIKit.button(tr("UI_STATS"), func() -> void: open_stats.emit(), Vector2(0, 64), 24))
	tr_row.add_child(UIKit.button(tr("UI_MENU"), func() -> void: open_menu.emit(), Vector2(0, 64), 24))
	# Untere Leiste
	var bottom := PanelContainer.new()
	bottom.add_theme_stylebox_override("panel", UIKit.bar_box())
	bottom.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	bottom.custom_minimum_size.y = 76
	bottom.grow_vertical = Control.GROW_DIRECTION_BEGIN
	add_child(bottom)
	var br := HBoxContainer.new()
	br.add_theme_constant_override("separation", 24)
	bottom.add_child(br)
	var book := UIKit.button(tr("UI_JOB_BOOK_SHORT"), func() -> void: open_jobs.emit(), Vector2(0, 56), 22)
	br.add_child(book)
	_job = UIKit.label("", 26, UIKit.TEXT_LIGHT)
	_job.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_job.clip_text = true
	br.add_child(_job)
	_job_info = UIKit.label("", 24, UIKit.BRASS_LIGHT)
	br.add_child(_job_info)
	_stars = Control.new()
	_stars.custom_minimum_size = Vector2(120, 40)
	_stars.draw.connect(func() -> void: UIKit.draw_stars(_stars, Vector2(18, 22), _stars_value, 34.0))
	br.add_child(_stars)
	_hourglass = UIKit.icon("ui/icon_hourglass.png", 44)
	br.add_child(_hourglass)
	_timer = UIKit.label("", 26, UIKit.TEXT_LIGHT)
	_timer.custom_minimum_size.x = 170
	br.add_child(_timer)
	GameManager.pence_changed.connect(_on_pence)
	# Keine Tastaturfokus-Übernahme: die Leertaste soll immer hämmern, nicht Knöpfe auslösen.
	_unfocus_buttons(self)
	refresh()


func _unfocus_buttons(n: Node) -> void:
	for c in n.get_children():
		var b := c as Button
		if b != null:
			b.focus_mode = Control.FOCUS_NONE
		_unfocus_buttons(c)


func _on_pence(_total: int, delta: int) -> void:
	_money.text = Economy.format_lsd(GameManager.total_pence)
	if delta != 0:
		_delta_label.text = ("+" if delta > 0 else "") + Economy.format_lsd(delta)
		_delta_label.add_theme_color_override("font_color", UIKit.GOLD if delta > 0 else Color("e07a5f"))
		_money_flash = 2.0


func refresh() -> void:
	var gm := GameManager
	_money.text = Economy.format_lsd(gm.total_pence)
	var h := gm.current_hammer()
	var lvl: int = gm.hammer_level(h.id)
	_hammer.text = tr(h.name_key) + (" +%d" % lvl if lvl > 0 else "")
	_epoch.text = "%s (%s)" % [gm.epoch_name(), gm.EPOCH_YEARS[gm.current_epoch - 1]]
	_epoch.tooltip_text = tr(gm.reputation_title_key())
	_staff_btn.visible = gm.current_epoch >= 2
	_epoch_btn.visible = gm.can_advance_epoch()


func _process(delta: float) -> void:
	if _money_flash > 0.0:
		_money_flash -= delta
		_delta_label.modulate.a = clampf(_money_flash, 0.0, 1.0)
	var gm := GameManager
	var j: JobInstance = gm.active_job
	if j == null:
		_job.text = tr("UI_NO_JOB")
		_job_info.text = ""
		_timer.text = ""
		_stars.visible = false
		_hourglass.visible = false
		return
	_job.text = gm.job_title(j)
	_job_info.text = "%d/%d" % [j.pieces_done(), j.quantity]
	_stars.visible = true
	var ev: Dictionary = _preview(j)
	if int(ev["stars"]) != _stars_value:
		_stars_value = int(ev["stars"])
		_stars.queue_redraw()
	_hourglass.visible = j.is_rush()
	if j.is_rush():
		var left := j.time_limit_s - j.elapsed_s
		_timer.text = Economy.format_duration(left) if left > 0 else tr("UI_LATE")
		_timer.add_theme_color_override("font_color", UIKit.TEXT_LIGHT if left > 15 else Color("e07a5f"))
	else:
		_timer.text = Economy.format_duration(j.elapsed_s)
		_timer.add_theme_color_override("font_color", UIKit.TEXT_LIGHT)


## Sternevorschau aus dem bisherigen Fortschritt.
func _preview(j: JobInstance) -> Dictionary:
	var total := 0.0
	var inw := 0.0
	var dmg := 0.0
	var pen := 0.0
	for p in j.pieces:
		total += p.progress
		inw += p.points_in_window
		dmg += p.damage
		pen += p.quench_penalty
	var n := float(maxi(1, j.pieces.size()))
	var quote := inw / total if total > 0.0 else 1.0
	var q := Economy.quality_value(GameManager.cfg, quote, dmg / n, pen / n)
	return {"stars": Economy.star_count(GameManager.cfg, q)}
