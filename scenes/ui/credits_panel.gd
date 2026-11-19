extends "res://scenes/ui/overlay.gd"
## Mitwirkende.


func _init() -> void:
	title_key = "UI_CREDITS"
	panel_width = 1000.0


func build(box: VBoxContainer) -> void:
	box.add_child(UIKit.wrap_label(tr("CREDITS_TEXT"), 24, UIKit.INK, 920.0))
