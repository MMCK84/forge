extends "res://scenes/ui/overlay.gd"
## Laden (5.1–5.4, 6.3): Hämmer, Verbesserungsstufen, Essen, Maschinen.

const Economy = preload("res://scripts/economy.gd")
const Catalog = preload("res://scripts/catalog.gd")


func _init() -> void:
	title_key = "UI_SHOP"
	panel_width = 1400.0


func build(box: VBoxContainer) -> void:
	var gm := GameManager
	box.add_child(UIKit.label(tr("UI_PURSE") + ": " + Economy.format_lsd(gm.total_pence), 28, UIKit.INK))
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 8)
	box.add_child(scroll(list, 720))
	# Hämmer
	list.add_child(_section("UI_SECTION_HAMMERS"))
	for h in Catalog.HAMMERS:
		var owned: bool = gm.owned_hammer_ids.has(h.id)
		var info := tr("UI_HAMMER_INFO").format({"p": int(h.p_base)})
		var row := _row(tr(h.name_key), info, h.price, h.min_epoch)
		var btn: Button
		if owned:
			if gm.equipped_hammer_id == h.id:
				btn = _status_btn(tr("UI_EQUIPPED"))
			else:
				btn = UIKit.button(tr("UI_EQUIP"), _do.bind(func() -> void: gm.equip_hammer(h.id)), Vector2(240, 60))
		else:
			btn = _buy_btn(h.price, h.min_epoch, func() -> void: gm.buy_hammer(h.id))
		row.add_child(btn)
		list.add_child(row)
	# Verbesserung des aktuellen Hammers
	list.add_child(_section("UI_SECTION_UPGRADE"))
	var ch: HammerData = gm.current_hammer()
	var lvl: int = gm.hammer_level(ch.id)
	var cost: int = gm.next_upgrade_cost(ch.id)
	var up_info := tr("UI_UPGRADE_INFO").format({
		"name": tr(ch.name_key), "lvl": lvl, "max": gm.cfg.upgrade_max_level,
		"p": "%.1f" % gm.current_hammer_power(),
	})
	var up_row := _row(tr("UI_UPGRADE"), up_info, maxi(cost, 0), 1)
	if cost < 0:
		up_row.add_child(_status_btn(tr("UI_MAXED")))
	else:
		up_row.add_child(_buy_btn(cost, 1, func() -> void: gm.upgrade_hammer(ch.id)))
	list.add_child(up_row)
	# Essen
	list.add_child(_section("UI_SECTION_FORGES"))
	for f in Catalog.FORGES:
		var f_owned: bool = gm.owned_forge_ids.has(f.id)
		var f_info := tr("UI_FORGE_INFO").format({"k": int(f.k_heat), "t": int(f.t_max), "s": f.slots})
		var f_row := _row(tr(f.name_key), f_info, f.price, f.min_epoch)
		if f_owned:
			if gm.equipped_forge_id == f.id:
				f_row.add_child(_status_btn(tr("UI_EQUIPPED")))
			else:
				f_row.add_child(UIKit.button(tr("UI_EQUIP"), _do.bind(func() -> void: gm.equip_forge(f.id)), Vector2(240, 60)))
		else:
			f_row.add_child(_buy_btn(f.price, f.min_epoch, func() -> void: gm.buy_forge(f.id)))
		list.add_child(f_row)
	if gm.current_epoch >= 3:
		list.add_child(UIKit.wrap_label(tr("UI_FORGE_BURN_NOTE"), 20, UIKit.RED, 1200.0))
	# Maschinen
	list.add_child(_section("UI_SECTION_MACHINES"))
	for m in Catalog.MACHINES:
		var m_owned: bool = gm.owned_machine_ids.has(m.id)
		var m_info := tr("UI_MACHINE_INFO").format({"p": int(m.p_base), "h": m.hits_per_s})
		if m.cost_per_minute > 0:
			m_info += " · " + tr("UI_MACHINE_COST").format({"c": Economy.format_lsd(m.cost_per_minute)})
		if m.water_powered:
			m_info += " · " + tr("UI_MACHINE_WATER")
		var m_row := _row(tr(m.name_key), m_info, m.price, m.min_epoch)
		if m_owned:
			if gm.active_machine_id == m.id:
				m_row.add_child(_status_btn(tr("UI_ACTIVE")))
			else:
				m_row.add_child(UIKit.button(tr("UI_ACTIVATE"), _do.bind(func() -> void: gm.activate_machine(m.id)), Vector2(240, 60)))
		else:
			m_row.add_child(_buy_btn(m.price, m.min_epoch, func() -> void: gm.buy_machine(m.id)))
		list.add_child(m_row)
	list.add_child(UIKit.wrap_label(tr("UI_MACHINE_NOTE"), 20, UIKit.INK_LIGHT, 1200.0))


func _section(key: String) -> Control:
	var l := UIKit.label(tr(key), 30, UIKit.LEATHER)
	return l


func _row(title: String, info: String, price: int, min_epoch: int) -> HBoxContainer:
	var row := HBoxContainer.new()
	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 2)
	var locked := min_epoch > GameManager.current_epoch
	col.add_child(UIKit.label(title, 26, UIKit.INK if not locked else UIKit.INK_LIGHT))
	var sub := info
	if price > 0:
		sub += "  ·  " + Economy.format_lsd(price)
	col.add_child(UIKit.label(sub, 21, UIKit.INK_LIGHT))
	row.add_child(col)
	return row


func _status_btn(text: String) -> Button:
	var b := UIKit.button(text, Callable(), Vector2(240, 60))
	b.disabled = true
	return b


func _buy_btn(price: int, min_epoch: int, action: Callable) -> Button:
	var gm := GameManager
	if min_epoch > gm.current_epoch:
		var b := UIKit.button(tr("UI_FROM_EPOCH").format({"e": min_epoch}), Callable(), Vector2(240, 60))
		b.disabled = true
		return b
	var buy := UIKit.button(tr("UI_BUY"), _do.bind(action), Vector2(240, 60))
	buy.disabled = not gm.can_afford(price)
	return buy


func _do(action: Callable) -> void:
	action.call()
	rebuild()
