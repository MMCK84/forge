extends Control
## Die Esse mit 1–3 Plätzen, Glut, Rauchfang und Blasebalg (Platzhaltergrafik).
## Klick/Tippen auf einen Platz meldet slot_clicked; auf den Rohling-Stapel raw_clicked.

const Assets = preload("res://scripts/assets.gd")

signal slot_clicked(slot: int)
signal raw_clicked()

var tier: int = 1
var slots: int = 1
var raw_count: int = 0
var heating: bool = false
var selected_slot: int = 0
var _t: float = 0.0
## Bereich des Rohling-Stapels (lokal)
var raw_rect := Rect2(0, 600, 300, 100)

## Essen-Grafiken des Auftraggebers (vorskaliert, 1:1 gezeichnet): Zeichenursprung,
## Glutbett (Mitte/Breite) und Schornsteinmündung für den Rauch, alles lokal.
const USER_FORGES := {
	1: {"file": "forge_clay.png", "origin": Vector2(-60, 118), "bed": Vector2(440, 380), "bed_w": 300.0, "chimney": Vector2(565, 122)},
	2: {"file": "forge_brick.png", "origin": Vector2(-60, 118), "bed": Vector2(440, 380), "bed_w": 300.0, "chimney": Vector2(571, 122)},
	3: {"file": "forge_double_bellows.png", "origin": Vector2(-34, 118), "bed": Vector2(584, 493), "bed_w": 400.0, "chimney": Vector2(606, 123)},
	4: {"file": "forge_coke.png", "origin": Vector2(-66, 118), "bed": Vector2(654, 442), "bed_w": 380.0, "chimney": Vector2(688, 123)},
}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP


func _process(delta: float) -> void:
	_t += delta
	queue_redraw()


## Essen-Grafik des Auftraggebers für die aktuelle Stufe (leer, wenn keine vorhanden).
func user_forge() -> Dictionary:
	var d: Dictionary = USER_FORGES.get(tier, {})
	if d.is_empty() or Assets.user(str(d["file"])) == null:
		return {}
	return d


## Unterkante der Essen-Grafik (lokal) – steht auf der Wand-Boden-Kante.
func body_bottom() -> float:
	var d := user_forge()
	if not d.is_empty():
		var o: Vector2 = d["origin"]
		return o.y + float(Assets.user(str(d["file"])).get_height())
	return 572.0


## Schornsteinmündung (lokal) – dort steigt der Rauch auf.
func smoke_point() -> Vector2:
	var d := user_forge()
	if d.is_empty():
		return Vector2(440, 260)
	var p: Vector2 = d["chimney"]
	return p


## Mittelpunkt eines Platzes (lokal).
func slot_center(i: int) -> Vector2:
	var n := maxi(1, slots)
	var d := user_forge()
	if not d.is_empty():
		var bed: Vector2 = d["bed"]
		var half := float(d["bed_w"]) * 0.25 * (n - 1)
		var bx := bed.x if n == 1 else bed.x - half + 2.0 * half * float(i) / float(n - 1)
		return Vector2(bx, bed.y - 12.0)
	var x0 := 230.0
	var x1 := 650.0
	var x := (x0 + x1) * 0.5 if n == 1 else x0 + (x1 - x0) * float(i) / float(n - 1)
	return Vector2(x, 395.0)


func slot_rect(i: int) -> Rect2:
	var c := slot_center(i)
	var w := 180.0
	if slots > 1:
		w = minf(w, absf(slot_center(1).x - slot_center(0).x) - 8.0)
	return Rect2(c.x - w * 0.5, c.y - 80, w, 140)


func raw_center() -> Vector2:
	return raw_rect.get_center()


func _gui_input(event: InputEvent) -> void:
	var mb := event as InputEventMouseButton
	if mb != null and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
		var p: Vector2 = mb.position
		if raw_rect.has_point(p):
			raw_clicked.emit()
			accept_event()
			return
		for i in slots:
			if slot_rect(i).has_point(p):
				slot_clicked.emit(i)
				accept_event()
				return


