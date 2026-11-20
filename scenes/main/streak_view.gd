extends Control
## Anzeige der Schlagserie neben dem Amboss (Bühnen-Koordinaten): „Serie 7“, darunter der
## Bonus und drei Marken für die Stufen. Erscheint ab drei Treffern in Folge, springt bei
## jedem Treffer kurz auf und zerfällt, wenn die Serie reißt.

const UIKit = preload("res://scenes/ui/ui_kit.gd")

const SHOW_FROM := 3

var count: int = 0
var level: int = 0
var max_levels: int = 3
var bonus_per_level: float = 0.1
var _pop: float = 0.0
var _level_pop: float = 0.0
var _fade: float = 0.0
var _broken_count: int = 0
var _font: Font


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size = Vector2(240, 170)
	pivot_offset = size * 0.5
	_font = UIKit.theme().default_font if UIKit.theme() != null else null
	if _font == null:
		_font = ThemeDB.fallback_font


func set_streak(n: int, lv: int, broke: bool) -> void:
	if broke:
		if count >= SHOW_FROM:
			_broken_count = count
			_fade = 0.8
		count = 0
		level = 0
		queue_redraw()
		return
	if lv > level:
		_level_pop = 0.6
	count = n
	level = lv
	_pop = 0.18
	_fade = 0.0
	queue_redraw()


func reset() -> void:
	count = 0
	level = 0
	_fade = 0.0
	queue_redraw()


func _process(delta: float) -> void:
	if _pop > 0.0 or _level_pop > 0.0 or _fade > 0.0:
		_pop = maxf(0.0, _pop - delta)
		_level_pop = maxf(0.0, _level_pop - delta)
		_fade = maxf(0.0, _fade - delta)
		queue_redraw()


func _draw() -> void:
	var c := size * 0.5
	if count < SHOW_FROM:
		if _fade > 0.0:
			# Gerissene Serie: grau, sinkt ab und verblasst
			var a := _fade / 0.8
			_text(tr("UI_STREAK").format({"n": _broken_count}), Vector2(c.x, 62 + (1.0 - a) * 30.0), 50, Color(0.75, 0.72, 0.68, a))
		return
	var s := 1.0 + 0.12 * (_pop / 0.18) + 0.25 * sin(_level_pop / 0.6 * PI)
	draw_set_transform(c, 0.0, Vector2(s, s))
	var gold := Color(1.0, 0.84, 0.4).lerp(Color(1.0, 0.97, 0.75), float(level) / maxf(1.0, max_levels))
	if level > 0:
		draw_circle(Vector2(0, -24), 70.0 + 8.0 * level, Color(1.0, 0.7, 0.25, 0.10 + 0.05 * level))
	_text(tr("UI_STREAK").format({"n": count}), Vector2(0, -22), 52, gold)
	if level > 0:
		var pct := int(round(bonus_per_level * level * 100.0))
		_text(tr("UI_STREAK_BONUS").format({"p": pct}), Vector2(0, 22), 26, Color(1.0, 0.92, 0.7))
	# Stufen-Marken
	for k in max_levels:
		var x := (float(k) - (max_levels - 1) * 0.5) * 30.0
		var on := k < level
		draw_circle(Vector2(x, 54), 9.0, Color(0, 0, 0, 0.55))
		draw_circle(Vector2(x, 54), 7.0, gold if on else Color(0.35, 0.3, 0.26))
	draw_set_transform(Vector2.ZERO)


func _text(t: String, center: Vector2, fs: int, col: Color) -> void:
	var w := _font.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	var pos := Vector2(center.x - w * 0.5, center.y + fs * 0.35)
	draw_string_outline(_font, pos, t, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 9, Color(0, 0, 0, 0.8 * col.a))
	draw_string(_font, pos, t, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
