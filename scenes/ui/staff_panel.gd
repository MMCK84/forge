extends "res://scenes/ui/overlay.gd"
## Personal (5.5, 6.3): Einstellen, Schwellen des Lehrlings, Lohnübersicht.

const Economy = preload("res://scripts/economy.gd")
const Catalog = preload("res://scripts/catalog.gd")


func _init() -> void:
	title_key = "UI_STAFF"
	panel_width = 1300.0


func build(box: VBoxContainer) -> void:
	var gm := GameManager
	box.add_child(UIKit.label(tr("UI_PURSE") + ": " + Economy.format_lsd(gm.total_pence), 28, UIKit.INK))
	for s in Catalog.STAFF:
		var row := HBoxContainer.new()
		var col := VBoxContainer.new()
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.add_theme_constant_override("separation", 2)
		col.add_child(UIKit.label(tr(s.name_key), 28, UIKit.INK))
		col.add_child(UIKit.wrap_label(tr(s.desc_key), 21, UIKit.INK_LIGHT, 850.0))
		var wage_key := "UI_WAGE_SHARE_JOB" if s.id != "staff_journeyman" else "UI_WAGE_SHARE_OWN"
		col.add_child(UIKit.label(Economy.format_lsd(s.price) + "  ·  " + tr(wage_key).format({"p": int(round(s.wage_share * 100.0))}), 21, UIKit.INK))
		row.add_child(col)
		var btn: Button
		if gm.is_hired(s.id):
			btn = UIKit.button(tr("UI_HIRED"), Callable(), Vector2(240, 60))
			btn.disabled = true
		elif s.min_epoch > gm.current_epoch:
			btn = UIKit.button(tr("UI_FROM_EPOCH").format({"e": s.min_epoch}), Callable(), Vector2(240, 60))
			btn.disabled = true
		else:
			btn = UIKit.button(tr("UI_HIRE"), _hire.bind(s.id), Vector2(240, 60))
			btn.disabled = not gm.can_afford(s.price)
		btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(btn)
		box.add_child(row)
	if gm.is_hired("staff_apprentice"):
		box.add_child(UIKit.hsep())
		box.add_child(UIKit.label(tr("UI_APPRENTICE_THRESHOLDS"), 26, UIKit.LEATHER))
		box.add_child(_slider_row("UI_TO_FORGE_BELOW", gm.apprentice_to_forge_below, 500, 1000, _set_low))
		box.add_child(_slider_row("UI_TO_ANVIL_AT", gm.apprentice_to_anvil_at, 800, 1300, _set_high))
	if gm.is_hired("staff_journeyman"):
		box.add_child(UIKit.hsep())
		var per_min := int(round(gm.journeyman_rate() * 60.0))
		box.add_child(UIKit.label(tr("UI_JOURNEYMAN_RATE").format({"m": Economy.format_lsd(per_min)}), 24, UIKit.INK))
	box.add_child(UIKit.wrap_label(tr("UI_STAFF_NOTE"), 20, UIKit.INK_LIGHT, 1200.0))


func _slider_row(key: String, value: float, lo: float, hi: float, cb: Callable) -> HBoxContainer:
	var row := HBoxContainer.new()
	var l := UIKit.label(tr(key), 24, UIKit.INK)
	l.custom_minimum_size.x = 420
	row.add_child(l)
	var s := HSlider.new()
	s.min_value = lo
	s.max_value = hi
	s.step = 10
	s.value = value
	s.custom_minimum_size = Vector2(520, 48)
	s.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(s)
	var v := UIKit.label("%d °C" % int(value), 24, UIKit.INK)
	v.custom_minimum_size.x = 130
	row.add_child(v)
	s.value_changed.connect(_on_slider.bind(v, cb))
	return row


func _on_slider(x: float, v: Label, cb: Callable) -> void:
	v.text = "%d °C" % int(x)
	cb.call(x)


func _set_low(x: float) -> void:
	GameManager.set_apprentice_thresholds(x, GameManager.apprentice_to_anvil_at)


func _set_high(x: float) -> void:
	GameManager.set_apprentice_thresholds(GameManager.apprentice_to_forge_below, x)


func _hire(id: String) -> void:
	GameManager.hire(id)
	rebuild()