func _draw() -> void:
	var ua := user_forge()
	if not ua.is_empty():
		_draw_user(ua)
		_draw_overlay(false)
		return
	var body := Assets.tex("environment/forge_%d.png" % clampi(tier, 1, 4))
	if body != null:
		_draw_textured(body)
		_draw_overlay()
		return
	var stone: Color = [Color("7a5a3a"), Color("8a3f2a"), Color("7a4030"), Color("4a4a4f")][clampi(tier, 1, 4) - 1]
	# Rauchfang
	draw_colored_polygon(PackedVector2Array([Vector2(200, 40), Vector2(680, 40), Vector2(760, 250), Vector2(120, 250)]), stone.darkened(0.35))
	draw_rect(Rect2(380, -150, 120, 190), stone.darkened(0.45))
	# Herd
	draw_rect(Rect2(110, 330, 660, 230), stone)
	if tier == 2 or tier == 3:
		var y := 330.0
		var row := 0
		while y < 560.0:
			var x := 110.0 + (30.0 if row % 2 == 1 else 0.0)
			while x < 770.0:
				draw_rect(Rect2(x, y, minf(60.0, 770.0 - x), 28), stone.darkened(0.25), false, 2.0)
				x += 60.0
			y += 28.0
			row += 1
	if tier == 4:
		for k in 6:
			draw_circle(Vector2(140 + k * 120, 545), 8, Color("6d6f73"))
	# Glutbett
	var fire := Color(1.0, 0.45, 0.1)
	var flick := 0.75 + 0.25 * sin(_t * 7.0) * sin(_t * 3.1)
	if heating:
		flick += 0.2
	draw_rect(Rect2(150, 360, 580, 70), Color(0.15, 0.06, 0.03))
	for k in 18:
		var cx := 165.0 + k * 32.0
		var cy := 405.0 + 8.0 * sin(k * 1.7)
		var glow := clampf(flick * (0.6 + 0.4 * sin(_t * 5.0 + k)), 0.2, 1.2)
		draw_circle(Vector2(cx, cy), 17, Color(fire.r, fire.g * glow, fire.b, 0.9))
		draw_circle(Vector2(cx, cy), 8, Color(1.0, 0.85, 0.4, 0.6 * glow))
	for k in 3:
		draw_circle(Vector2(440, 380), 200.0 + k * 60.0, Color(1.0, 0.5, 0.15, 0.035 * flick))
	_draw_overlay()


func _draw_textured(body: Texture2D) -> void:
	var flick := 0.8 + 0.2 * sin(_t * 7.0) * sin(_t * 3.1)
	if heating:
		flick += 0.15
	var pump := 0.5 + 0.5 * sin(_t * (5.0 if heating else 1.5))
	# Blasebalg bzw. Zylindergebläse hinter dem Herd
	if tier < 4:
		var bel := Assets.tex("tools/bellows.png")
		if bel != null:
			for k in (2 if tier == 3 else 1):
				var y := 430.0 + k * 85.0
				draw_set_transform(Vector2(-150, y), 0.0, Vector2(1.0, 0.75 + 0.35 * pump))
				draw_texture(bel, Vector2(0, -bel.get_height() * 0.5))
			draw_set_transform(Vector2.ZERO)
	else:
		var bl := Assets.tex("tools/blower.png")
		if bl != null:
			draw_texture(bl, Vector2(-110, 300))
	draw_texture(body, Vector2(-160, -160))
	var glow := Assets.tex("environment/fire_glow.png")
	if glow != null:
		draw_texture(glow, Vector2(440 - glow.get_width() * 0.5, 395 - glow.get_height() * 0.55), Color(1, 1, 1, clampf(0.55 * flick, 0.0, 1.0)))
	var coal := Assets.tex("environment/coals.png")
	if coal != null:
		draw_texture(coal, Vector2(440 - coal.get_width() * 0.5, 340), Color(flick, 0.85 + 0.15 * flick, 0.8 + 0.2 * flick))


