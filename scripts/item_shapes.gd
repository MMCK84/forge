extends RefCounted
## Platzhalter-"Sprites" der Gegenstände: graustufige Grundformen, die der Glow-Shader
## nach Temperatur einfärbt (ein Sprite je Gegenstand, Lastenheft 6.5).
## Helligkeit (Rotkanal) steuert die Schattierung, Alpha die Deckkraft.

static func _c(l: float, a: float) -> Color:
	return Color(l, l, l, a)


static func _thick(ci: CanvasItem, pts: PackedVector2Array, w: float, l: float, a: float) -> void:
	ci.draw_polyline(pts, _c(l, a), w, true)


static func _arc(ci: CanvasItem, c: Vector2, r: float, a0: float, a1: float, w: float, l: float, a: float) -> void:
	ci.draw_arc(c, r, a0, a1, 32, _c(l, a), w, true)


## Zeichnet `shape` zentriert um (0,0); s = Bezugsgröße in Pixeln.
static func draw(ci: CanvasItem, shape: String, s: float, a: float = 1.0) -> void:
	var hi := 0.95
	var mid := 0.7
	var lo := 0.45
	match shape:
		"bar":
			ci.draw_rect(Rect2(-s * 0.5, -s * 0.07, s, s * 0.14), _c(mid, a))
			ci.draw_rect(Rect2(-s * 0.5, -s * 0.07, s, s * 0.04), _c(hi, a))
		"nail":
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-s * 0.35, -s * 0.03), Vector2(s * 0.3, -s * 0.03), Vector2(s * 0.4, 0), Vector2(s * 0.3, s * 0.03), Vector2(-s * 0.35, s * 0.03)]), _c(mid, a))
			ci.draw_rect(Rect2(-s * 0.4, -s * 0.09, s * 0.06, s * 0.18), _c(hi, a))
		"horseshoe":
			_arc(ci, Vector2.ZERO, s * 0.3, PI * 0.15, PI * 1.85, s * 0.12, mid, a)
			_arc(ci, Vector2.ZERO, s * 0.34, PI * 0.2, PI * 1.8, s * 0.03, hi, a)
		"hook":
			_thick(ci, PackedVector2Array([Vector2(-s * 0.45, 0), Vector2(s * 0.15, 0)]), s * 0.08, mid, a)
			_arc(ci, Vector2(s * 0.15, s * 0.15), s * 0.15, -PI * 0.5, PI * 0.9, s * 0.08, mid, a)
		"hinge":
			ci.draw_rect(Rect2(-s * 0.45, -s * 0.08, s * 0.8, s * 0.16), _c(mid, a))
			ci.draw_circle(Vector2(s * 0.38, 0), s * 0.1, _c(hi, a))
			ci.draw_circle(Vector2(-s * 0.2, 0), s * 0.03, _c(lo, a))
			ci.draw_circle(Vector2(s * 0.05, 0), s * 0.03, _c(lo, a))
		"sickle":
			_arc(ci, Vector2(s * 0.05, s * 0.1), s * 0.32, PI * 1.05, PI * 2.0, s * 0.08, hi, a)
			_thick(ci, PackedVector2Array([Vector2(-s * 0.27, s * 0.1), Vector2(-s * 0.45, s * 0.3)]), s * 0.08, lo, a)
		"ploughshare":
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-s * 0.45, s * 0.15), Vector2(s * 0.45, s * 0.15), Vector2(s * 0.1, -s * 0.2), Vector2(-s * 0.35, -s * 0.12)]), _c(mid, a))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-s * 0.45, s * 0.15), Vector2(s * 0.45, s * 0.15), Vector2(s * 0.3, s * 0.08)]), _c(hi, a))
		"bracket", "lantern":
			_thick(ci, PackedVector2Array([Vector2(-s * 0.4, -s * 0.2), Vector2(-s * 0.4, s * 0.15), Vector2(s * 0.4, s * 0.15)]), s * 0.08, mid, a)
			_thick(ci, PackedVector2Array([Vector2(-s * 0.4, -s * 0.05), Vector2(s * 0.1, s * 0.15)]), s * 0.05, hi, a)
			if shape == "lantern":
				_arc(ci, Vector2(s * 0.35, s * 0.27), s * 0.08, 0, TAU, s * 0.04, hi, a)
		"tyre":
			_arc(ci, Vector2.ZERO, s * 0.32, 0, TAU, s * 0.08, mid, a)
			_arc(ci, Vector2.ZERO, s * 0.35, PI, TAU, s * 0.025, hi, a)
		"axle", "shaft", "rod", "tie":
			var w := s * (0.16 if shape == "shaft" else 0.1)
			ci.draw_rect(Rect2(-s * 0.5, -w * 0.5, s, w), _c(mid, a))
			ci.draw_rect(Rect2(-s * 0.5, -w * 0.5, s, w * 0.3), _c(hi, a))
			if shape == "axle":
				ci.draw_rect(Rect2(-s * 0.5, -w, s * 0.08, w * 2.0), _c(lo, a))
				ci.draw_rect(Rect2(s * 0.42, -w, s * 0.08, w * 2.0), _c(lo, a))
			elif shape == "rod":
				ci.draw_circle(Vector2(s * 0.45, 0), w * 0.9, _c(hi, a))
			elif shape == "tie":
				_arc(ci, Vector2(-s * 0.45, 0), w, 0, TAU, w * 0.5, hi, a)
		"crank":
			_thick(ci, PackedVector2Array([Vector2(-s * 0.5, 0), Vector2(-s * 0.12, 0), Vector2(-s * 0.12, s * 0.2), Vector2(s * 0.12, s * 0.2), Vector2(s * 0.12, 0), Vector2(s * 0.5, 0)]), s * 0.12, mid, a)
		"chain":
			for k in 3:
				var cx := -s * 0.3 + k * s * 0.3
				ci.draw_arc(Vector2(cx, 0), s * 0.16, 0, TAU, 24, _c(mid if k % 2 == 0 else hi, a), s * 0.06, true)
		"anchor":
			_thick(ci, PackedVector2Array([Vector2(0, -s * 0.45), Vector2(0, s * 0.3)]), s * 0.09, mid, a)
			_arc(ci, Vector2(0, s * 0.05), s * 0.3, PI * 0.1, PI * 0.9, s * 0.09, hi, a)
			_thick(ci, PackedVector2Array([Vector2(-s * 0.18, -s * 0.3), Vector2(s * 0.18, -s * 0.3)]), s * 0.06, lo, a)
			_arc(ci, Vector2(0, -s * 0.5), s * 0.06, 0, TAU, s * 0.03, hi, a)
		"boathook":
			_thick(ci, PackedVector2Array([Vector2(-s * 0.5, s * 0.05), Vector2(s * 0.25, s * 0.05)]), s * 0.07, mid, a)
			_thick(ci, PackedVector2Array([Vector2(s * 0.25, s * 0.05), Vector2(s * 0.45, -s * 0.15)]), s * 0.07, hi, a)
			_arc(ci, Vector2(s * 0.3, s * 0.18), s * 0.12, -PI * 0.5, PI * 0.6, s * 0.06, hi, a)
		"bolt", "rivet":
			var l := s * (0.6 if shape == "bolt" else 0.3)
			ci.draw_rect(Rect2(-l * 0.5, -s * 0.05, l, s * 0.1), _c(mid, a))
			ci.draw_rect(Rect2(-l * 0.5 - s * 0.06, -s * 0.12, s * 0.08, s * 0.24), _c(hi, a))
		"spindle":
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-s * 0.5, 0), Vector2(-s * 0.1, -s * 0.04), Vector2(s * 0.4, -s * 0.03), Vector2(s * 0.5, 0), Vector2(s * 0.4, s * 0.03), Vector2(-s * 0.1, s * 0.04)]), _c(mid, a))
			ci.draw_circle(Vector2(-s * 0.15, 0), s * 0.07, _c(hi, a))
		"shears":
			_thick(ci, PackedVector2Array([Vector2(-s * 0.45, -s * 0.05), Vector2(s * 0.45, -s * 0.12)]), s * 0.08, hi, a)
			_thick(ci, PackedVector2Array([Vector2(-s * 0.45, s * 0.05), Vector2(s * 0.45, s * 0.12)]), s * 0.08, mid, a)
			_arc(ci, Vector2(-s * 0.45, 0), s * 0.07, PI * 0.5, PI * 1.5, s * 0.05, lo, a)
		"blade":
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-s * 0.1, -s * 0.07), Vector2(s * 0.45, -s * 0.07), Vector2(s * 0.5, -s * 0.02), Vector2(s * 0.3, s * 0.08), Vector2(-s * 0.1, s * 0.07)]), _c(hi, a))
			ci.draw_rect(Rect2(-s * 0.48, -s * 0.03, s * 0.38, s * 0.06), _c(lo, a))
		"spring":
			for k in 3:
				_arc(ci, Vector2(0, s * 0.05 * k), s * (0.42 - k * 0.07), PI * 1.15, PI * 1.85, s * 0.045, mid if k % 2 == 0 else hi, a)
		"tool", "file":
			ci.draw_rect(Rect2(-s * 0.45, -s * 0.06, s * 0.75, s * 0.12), _c(mid, a))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(s * 0.3, -s * 0.06), Vector2(s * 0.48, 0), Vector2(s * 0.3, s * 0.06)]), _c(hi, a))
			if shape == "file":
				for k in 6:
					var x := -s * 0.35 + k * s * 0.1
					ci.draw_line(Vector2(x, -s * 0.06), Vector2(x + s * 0.05, s * 0.06), _c(lo, a), 2.0)
		"pick":
			_thick(ci, PackedVector2Array([Vector2(-s * 0.45, -s * 0.12), Vector2(0, -s * 0.2), Vector2(s * 0.45, -s * 0.12)]), s * 0.08, hi, a)
			ci.draw_rect(Rect2(-s * 0.04, -s * 0.18, s * 0.08, s * 0.45), _c(lo, a))
		"valve":
			ci.draw_circle(Vector2.ZERO, s * 0.18, _c(mid, a))
			ci.draw_circle(Vector2.ZERO, s * 0.08, _c(lo, a))
			ci.draw_rect(Rect2(-s * 0.45, -s * 0.05, s * 0.3, s * 0.1), _c(hi, a))
			ci.draw_rect(Rect2(s * 0.15, -s * 0.05, s * 0.3, s * 0.1), _c(hi, a))
		"plate":
			ci.draw_rect(Rect2(-s * 0.45, -s * 0.12, s * 0.9, s * 0.24), _c(mid, a))
			for k in 5:
				ci.draw_circle(Vector2(-s * 0.38 + k * s * 0.19, -s * 0.07), s * 0.02, _c(lo, a))
			ci.draw_rect(Rect2(-s * 0.45, -s * 0.12, s * 0.9, s * 0.04), _c(hi, a))
		_:
			ci.draw_rect(Rect2(-s * 0.5, -s * 0.07, s, s * 0.14), _c(mid, a))
