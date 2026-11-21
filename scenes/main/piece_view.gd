extends Node2D
## Darstellung eines Werkstücks: ein graustufiges Platzhalter-Sprite, das der
## Glow-Shader nach Temperatur einfärbt (6.5). Overlay zeigt Riss-Symbol und Hinweise.

const HeatModel = preload("res://scripts/heat_model.gd")
const ItemShapes = preload("res://scripts/item_shapes.gd")
const GLOW_SHADER = preload("res://shaders/glow.gdshader")
const Assets = preload("res://scripts/assets.gd")

static var _gradient_tex: GradientTexture1D = null

var shape: String = "bar"
## Gegenstands-ID für das gerenderte Sprite (assets/sprites/items/<id>.png)
var item_id: String = ""
var size_px: float = 150.0
var temp: float = 20.0
var progress_ratio: float = 0.0
var damage: float = 0.0
var damage_warning: float = 0.5
var selected: bool = false
## "", "weld", "quench"
var badge: String = ""
var target_pos: Vector2 = Vector2.ZERO
## Ab diesem Fortschritt (Ende des ersten Arbeitsgangs) zeigt das Stück seine Rohform (falls es ein Bild gibt)
var rough_from: float = 1.0
## Aktueller Arbeitsgang (für den Stufensprung)
var step: int = -1
var _jump: float = 0.0
var _overlay: Node2D
var _halo: Node2D


func _ready() -> void:
	if _gradient_tex == null:
		_gradient_tex = GradientTexture1D.new()
		_gradient_tex.gradient = HeatModel.make_glow_gradient()
		_gradient_tex.width = 256
	var mat := ShaderMaterial.new()
	mat.shader = GLOW_SHADER
	mat.set_shader_parameter("glow_gradient", _gradient_tex)
	mat.set_shader_parameter("t_scale", HeatModel.GLOW_T_MAX)
	material = mat
	_halo = Node2D.new()
	_halo.show_behind_parent = true
	_halo.draw.connect(_draw_halo)
	add_child(_halo)
	_overlay = Node2D.new()
	_overlay.z_index = 1
	_overlay.draw.connect(_draw_overlay)
	add_child(_overlay)


func update_state(t: float, prog: float, dmg: float, sel: bool, b: String) -> void:
	temp = t
	progress_ratio = clampf(prog, 0.0, 1.0)
	damage = dmg
	selected = sel
	badge = b
	var strength := HeatModel.glow_strength(temp)
	var mat := material as ShaderMaterial
	mat.set_shader_parameter("temperature", temp)
	mat.set_shader_parameter("glow_strength", strength)
	mat.set_shader_parameter("flicker", strength)
	queue_redraw()
	_overlay.queue_redraw()
	_halo.queue_redraw()


func _process(delta: float) -> void:
	position = position.lerp(target_pos, 1.0 - exp(-delta * 14.0))
	if _jump > 0.0:
		_jump = maxf(0.0, _jump - delta)
		var s := 1.0 + 0.3 * sin(_jump / JUMP_TIME * PI)
		scale = Vector2(s, s)
		_overlay.queue_redraw()
	elif scale != Vector2.ONE:
		scale = Vector2.ONE


const JUMP_TIME := 0.45


## Neuer Arbeitsgang erreicht: kurzer Sprung mit hellem Aufblitzen.
func set_step(k: int) -> void:
	if step >= 0 and k > step:
		_jump = JUMP_TIME
	step = k


func _draw() -> void:
	# Rohling (Stab) wandelt sich mit dem Fortschritt in die Zielform.
	var a := progress_ratio
	var item_t := Assets.item_tex(item_id)
	var blank_t := Assets.item_tex("blank")
	if item_t != null and blank_t != null:
		var s := size_px * 1.3
		var r := Rect2(Vector2(-s, -s) * 0.5, Vector2(s, s))
		var rough_t := Assets.item_tex(item_id + "_rough") if rough_from < 0.999 else null
		if rough_t != null:
			# Rohling → (erster Arbeitsgang fertig) Rohform → fertiges Werkstück
			if a < rough_from - 0.0001:
				var t0 := a / maxf(rough_from, 0.001)
				draw_texture_rect(blank_t, r, false, Color(1, 1, 1, 1.0 - t0 * 0.85))
				draw_texture_rect(rough_t, r, false, Color(1, 1, 1, clampf(t0 * 1.4, 0.0, 1.0)))
			else:
				var t1 := (a - rough_from) / maxf(1.0 - rough_from, 0.001)
				draw_texture_rect(rough_t, r, false, Color(1, 1, 1, 1.0 - t1 * 0.85))
				if t1 > 0.001:
					draw_texture_rect(item_t, r, false, Color(1, 1, 1, clampf(t1 * 1.4, 0.0, 1.0)))
			return
		if a < 0.999:
			draw_texture_rect(blank_t, r, false, Color(1, 1, 1, 1.0 - a * 0.85))
		if a > 0.001:
			draw_texture_rect(item_t, r, false, Color(1, 1, 1, clampf(a * 1.4, 0.0, 1.0)))
		return
	if a < 0.999:
		ItemShapes.draw(self, "bar", size_px * 0.8, 1.0 - a * 0.85)
	if a > 0.001:
		ItemShapes.draw(self, shape, size_px, clampf(a * 1.4, 0.0, 1.0))


func _draw_halo() -> void:
	var s := HeatModel.glow_strength(temp)
	if s <= 0.01:
		return
	var c := HeatModel.glow_color(temp)
	for k in 4:
		var r := size_px * (0.35 + 0.15 * k)
		_halo.draw_circle(Vector2.ZERO, r, Color(c.r, c.g, c.b, 0.07 * s))


func _draw_overlay() -> void:
	if _jump > 0.0:
		var a := _jump / JUMP_TIME
		_overlay.draw_arc(Vector2.ZERO, size_px * (0.45 + 0.5 * (1.0 - a)), 0, TAU, 48, Color(1.0, 0.9, 0.55, a), 6.0, true)
	if selected:
		_overlay.draw_arc(Vector2.ZERO, size_px * 0.62, 0, TAU, 40, Color(1, 0.85, 0.4, 0.8), 3.0, true)
	if damage > 0.0:
		var p := Vector2(size_px * 0.42, -size_px * 0.32)
		var col := Color(0.95, 0.85, 0.7) if damage < damage_warning else Color(1, 0.3, 0.2)
		_overlay.draw_circle(p, 18.0, Color(0, 0, 0, 0.55))
		_overlay.draw_polyline(PackedVector2Array([p + Vector2(-2, -12), p + Vector2(4, -3), p + Vector2(-3, 3), p + Vector2(3, 12)]), col, 3.0, true)
		if damage >= damage_warning:
			_overlay.draw_string(Assets.ui_font(), p + Vector2(16, 8), "!", HORIZONTAL_ALIGNMENT_LEFT, -1, 30, col)
	if badge == "weld":
		_overlay.draw_string(Assets.ui_font(), Vector2(-size_px * 0.5, -size_px * 0.35), tr("BADGE_WELD"), HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(1, 0.95, 0.7))
	elif badge == "quench":
		_overlay.draw_string(Assets.ui_font(), Vector2(-size_px * 0.5, -size_px * 0.35), tr("BADGE_QUENCH"), HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(0.75, 0.9, 1.0))
