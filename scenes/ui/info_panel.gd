extends "res://scenes/ui/overlay.gd"
## Einfaches Hinweis-/Bestätigungsfenster.

var body_text: String = ""
var buttons: Array = []  # [[text, Callable], ...]; leer = nur OK


func setup(title: String, body: String, button_list: Array = [], width: float = 900.0) -> void:
	title_key = title
	body_text = body
	buttons = button_list
	panel_width = width


func build(box: VBoxContainer) -> void:
	box.add_child(UIKit.wrap_label(body_text, 24, UIKit.INK, minf(panel_width - 80.0, UIKit.CW)))
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_END
	box.add_child(row)
	if buttons.is_empty():
		row.add_child(UIKit.button(tr("UI_OK"), close, Vector2(180, 64)))
	else:
		for b in buttons:
			var cb: Callable = b[1]
			row.add_child(UIKit.button(str(b[0]), _run.bind(cb), Vector2(180, 64)))


func _run(cb: Callable) -> void:
	close()
	if cb.is_valid():
		cb.call()
