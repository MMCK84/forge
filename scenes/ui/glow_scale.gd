extends Control
## Glutfarben-Skala (6.2): Farbband mit markiertem Zielfenster und Zeiger.
## Optional Zahlenwert in °C (Barrierefreiheit) und Messing-Pyrometer (ab Freischaltung).

const HeatModel = preload("res://scripts/heat_model.gd")
const Assets = preload("res://scripts/assets.gd")

var temp: float = -1.0
var window := Vector2(700, 1100)
var weld_window := Vector2(-1, -1)
var quench_window := Vector2(-1, -1)
var show_celsius: bool = false
var pyrometer: bool = false
var label_text: String = ""
const T_MAX := 1450.0


func _x(t: float, bar: Rect2) -> float:
	return bar.position.x + bar.size.x * clampf(t / T_MAX, 0.0, 1.0)


func _draw() -> void:
	var bar_w := size.x - (220.0 if pyrometer else 0.0)
	var bar := Rect2(0, 26, bar_w, 34)
	var steps := 96
	for i in steps:
		var t0 := T_MAX * float(i) / steps
		var x0 := _x(t0, bar)
		var x1 := _x(T_MAX * float(i + 1) / steps, bar)
		draw_rect(Rect2(x0, bar.position.y, x1 - x0 + 1.0, bar.size.y), HeatModel.glow_color(t0 + T_MAX / steps * 0.5))
	draw_rect(bar, Color("b08d57"), false, 3.0)
	# Gefahrenzone (Verbrennen)
	draw_rect(Rect2(_x(1300, bar), bar.position.y, bar.end.x - _x(1300, bar), bar.size.y), Color(0.6, 0, 0, 0.25))
	_bracket(window, bar, Color("f3e7cf"), 0)
	if weld_window.x >= 0.0:
		_bracket(weld_window, bar, Color(1, 1, 0.6), 1)
	if quench_window.x >= 0.0:
		_bracket(quench_window, bar, Color(0.6, 0.85, 1.0), 1)
	for t in [400, 700, 1100, 1300]:
		var x := _x(t, bar)
		draw_line(Vector2(x, bar.end.y), Vector2(x, bar.end.y + 8), Color("e9dcc0"), 2.0)
	if temp >= 0.0:
		var px := _x(temp, bar)
		draw_colored_polygon(PackedVector2Array([Vector2(px - 12, 0), Vector2(px + 12, 0), Vector2(px, 22)]), Color.WHITE)
		draw_line(Vector2(px, 20), Vector2(px, bar.end.y + 4), Color(0, 0, 0, 0.8), 3.0)
		var txt := label_text
		if show_celsius:
			txt += "  %d °C" % int(round(temp))
		draw_string(Assets.ui_font(), Vector2(0, bar.end.y + 34), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("f3e7cf"))
	if pyrometer:
		_draw_pyrometer(Vector2(size.x - 100, 52), 70.0)


func _bracket(w: Vector2, bar: Rect2, col: Color, row: int) -> void:
	var x0 := _x(w.x, bar)
	var x1 := _x(w.y, bar)
	var y := bar.position.y - 6 - row * 10
	draw_line(Vector2(x0, y), Vector2(x1, y), col, 4.0)
	draw_line(Vector2(x0, y), Vector2(x0, bar.end.y), col, 3.0)
	draw_line(Vector2(x1, y), Vector2(x1, bar.end.y), col, 3.0)


func _draw_pyrometer(c: Vector2, r: float) -> void:
	draw_circle(c, r + 8, Color("8a6a3a"))
	draw_circle(c, r, Color("e9dcc0"))
	for k in 8:
		var a := PI * 0.75 + k * (PI * 1.5 / 7.0)
		draw_line(c + Vector2(cos(a), sin(a)) * (r - 12), c + Vector2(cos(a), sin(a)) * r, Color("3a2a1a"), 2.0)
	if temp >= 0.0:
		var ang := PI * 0.75 + clampf(temp / T_MAX, 0.0, 1.0) * PI * 1.5
		draw_line(c, c + Vector2(cos(ang), sin(ang)) * (r - 8), Color("8c2f1f"), 4.0)
		draw_string(Assets.ui_font(), c + Vector2(-38, r * 0.55), "%d °" % int(round(temp)), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("3a2a1a"))
	draw_circle(c, 6, Color("3a2a1a"))
