extends Control
## Löschtrog (ab Epoche 4). Klick/Tippen = Abschrecken.

const Assets = preload("res://scripts/assets.gd")

signal trough_clicked()

var active: bool = false
var steam: float = 0.0
var _t: float = 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP


func puff() -> void:
	steam = 1.0


func _process(delta: float) -> void:
	_t += delta
	steam = maxf(0.0, steam - delta * 0.6)
	queue_redraw()


func _gui_input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton
	if mb != null and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
		trough_clicked.emit()
		accept_event()


func _draw() -> void:
	var tt := Assets.tex("tools/trough.png")
	if tt != null:
		draw_texture(tt, Vector2(-10, -10))
		_draw_effects()
		return
	draw_colored_polygon(PackedVector2Array([Vector2(10, 60), Vector2(size.x - 10, 60), Vector2(size.x - 40, size.y - 10), Vector2(40, size.y - 10)]), Color("5a3e28"))
	draw_rect(Rect2(24, 66, size.x - 48, 26), Color(0.25, 0.4, 0.5).lerp(Color(0.6, 0.7, 0.75), 0.2 + 0.1 * sin(_t * 2.0)))
	for k in 3:
		draw_line(Vector2(30, 100 + k * 30), Vector2(size.x - 30, 100 + k * 30), Color("4a3220"), 3.0)
	draw_line(Vector2(10, 60), Vector2(size.x - 10, 60), Color("3b2a1e"), 6.0)
	_draw_effects()


func _draw_effects() -> void:
	if active:
		draw_rect(Rect2(0, 0, size.x, size.y), Color(0.7, 0.9, 1.0, 0.25 + 0.1 * sin(_t * 6.0)), false, 4.0)
	if steam > 0.0:
		for k in 6:
			var p := Vector2(size.x * (0.2 + 0.12 * k), 50 - (1.0 - steam) * 120.0 - k * 6)
			draw_circle(p, 20.0 + (1.0 - steam) * 30.0, Color(0.9, 0.9, 0.95, 0.35 * steam))
	draw_string(Assets.ui_font(), Vector2(20, -16), tr("UI_TROUGH"), HORIZONTAL_ALIGNMENT_LEFT, -1, 32, Color("e9dcc0"))
