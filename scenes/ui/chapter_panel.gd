extends "res://scenes/ui/overlay.gd"
## Kapitelübersicht (Wunsch des Auftraggebers, 21.11.): Wie weit ist man in der Epoche? Alle Meilensteine mit
## Kunde, Werkstück und Stand (erledigt / jetzt im Auftragsbuch / nach n Aufträgen), am Ende das Meisterstück
## mit seinen Vorarbeiten. Öffnen: Epochenname in der Statuszeile oder Taste [K].

const Assets = preload("res://scripts/assets.gd")
const Masterpieces = preload("res://scripts/masterpieces.gd")
const JobGenerator = preload("res://scripts/job_generator.gd")


func _init() -> void:
	title_key = "UI_CHAPTER"
	panel_width = 1000.0
	toggle_action = "open_chapter"


func build(box: VBoxContainer) -> void:
	var gm := GameManager
	var e: int = gm.current_epoch
	set_title(tr("UI_CHAPTER_TITLE").format({"n": e, "name": gm.epoch_name()}))
	box.add_child(UIKit.label(gm.EPOCH_YEARS[e - 1], 24, UIKit.LEATHER))
	box.add_child(UIKit.wrap_label(tr("EPOCH_%d_INTRO" % e), 22, UIKit.INK, UIKit.CW))
	var arr: Array = gm.milestones_by_epoch.get(e, [])
	var done := 0
	for ms in arr:
		if gm.completed_milestone_ids.has(ms.id):
			done += 1
	box.add_child(UIKit.label(tr("UI_CHAPTER_PROGRESS").format({"done": done, "total": arr.size(),
		"n": gm.jobs_completed_in_epoch, "jobs": gm.epoch_job_count()}), 22, UIKit.INK_LIGHT))
	box.add_child(UIKit.hsep())
	var open_ms = gm.open_milestone()
	for ms in arr:
		box.add_child(_entry(ms, arr.size(), open_ms))
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_END
	row.add_child(set_default(UIKit.button(tr("UI_CLOSE"), close, Vector2(200, 60))))
	box.add_child(row)


func _entry(ms: MilestoneData, count: int, open_ms) -> Control:
	var gm := GameManager
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	var done: bool = gm.completed_milestone_ids.has(ms.id)
	var ptex := Assets.portrait(ms.customer_id)
	if ptex != null:
		var pr := TextureRect.new()
		pr.texture = ptex
		pr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pr.custom_minimum_size = Vector2(76, 92)
		pr.modulate = Color.WHITE if done or ms == open_ms else Color(1, 1, 1, 0.55)
		row.add_child(pr)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 2)
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(col)
	var mp := Masterpieces.is_masterpiece(ms.id)
	var title := tr("MS_" + ms.id.to_upper() + "_TITLE")
	if mp:
		title = tr("TYPE_MASTERPIECE") + ": " + title
	col.add_child(UIKit.wrap_label(title, 24, UIKit.INK if done or ms == open_ms else UIKit.INK_LIGHT, UIKit.CW - 110.0))
	var state := ""
	var scol := UIKit.INK_LIGHT
	if done:
		state = tr("UI_CHAPTER_DONE")
		scol = UIKit.GREEN
	elif ms == open_ms:
		state = tr("UI_CHAPTER_NOW")
		scol = UIKit.LEATHER
	else:
		var unlock := JobGenerator.milestone_unlock_n(gm.cfg, gm.current_epoch, ms.index, count)
		state = tr("UI_CHAPTER_LATER").format({"n": unlock, "left": maxi(0, unlock - gm.jobs_completed_in_epoch)})
	col.add_child(UIKit.label(tr("TYPE_MILESTONE") + " " + str(ms.index) + " · " + state, 20, scol))
	if mp:
		var parts: Array = Masterpieces.PARTS.get(ms.id, [])
		var names: PackedStringArray = []
		for p in parts:
			names.append("%d × %s" % [int(p[1]), gm.item_name(str(p[0]), int(p[1]) > 1)])
		var progress := int(gm.masterpiece_progress.get(ms.id, 0))
		var txt := tr("UI_CHAPTER_MP_PARTS").format({"parts": ", ".join(names), "main": gm.item_name(ms.item_id),
			"k": progress, "n": parts.size() + 1})
		col.add_child(UIKit.wrap_label(txt, 19, UIKit.INK_LIGHT, UIKit.CW - 110.0))
	return row
