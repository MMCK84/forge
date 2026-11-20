extends Control
## Werkstatt-Einrichtung in der Werkstatt (Bühnen-Koordinaten 1080 × 1920). Gekaufte Stücke:
## Grafik des Auftraggebers (ui/user/furn_e<E>_<platz>.png), sonst eine einfache Platzhalter-
## Zeichnung. Fehlende Stücke: Kreide-Umriss, damit man sieht, was noch kommt.
## Liegt hinter Esse, Maschine und Amboss.

const Assets = preload("res://scripts/assets.gd")
const Furnishings = preload("res://scripts/furnishings.gd")

## Lage je Platz: Mitte unten des Stücks (x, Abstand zur Wand-Boden-Kante) und Größe
const LAYOUT := {
	"tools": {"x": 78.0, "dy": -60.0, "size": Vector2(140, 200)},
	"trade": {"x": 975.0, "dy": -300.0, "size": Vector2(170, 110)},
	"light": {"x": 800.0, "dy": -430.0, "size": Vector2(60, 110)},
	"fuel": {"x": 1010.0, "dy": 95.0, "size": Vector2(130, 105)},
	"bench": {"x": 985.0, "dy": 250.0, "size": Vector2(200, 140)},
}

var epoch: int = 1
var owned: Array = []
var floor_y: float = 900.0
var _t: float = 0.0
## Kurzes Aufleuchten nach einem Kauf (Platz -> verbleibende Zeit)
var _pop: Dictionary = {}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size = Vector2(1080, 1920)


func _process(delta: float) -> void:
	_t += delta
	for k in _pop.keys():
		_pop[k] = float(_pop[k]) - delta
		if _pop[k] <= 0.0:
			_pop.erase(k)
	if owned.has("light") or not _pop.is_empty():
		queue_redraw()


func set_state(e: int, slots: Array, fy: float) -> void:
	for sl in slots:
		if not owned.has(sl) and e == epoch:
			_pop[sl] = 0.6
	epoch = e
	owned = slots.duplicate()
	floor_y = fy
	queue_redraw()


## Grafik des Auftraggebers für ein Einrichtungsstück (oder null).
static func icon(e: int, slot: String) -> Texture2D:
	return Assets.user(Furnishings.item_id(e, slot) + ".png")


## Rechteck eines Platzes (Bühnen-Koordinaten).
func slot_rect(slot: String) -> Rect2:
	var l: Dictionary = LAYOUT[slot]
	var sz: Vector2 = l["size"]
	return Rect2(float(l["x"]) - sz.x * 0.5, floor_y + float(l["dy"]) - sz.y, sz.x, sz.y)


func _draw() -> void:
	for slot in Furnishings.SLOTS:
		var r := slot_rect(slot)
		if owned.has(slot):
			var s := 1.0
			if _pop.has(slot):
				s = 1.0 + 0.25 * sin(float(_pop[slot]) / 0.6 * PI)
			var c := r.get_center()
			draw_set_transform(c, 0.0, Vector2(s, s))
			var rr := Rect2(r.position - c, r.size)
			var tex := icon(epoch, slot)
			if tex != null:
				var k := minf(rr.size.x / tex.get_width(), rr.size.y / tex.get_height())
				var ts := Vector2(tex.get_width(), tex.get_height()) * k
				draw_texture_rect(tex, Rect2(rr.position.x + (rr.size.x - ts.x) * 0.5, rr.end.y - ts.y, ts.x, ts.y), false)
			else:
				_draw_placeholder(slot, rr, false)
			draw_set_transform(Vector2.ZERO)
		else:
			_draw_placeholder(slot, r, true)


# ------------------------------------------------------------------ Platzhalter

func _late() -> bool:
	return epoch >= 7


