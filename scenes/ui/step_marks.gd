extends Control
## Abschnitte der Arbeitsgänge über dem Fortschrittsbalken (Trennstriche und Namen).

const Assets = preload("res://scripts/assets.gd")

var steps: Array = []
var current: int = -1


func _draw() -> void:
	if steps.size() < 2:
		return
	var font := Assets.ui_font()
	var cum := 0.0
	for k in steps.size():
		var share := float(steps[k].get("share", 0.0))
		var x0 := size.x * cum
		var x1 := size.x * (cum + share)
		if k > 0:
			draw_line(Vector2(x0, -4), Vector2(x0, size.y + 4), Color("f3e7cf"), 2.0)
		var step_name := tr("STEP_" + str(steps[k].get("id", "")).to_upper())
		var col := Color("ffe3a0") if k == current else Color(0.95, 0.9, 0.8, 0.55)
		draw_string(font, Vector2(x0 + 6, size.y - 9), step_name, HORIZONTAL_ALIGNMENT_LEFT, x1 - x0 - 8, 18, col)
		cum += share
