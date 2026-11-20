extends Control
## Meisterschafts-Siegel (Bronze, Silber, Gold) als Wachssiegel. Ein Bild des Auftraggebers
## (ui/user/seal_mastery_<stufe>.png) hat Vorrang, sonst wird das Siegel gezeichnet.
## Stufe 0: dezenter leerer Kreis (noch kein Siegel).

const Assets = preload("res://scripts/assets.gd")
const Mastery = preload("res://scripts/mastery.gd")

var level: int = 0


static func make(lv: int, px: float) -> Control:
	var s = load("res://scenes/ui/mastery_seal.gd").new()
	s.level = lv
	s.custom_minimum_size = Vector2(px, px)
	s.size = Vector2(px, px)
	s.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return s


func _draw() -> void:
	draw_seal(self, size * 0.5, minf(size.x, size.y) * 0.5, level)


static func draw_seal(ci: CanvasItem, c: Vector2, r: float, lv: int) -> void:
	var tex := Assets.user("seal_mastery_%d.png" % lv) if lv > 0 else null
	if tex != null:
		ci.draw_texture_rect(tex, Rect2(c - Vector2(r, r), Vector2(r, r) * 2.0), false)
		return
	if lv <= 0:
		ci.draw_arc(c, r * 0.8, 0, TAU, 32, Color(0.35, 0.28, 0.2, 0.35), 2.0, true)
		return
	var col: Color = Mastery.LEVEL_COLORS[clampi(lv, 0, 3)]
	# Gewellter Rand wie ein Wachssiegel
	var pts := PackedVector2Array()
	for k in 36:
		var a := TAU * k / 36.0
		var rr := r * (0.92 + 0.08 * sin(a * 9.0 + 0.7))
		pts.append(c + Vector2(cos(a), sin(a)) * rr)
	ci.draw_colored_polygon(pts, col.darkened(0.25))
	ci.draw_circle(c, r * 0.74, col)
	ci.draw_arc(c, r * 0.62, 0, TAU, 32, col.darkened(0.35), maxf(1.5, r * 0.06), true)
	# Hammer-Kreuz in der Mitte, darunter Punkte für die Stufe
	var ink := col.darkened(0.5)
	var w := maxf(2.0, r * 0.12)
	ci.draw_line(c + Vector2(-r * 0.32, r * 0.22), c + Vector2(r * 0.22, -r * 0.32), ink, w)
	ci.draw_line(c + Vector2(r * 0.32, r * 0.22), c + Vector2(-r * 0.22, -r * 0.32), ink, w)
	ci.draw_rect(Rect2(c + Vector2(r * 0.08, -r * 0.46), Vector2(r * 0.3, r * 0.18)), ink)
	ci.draw_rect(Rect2(c + Vector2(-r * 0.38, -r * 0.46), Vector2(r * 0.3, r * 0.18)), ink)
	for k in lv:
		var x := (float(k) - (lv - 1) * 0.5) * r * 0.24
		ci.draw_circle(c + Vector2(x, r * 0.42), maxf(1.5, r * 0.07), ink)
	# Glanzlicht
	ci.draw_arc(c, r * 0.68, PI * 1.1, PI * 1.45, 10, Color(1, 1, 1, 0.35), maxf(1.0, r * 0.05), true)
