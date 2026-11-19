extends Control
## HUD (6.2) im Hochformat: obere Leiste (Münzbeutel, Menü, Epoche, Hammer, aktueller Auftrag
## mit Stückzahl, Sternen-Vorschau und Eil-Zeit) und untere Navigationsleiste.

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


var _top: PanelContainer
var _nav: PanelContainer


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	theme = UIKit.theme()
	# Obere Leiste (Hochformat): Geld + Menü, Epoche + Hammer, aktueller Auftrag
	_top = PanelContainer.new()
	_top.add_theme_stylebox_override("panel", UIKit.bar_box())
	_top.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	add_child(_top)
	var rows := VBoxContainer.new()
	rows.add_theme_constant_override("separation", 2)
	_top.add_child(rows)
	var r1 := HBoxContainer.new()
	r1.add_theme_constant_override("separation", 10)
	rows.add_child(r1)
	r1.add_child(UIKit.icon("ui/user/coin_pouch.png" if Assets.user("coin_pouch.png") != null else "ui/icon_coin.png", 46))
	_money = UIKit.label("", 30, UIKit.GOLD)
	r1.add_child(_money)
	_delta_label = UIKit.label("", 20, UIKit.TEXT_LIGHT)
	_delta_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r1.add_child(_delta_label)
	_epoch_btn = UIKit.button(tr("UI_NEXT_EPOCH"), func() -> void: open_epoch.emit(), Vector2(0, 50), 20)
	r1.add_child(_epoch_btn)
	r1.add_child(UIKit.button(tr("UI_MENU"), func() -> void: open_menu.emit(), Vector2(0, 50), 20))
	var r2 := HBoxContainer.new()
	rows.add_child(r2)
	_epoch = UIKit.label("", 18, UIKit.BRASS_LIGHT)
	_epoch.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_epoch.clip_text = true
	_epoch.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	r2.add_child(_epoch)
	_hammer = UIKit.label("", 18, UIKit.TEXT_LIGHT)
	_hammer.custom_minimum_size.x = 150
	_hammer.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_hammer.clip_text = true
	_hammer.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	r2.add_child(_hammer)
	var r3 := HBoxContainer.new()
	r3.add_theme_constant_override("separation", 10)
	rows.add_child(r3)
	_job = UIKit.label("", 20, UIKit.TEXT_LIGHT)
	_job.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_job.clip_text = true
	_job.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	r3.add_child(_job)
	_job_info = UIKit.label("", 20, UIKit.BRASS_LIGHT)
	r3.add_child(_job_info)
	_stars = Control.new()
	_stars.custom_minimum_size = Vector2(92, 30)
	_stars.draw.connect(func() -> void: UIKit.draw_stars(_stars, Vector2(14, 16), _stars_value, 26.0))
	r3.add_child(_stars)
	_hourglass = UIKit.icon("ui/icon_hourglass.png", 30)
	r3.add_child(_hourglass)
	_timer = UIKit.label("", 20, UIKit.TEXT_LIGHT)
	_timer.custom_minimum_size.x = 70
	_timer.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	r3.add_child(_timer)
	# Untere Navigationsleiste (Daumen-erreichbar)
	_nav = PanelContainer.new()
	_nav.add_theme_stylebox_override("panel", UIKit.bar_box())
	_nav.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_nav.grow_vertical = Control.GROW_DIRECTION_BEGIN
	add_child(_nav)
	var nav := HBoxContainer.new()
	nav.add_theme_constant_override("separation", 8)
	_nav.add_child(nav)
	var specs := [["UI_JOB_BOOK_SHORT", open_jobs], ["UI_SHOP", open_shop], ["UI_STAFF", open_staff], ["UI_STATS", open_stats]]
	for sp in specs:
		var sig: Signal = sp[1]
		var b := UIKit.button(tr(str(sp[0])), func() -> void: sig.emit(), Vector2(0, 56), 21)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.clip_text = true
		nav.add_child(b)
		if sp[0] == "UI_STAFF":
			_staff_btn = b
	GameManager.pence_changed.connect(_on_pence)
	# Keine Tastaturfokus-Übernahme: die Leertaste soll immer hämmern, nicht Knöpfe auslösen.
	_unfocus_buttons(self)
	refresh()


## Höhe der oberen Leiste (für das Layout der Werkstatt).
func top_height() -> float:
	return _top.get_combined_minimum_size().y if _top != null else 150.0


## Höhe der unteren Navigationsleiste.
func nav_height() -> float:
	return _nav.get_combined_minimum_size().y if _nav != null else 80.0


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
	_staff_btn.disabled = gm.current_epoch < 2
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