func _draw_placeholder(slot: String, r: Rect2, chalk: bool) -> void:
	var ink := Color(0.12, 0.08, 0.05)
	var wood := Color("6b4a2f") if not _late() else Color("4a4440")
	var iron := Color("3d3f44")
	var brass := Color("b08d57")
	var w := 3.0
	if chalk:
		ink = Color(0.96, 0.94, 0.86, 0.6)
	match slot:
		"tools":
			# Brett mit Zangen/Hämmern
			_box(Rect2(r.position.x, r.position.y, r.size.x, r.size.y * 0.75), wood, ink, chalk, w)
			for k in 4:
				var x := r.position.x + 20.0 + k * (r.size.x - 40.0) / 3.0
				var top := r.position.y + 14.0
				_line(Vector2(x, top), Vector2(x - 6, top + r.size.y * 0.6), iron, ink, chalk, 5.0)
				_line(Vector2(x, top), Vector2(x + 6, top + r.size.y * 0.6), iron, ink, chalk, 5.0)
		"trade":
			# Schild an zwei Ketten
			var board := Rect2(r.position.x, r.position.y + r.size.y * 0.3, r.size.x, r.size.y * 0.7)
			_line(Vector2(board.position.x + 20, r.position.y), Vector2(board.position.x + 20, board.position.y), iron, ink, chalk, 2.0)
			_line(Vector2(board.end.x - 20, r.position.y), Vector2(board.end.x - 20, board.position.y), iron, ink, chalk, 2.0)
			_box(board, wood if epoch < 7 else Color("8a6a3a"), ink, chalk, w)
			if not chalk:
				draw_rect(board.grow(-8), brass, false, 3.0)
				draw_arc(board.get_center(), board.size.y * 0.25, PI * 0.15, PI * 0.85, 12, Color("2a2a2a"), 6.0)
		"light":
			# Laterne an einer Stange
			_line(Vector2(r.get_center().x, r.position.y), Vector2(r.get_center().x, r.position.y + 30), iron, ink, chalk, 3.0)
			var body := Rect2(r.position.x + 8, r.position.y + 30, r.size.x - 16, r.size.y - 30)
			if not chalk:
				var flick := 0.8 + 0.2 * sin(_t * 9.0) * sin(_t * 3.7)
				draw_circle(body.get_center(), body.size.x * 1.6, Color(1.0, 0.75, 0.35, 0.10 * flick))
				draw_rect(body.grow(-6), Color(1.0, 0.8, 0.4, 0.85 * flick))
			_box(body, Color(0, 0, 0, 0), ink, chalk, w)
		"fuel":
			# Korb bzw. Kiste mit Kohle
			var bin := Rect2(r.position.x, r.position.y + r.size.y * 0.3, r.size.x, r.size.y * 0.7)
			if not chalk:
				draw_circle(Vector2(bin.position.x + bin.size.x * 0.3, bin.position.y + 4), 16, Color("1c1c1e"))
				draw_circle(Vector2(bin.position.x + bin.size.x * 0.55, bin.position.y - 4), 20, Color("222226"))
				draw_circle(Vector2(bin.position.x + bin.size.x * 0.78, bin.position.y + 6), 14, Color("1c1c1e"))
			_box(bin, wood if epoch < 5 else iron, ink, chalk, w)
		"bench":
			# Werkbank mit Schraubstock
			var top := Rect2(r.position.x, r.position.y + r.size.y * 0.35, r.size.x, 18)
			_box(top, wood, ink, chalk, w)
			_line(Vector2(top.position.x + 14, top.end.y), Vector2(top.position.x + 14, r.end.y), wood, ink, chalk, 10.0)
			_line(Vector2(top.end.x - 14, top.end.y), Vector2(top.end.x - 14, r.end.y), wood, ink, chalk, 10.0)
			_box(Rect2(top.position.x + top.size.x * 0.55, r.position.y + 8, 46, top.position.y - r.position.y - 8), iron, ink, chalk, w)


func _box(r: Rect2, fill: Color, ink: Color, chalk: bool, w: float) -> void:
	if chalk:
		_dashed_rect(r, ink)
		return
	if fill.a > 0.0:
		draw_rect(r, fill)
	draw_rect(r, ink, false, w)


func _line(a: Vector2, b: Vector2, col: Color, ink: Color, chalk: bool, w: float) -> void:
	if chalk:
		draw_dashed_line(a, b, ink, 3.0, 9.0)
		return
	draw_line(a, b, ink, w + 2.0)
	draw_line(a, b, col, w)


func _dashed_rect(r: Rect2, c: Color) -> void:
	draw_dashed_line(r.position, Vector2(r.end.x, r.position.y), c, 3.0, 9.0)
	draw_dashed_line(Vector2(r.end.x, r.position.y), r.end, c, 3.0, 9.0)
	draw_dashed_line(r.end, Vector2(r.position.x, r.end.y), c, 3.0, 9.0)
	draw_dashed_line(Vector2(r.position.x, r.end.y), r.position, c, 3.0, 9.0)
