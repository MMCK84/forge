extends "res://scenes/ui/overlay.gd"
## Musterbuch: alle Werkstücke des Spiels nach Epochen. Geschmiedete Stücke mit Bild, Anzahl,
## bester Bewertung und Meisterschafts-Siegel; noch nie geschmiedete als Schattenriss.

const Assets = preload("res://scripts/assets.gd")
const Mastery = preload("res://scripts/mastery.gd")
const ItemShapes = preload("res://scripts/item_shapes.gd")
const Seal = preload("res://scenes/ui/mastery_seal.gd")

const COLS := 4
const CELL := Vector2(150, 196)


func _init() -> void:
	title_key = "UI_PATTERN_BOOK"
	panel_width = 696.0


func build(box: VBoxContainer) -> void:
	var gm := GameManager
	var by_epoch := {}
	for id in gm.items:
		var it: ItemData = gm.items[id]
		if not by_epoch.has(it.epoch):
			by_epoch[it.epoch] = []
		by_epoch[it.epoch].append(it)
	var made := 0
	var counts := [0, 0, 0, 0]
	for id in gm.items:
		if gm.mastery_jobs(id) > 0:
			made += 1
		counts[gm.mastery_level(id)] += 1
	box.add_child(UIKit.wrap_label(tr("UI_PATTERN_SUMMARY").format({
		"made": made, "all": gm.items.size(), "b": counts[1], "s": counts[2], "g": counts[3]}), 21, UIKit.INK, 620))
	var ladder := PackedStringArray()
	for k in range(1, 4):
		ladder.append(tr(Mastery.LEVEL_KEYS[k]) + " " + str(int(gm.cfg.mastery_jobs[k - 1])) + "× (+%d %%)" % int(round(gm.cfg.mastery_bonus_per_level * k * 100.0)))
	box.add_child(UIKit.wrap_label(tr("UI_PATTERN_RULES").format({"ladder": " · ".join(ladder)}), 18, UIKit.INK_LIGHT, 620))
	var epochs := by_epoch.keys()
	epochs.sort()
	for e in epochs:
		var reached: bool = e <= gm.current_epoch or gm.free_play
		box.add_child(UIKit.hsep())
		var head := UIKit.label("%d · %s" % [e, gm.epoch_name(e) if reached else "?"], 24, UIKit.LEATHER)
		var hf := UIKit.heading_font()
		if hf != null:
			head.add_theme_font_override("font", hf)
		box.add_child(head)
		var grid := GridContainer.new()
		grid.columns = COLS
		grid.add_theme_constant_override("h_separation", 8)
		grid.add_theme_constant_override("v_separation", 8)
		var list: Array = by_epoch[e]
		list.sort_custom(func(a, b): return a.id < b.id)
		for it in list:
			grid.add_child(_cell(it, reached))
		box.add_child(grid)


func _cell(it: ItemData, reached: bool) -> Control:
	var gm := GameManager
	var jobs := gm.mastery_jobs(it.id)
	var lv := gm.mastery_level(it.id)
	var best := int(gm.mastery.get(it.id, {}).get("best", 0))
	var known := jobs > 0
	var cell := Control.new()
	cell.custom_minimum_size = CELL
	var tex := Assets.item_tex(it.id)
	var shape := it.shape
	cell.draw.connect(func() -> void:
		cell.draw_rect(Rect2(Vector2.ZERO, CELL), Color(0.42, 0.29, 0.18, 0.10))
		var r := Rect2(15, 8, 120, 120)
		var mod := Color.WHITE if known else Color(0.12, 0.08, 0.05, 0.55 if reached else 0.25)
		if tex != null:
			cell.draw_texture_rect(tex, r, false, mod)
		else:
			cell.draw_set_transform(r.get_center())
			ItemShapes.draw(cell, shape, 100.0, mod.a)
			cell.draw_set_transform(Vector2.ZERO)
		if lv > 0:
			Seal.draw_seal(cell, Vector2(CELL.x - 26, 26), 22.0, lv)
		if known and best > 0:
			UIKit.draw_stars(cell, Vector2(CELL.x * 0.5 - 19.8, 138), best, 18.0))
	var name_l := UIKit.label(gm.item_name(it.id) if (known or reached) else "?", 16, UIKit.INK if known else UIKit.INK_LIGHT, HORIZONTAL_ALIGNMENT_CENTER)
	name_l.position = Vector2(0, 150)
	name_l.size = Vector2(CELL.x, 22)
	name_l.clip_text = true
	cell.add_child(name_l)
	var info := ""
	if known:
		var nt := Mastery.next_threshold(gm.cfg, jobs)
		info = "×%d" % jobs + (("  →  %d" % nt) if nt > 0 else "")
	var info_l := UIKit.label(info, 15, UIKit.INK_LIGHT, HORIZONTAL_ALIGNMENT_CENTER)
	info_l.position = Vector2(0, 172)
	info_l.size = Vector2(CELL.x, 20)
	cell.add_child(info_l)
	var tip := gm.item_name(it.id) if (known or reached) else "?"
	if known:
		tip += "\n" + tr("UI_PATTERN_TIP").format({"n": jobs, "level": tr(Mastery.LEVEL_KEYS[lv]) if lv > 0 else "–"})
	cell.tooltip_text = tip
	cell.mouse_filter = Control.MOUSE_FILTER_PASS
	return cell