## Essen-Grafik des Auftraggebers: Glut ist eingemalt, darüber flackert nur der Feuerschein.
## Die Lehmesse hat keinen eigenen Blasebalg – dann pumpt der gerenderte daneben.
func _draw_user(d: Dictionary) -> void:
	var flick := 0.8 + 0.2 * sin(_t * 7.0) * sin(_t * 3.1)
	if heating:
		flick += 0.15
	if tier == 1:
		var bel := Assets.tex("tools/bellows.png")
		if bel != null:
			var pump := 0.5 + 0.5 * sin(_t * (5.0 if heating else 1.5))
			draw_set_transform(Vector2(-150, 470), 0.0, Vector2(1.0, 0.75 + 0.35 * pump))
			draw_texture(bel, Vector2(0, -bel.get_height() * 0.5))
			draw_set_transform(Vector2.ZERO)
	draw_texture(Assets.user(str(d["file"])), d["origin"])
	var glow := Assets.tex("environment/fire_glow.png")
	if glow != null:
		var bed: Vector2 = d["bed"]
		var w := float(d["bed_w"]) * 1.7
		var h := w * glow.get_height() / glow.get_width()
		draw_texture_rect(glow, Rect2(bed.x - w * 0.5, bed.y - h * 0.6, w, h), false, Color(1, 1, 1, clampf(0.35 * flick, 0.0, 1.0)))


## Platzmarkierungen und Rohling-Stapel (über Code- und Sprite-Grafik)
func _draw_overlay(code_bellows: bool = true) -> void:
	for i in slots:
		var r := slot_rect(i)
		var col := Color(1, 0.85, 0.5, 0.55) if i == selected_slot else Color(1, 0.8, 0.5, 0.18)
		draw_rect(r, col, false, 3.0)
		draw_string(Assets.ui_font(), r.position + Vector2(8, 30), str(i + 1), HORIZONTAL_ALIGNMENT_LEFT, -1, 32, col)
	# Blasebalg (bei Doppelblasebalg zwei, bei Koks-Esse Zylindergebläse)
	var pump := 0.5 + 0.5 * sin(_t * (5.0 if heating else 1.5))
	if not code_bellows:
		pass
	elif tier < 4:
		var n := 2 if tier == 3 else 1
		for k in n:
			var by := 420.0 + k * 90.0
			var h := 40.0 + 30.0 * pump
			draw_colored_polygon(PackedVector2Array([Vector2(-60, by - h * 0.5), Vector2(60, by - 12), Vector2(60, by + 12), Vector2(-60, by + h * 0.5)]), Color("6b4a2f"))
			draw_line(Vector2(-60, by - h * 0.5), Vector2(-120, by - h * 0.5 - 10), Color("3b2a1e"), 8.0)
			draw_line(Vector2(60, by), Vector2(110, by), Color("4a4a4f"), 10.0)
	else:
		draw_rect(Rect2(-80, 380, 110, 160), Color("4a4a4f"))
		draw_circle(Vector2(-25, 400), 40, Color("5a5a60"))
		draw_line(Vector2(30, 460), Vector2(110, 430), Color("4a4a4f"), 14.0)
	# Rohling-Stapel
	draw_rect(raw_rect, Color(0.18, 0.13, 0.09, 0.85))
	draw_rect(raw_rect, Color("b08d57"), false, 3.0)
	var blank := Assets.item_tex("blank")
	for k in mini(raw_count, 6):
		var y2 := raw_rect.position.y + raw_rect.size.y - 22 - (k % 3) * 14
		var x2 := raw_rect.position.x + 30 + (k / 3) * 120
		if blank != null:
			draw_texture_rect(blank, Rect2(x2 - 10, y2 - 59, 130, 130), false, Color(0.75, 0.75, 0.78))
		else:
			draw_rect(Rect2(x2, y2, 110, 12), Color("6d6f73"))
			draw_rect(Rect2(x2, y2, 110, 4), Color("9a9ca0"))
	draw_string(Assets.ui_font(), raw_rect.position + Vector2(12, 38), tr("UI_RAW_STACK") + ": " + str(raw_count), HORIZONTAL_ALIGNMENT_LEFT, -1, 32, Color("e9dcc0"))
