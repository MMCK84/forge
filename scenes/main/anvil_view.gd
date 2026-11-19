extends Control
## Amboss auf Holzklotz. Drücken/Tippen = Hammerschlag (hold_started/hold_ended für Halten-Modus).

const Assets = preload("res://scripts/assets.gd")

signal anvil_pressed()
signal anvil_released()

var swing: float = 0.0
var has_piece: bool = false
var big: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP


func rest_point() -> Vector2:
	return Vector2(size.x * 0.5, 170.0)


func play_swing() -> void:
	swing = 1.0


func _process(delta: float) -> void:
	if swing > 0.0:
		swing = maxf(0.0, swing - delta * 7.0)
		queue_redraw()


func _gui_input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton
	if mb != null and mb.button_index == MOUSE_BUTTON_LEFT:
		if mb.pressed:
			anvil_pressed.emit()
		else:
			anvil_released.emit()
		accept_event()


func _draw() -> void:
	var cx := size.x * 0.5
	var anvil_t := Assets.tex("tools/anvil.png")
	var hammer_t := Assets.tex("tools/hand_hammer.png")
	if anvil_t != null and hammer_t != null:
		var user_t := Assets.user("anvil.png")
		if user_t != null:
			# Amboss des Auftraggebers: Bahnmitte über der Ablage, Bahnoberkante bei y ≈ 137 (Werkstück liegt bei 138)
			draw_texture(user_t, Vector2(rest_point().x - 153.0, 134.0))
		else:
			draw_texture(anvil_t, Vector2(-10, -10))
		# Handhammer: liegt beim Schlag auf (swing = 1) und hebt sich wieder (swing → 0)
		var pivot := Vector2(cx + 176, 108)
		draw_set_transform(pivot, 0.55 * (1.0 - swing) + 0.05, Vector2.ONE)
		draw_texture(hammer_t, Vector2(-216, -42))
		draw_set_transform(Vector2.ZERO)
		return
	# Holzklotz
	draw_rect(Rect2(cx - 110, 260, 220, 160), Color("5a3e28"))
	for k in 4:
		draw_line(Vector2(cx - 110, 290 + k * 32), Vector2(cx + 110, 290 + k * 32), Color("4a3220"), 2.0)
	# Amboss: Fuß, Taille, Bahn, Horn
	var iron := Color("3c3f45")
	var hi := Color("6d727b")
	draw_colored_polygon(PackedVector2Array([Vector2(cx - 120, 262), Vector2(cx + 120, 262), Vector2(cx + 80, 225), Vector2(cx - 80, 225)]), iron)
	draw_rect(Rect2(cx - 55, 200, 110, 30), iron)
	draw_colored_polygon(PackedVector2Array([Vector2(cx - 150, 160), Vector2(cx + 150, 160), Vector2(cx + 150, 205), Vector2(cx - 130, 205)]), iron)
	draw_colored_polygon(PackedVector2Array([Vector2(cx + 150, 160), Vector2(cx + 270, 172), Vector2(cx + 150, 195)]), iron)
	draw_rect(Rect2(cx - 150, 156, 300, 8), hi)
	draw_rect(Rect2(cx - 120, 166, 14, 10), Color("1f2024"))
	# Handhammer (Animation beim Schlag)
	var lift := 60.0 + 110.0 * swing
	var hp := Vector2(cx - 40, 150 - lift)
	draw_line(hp + Vector2(10, 10), hp + Vector2(150, -70), Color("8a6a40"), 10.0)
	draw_rect(Rect2(hp.x - 30, hp.y - 18, 60, 36), Color("55585e"))
	draw_rect(Rect2(hp.x - 30, hp.y - 18, 60, 8), Color("8a8f96"))
