extends "res://scenes/ui/overlay.gd"
## Epochenwechsel (4.3, 6.3): Zwischensequenz (Standbild + Text) mit neuem Standort,
## Meistergebühr bezahlen. mode: "offer" (vor dem Wechsel), "arrived" (nach dem Wechsel), "finale".

const Economy = preload("res://scripts/economy.gd")
const Background = preload("res://scenes/main/workshop_background.gd")

var mode: String = "offer"
var epoch: int = 2


func _init() -> void:
	title_key = "UI_EPOCH_CHANGE"
	panel_width = 1200.0


func build(box: VBoxContainer) -> void:
	var gm := GameManager
	var show_epoch := epoch
	var pic_holder := Control.new()
	pic_holder.custom_minimum_size = Vector2(1120, 360)
	pic_holder.clip_contents = true
	var bg := Background.new()
	pic_holder.add_child(bg)
	bg.set_anchors_preset(Control.PRESET_TOP_LEFT)
	bg.size = Vector2(1920, 1080)
	bg.scale = Vector2(0.6, 0.6)
	bg.position = Vector2(-20, -40)
	bg.stage_offset = Vector2.ZERO
	bg.set_epoch(show_epoch, 1)
	box.add_child(pic_holder)
	match mode:
		"offer":
			set_title(tr("UI_EPOCH_DONE").format({"e": gm.current_epoch}))
			box.add_child(UIKit.label(tr("EPOCH_%d_NAME" % show_epoch) + "  (" + gm.EPOCH_YEARS[show_epoch - 1] + ")", 30, UIKit.LEATHER))
			box.add_child(UIKit.wrap_label(tr("EPOCH_%d_TEASER" % show_epoch), 24, UIKit.INK, 1100.0))
			var fee := gm.next_epoch_fee()
			box.add_child(UIKit.label(tr("FEE_%d" % show_epoch) + ": " + Economy.format_lsd(fee), 26, UIKit.INK))
			var row := HBoxContainer.new()
			row.alignment = BoxContainer.ALIGNMENT_END
			if not gm.can_afford(fee):
				var miss := UIKit.label(tr("UI_MISSING").format({"m": Economy.format_lsd(fee - gm.total_pence)}), 22, UIKit.RED)
				miss.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				row.add_child(miss)
			row.add_child(UIKit.button(tr("UI_LATER"), close, Vector2(220, 64)))
			var pay := UIKit.button(tr("UI_PAY_AND_MOVE"), _pay, Vector2(360, 64))
			pay.disabled = not gm.can_afford(fee)
			row.add_child(pay)
			box.add_child(row)
		"arrived":
			set_title(tr("EPOCH_%d_NAME" % show_epoch))
			box.add_child(UIKit.label(gm.EPOCH_YEARS[show_epoch - 1], 26, UIKit.LEATHER))
			box.add_child(UIKit.wrap_label(tr("EPOCH_%d_INTRO" % show_epoch), 24, UIKit.INK, 1100.0))
			var row2 := HBoxContainer.new()
			row2.alignment = BoxContainer.ALIGNMENT_END
			row2.add_child(UIKit.button(tr("UI_CONTINUE"), close, Vector2(240, 64)))
			box.add_child(row2)
		"finale":
			set_title(tr("UI_FINALE_TITLE"))
			box.add_child(UIKit.wrap_label(tr("UI_FINALE_TEXT"), 24, UIKit.INK, 1100.0))
			var row3 := HBoxContainer.new()
			row3.alignment = BoxContainer.ALIGNMENT_END
			row3.add_child(UIKit.button(tr("UI_CONTINUE"), close, Vector2(240, 64)))
			box.add_child(row3)


func _pay() -> void:
	if GameManager.advance_epoch():
		mode = "arrived"
		epoch = GameManager.current_epoch
		rebuild()
