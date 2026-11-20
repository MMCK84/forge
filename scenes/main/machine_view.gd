extends Control
## Schwanzhammer über dem Amboss mit Antrieb (Wasserrad oder Dampfmaschine).

const Assets = preload("res://scripts/assets.gd")

var machine_id: String = ""
var water_powered: bool = false
var water_level: float = 1.0
var drop: float = 0.0
var running: bool = false
## Dampfhammer (Nasmyth): Bär fällt senkrecht auf den Amboss, Hubhöhe nach Schlagstärke
var steam_hammer: bool = false
## Großer Dampfhammer (größer gezeichnet)
var large: bool = false
## Schlagstärke (0 leicht … 2 schwer) für die Hubhöhe
var force_level: int = 1
const RAM_LIFT := [55.0, 95.0, 150.0]
var _wheel: float = 0.0
## Position des Hammerkopfs über dem Amboss (lokal)
var head_x: float = 300.0
## Höhe der Ambossbahn (lokal) – dort trifft der Hammerkopf auf
var strike_y: float = 364.0

## Maschinenteile des Auftraggebers (ui/user/machine_*.png): Bezugspunkte in Bildpixeln
## Schwanzhammer-Teile des Auftraggebers: Maße misst der Import (scripts/user_machine_meta.gd).
const UserMachineMeta = preload("res://scripts/user_machine_meta.gd")
var BEAM_PIVOT: Vector2 = UserMachineMeta.META.get("BEAM_PIVOT", Vector2(262, 99))   # Lagerloch im Balken (Kopf rechts)
var BEAM_HEAD: Vector2 = UserMachineMeta.META.get("BEAM_HEAD", Vector2(655, 199))    # Mitte/Unterkante des Hammerkopfs
## Reichweite Lager → Kopf und Höhe des Gestells im Spiel (Bühnen-Pixel), unabhängig von der Grafik
const BEAM_REACH := 334.0
const FRAME_DRAW_HEIGHT := 328.0
var FRAME_BEARING: Vector2 = UserMachineMeta.META.get("FRAME_BEARING", Vector2(330, 30))   # Lager oben auf dem Gestell
var FRAME_SIZE: Vector2 = UserMachineMeta.META.get("FRAME_HEIGHT", Vector2(670, 657))
const WHEEL_SCALE := 0.95
var ENGINE_PIVOT: Vector2 = UserMachineMeta.META.get("ENGINE_PIVOT", Vector2(452, 64))    # Säulenkopf der Dampfmaschine
var ENGINE_ROD: Vector2 = UserMachineMeta.META.get("ENGINE_ROD", Vector2(215, 4))         # Kolbenstange oben
var ENGINE_SIZE: Vector2 = UserMachineMeta.META.get("ENGINE_SIZE", Vector2(612, 666))
## Höhe der Dampfmaschine im Spiel (Bühnen-Pixel), unabhängig von der Grafik
const ENGINE_DRAW_HEIGHT := 280.0
var ENGINE_BEAM_PIVOT: Vector2 = UserMachineMeta.META.get("ENGINE_BEAM_PIVOT", Vector2(350, 48))
var ENGINE_BEAM_HALF: float = UserMachineMeta.META.get("ENGINE_BEAM_HALF", Vector2(325, 0)).x


func strike() -> void:
	drop = 1.0


func _process(delta: float) -> void:
	drop = maxf(0.0, drop - delta * 5.0)
	if machine_id != "":
		_wheel += delta * (0.6 + 1.4 * (water_level if water_powered else 1.0)) * (1.0 if running or water_powered else 0.25)
	queue_redraw()


func _draw() -> void:
	if machine_id == "":
		return
	if steam_hammer:
		_draw_steam_hammer()
		return
	if _draw_user():
		return
	var pivot := Vector2(size.x - 330, 130)
	var head := Vector2(head_x, 175 + 145 * drop)
	if _draw_textured(pivot, head):
		return
	# Gestell
	draw_rect(Rect2(pivot.x - 20, pivot.y - 10, 40, 300), Color("4a3220"))
	# Helm (Balken)
	draw_line(pivot, head, Color("5a3e28"), 26.0)
	draw_line(pivot, pivot + (pivot - head).normalized() * 120.0, Color("5a3e28"), 26.0)
	draw_circle(pivot, 18, Color("6d6f73"))
	# Hammerkopf
	draw_rect(Rect2(head.x - 45, head.y - 20, 90, 70), Color("3c3f45"))
	draw_rect(Rect2(head.x - 45, head.y - 20, 90, 10), Color("6d727b"))
	# Antrieb
	var drive := Vector2(size.x - 120, 150)
	if water_powered:
		draw_arc(drive, 110, 0, TAU, 40, Color("5a3e28"), 14.0)
		for k in 8:
			var ang := _wheel + k * TAU / 8.0
			var p := drive + Vector2(cos(ang), sin(ang)) * 110.0
			draw_line(drive, p, Color("5a3e28"), 8.0)
			draw_rect(Rect2(p.x - 14, p.y - 14, 28, 28), Color("4a3220"))
		draw_circle(drive, 16, Color("6d6f73"))
		# Wasserstand (60–100 %)
		var gauge := Rect2(size.x - 28, 40, 18, 200)
		draw_rect(gauge, Color(0.1, 0.1, 0.1, 0.6))
		var h := gauge.size.y * clampf(water_level, 0.0, 1.0)
		draw_rect(Rect2(gauge.position.x, gauge.end.y - h, gauge.size.x, h), Color(0.3, 0.55, 0.8))
		draw_string(Assets.ui_font(), Vector2(gauge.position.x - 50, gauge.end.y + 28), "%d %%" % int(round(water_level * 100.0)), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("e9dcc0"))
	else:
		# Dampfmaschine: Zylinder, Balancier, Schwungrad
		draw_rect(Rect2(drive.x - 160, 120, 60, 150), Color("4a4a4f"))
		var beam := sin(_wheel * 2.0) * 0.25
		var bc := Vector2(drive.x - 60, 70)
		draw_line(bc + Vector2(-110, 0).rotated(beam), bc + Vector2(110, 0).rotated(beam), Color("3c3f45"), 14.0)
		draw_rect(Rect2(bc.x - 10, bc.y, 20, 180), Color("4a3220"))
		draw_arc(drive + Vector2(40, 120), 70, 0, TAU, 40, Color("3c3f45"), 12.0)
		for k in 6:
			var ang2 := _wheel * 2.0 + k * TAU / 6.0
			draw_line(drive + Vector2(40, 120), drive + Vector2(40, 120) + Vector2(cos(ang2), sin(ang2)) * 70.0, Color("3c3f45"), 5.0)
		if running:
			for k in 3:
				var sp := Vector2(drive.x - 130, 100 - k * 30 - fmod(_wheel * 40.0, 30.0))
				draw_circle(sp, 14.0 + k * 6.0, Color(0.9, 0.9, 0.92, 0.25))


func _draw_textured(pivot: Vector2, head: Vector2) -> bool:
	var post := Assets.tex("tools/helve_post.png")
	var beam := Assets.tex("tools/helve_beam.png")
	var head_t := Assets.tex("tools/helve_head.png")
	if post == null or beam == null or head_t == null:
		return false
	var drive := Vector2(size.x - 175, 150)
	if water_powered:
		var wheel := Assets.tex("tools/water_wheel.png")
		if wheel != null:
			draw_set_transform(drive, _wheel, Vector2.ONE)
			draw_texture(wheel, -wheel.get_size() * 0.5)
			draw_set_transform(Vector2.ZERO)
		var gauge := Rect2(size.x - 40, 40, 22, 200)
		draw_rect(gauge, Color(0.1, 0.1, 0.1, 0.6))
		var h := gauge.size.y * clampf(water_level, 0.0, 1.0)
		draw_rect(Rect2(gauge.position.x, gauge.end.y - h, gauge.size.x, h), Color(0.3, 0.55, 0.8))
		draw_string(Assets.ui_font(), Vector2(gauge.position.x - 40, gauge.end.y + 28), "%d %%" % int(round(water_level * 100.0)), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("e9dcc0"))
	else:
		var eng := Assets.tex("tools/engine.png")
		var eb := Assets.tex("tools/engine_beam.png")
		var fw := Assets.tex("tools/flywheel.png")
		if eng != null:
			draw_texture(eng, drive + Vector2(-170, -60))
		if eb != null:
			draw_set_transform(drive + Vector2(-70, 30), sin(_wheel * 2.0) * 0.25, Vector2.ONE)
			draw_texture(eb, -eb.get_size() * 0.5)
			draw_set_transform(Vector2.ZERO)
		if fw != null:
			draw_set_transform(drive + Vector2(40, 140), _wheel * 2.0, Vector2.ONE)
			draw_texture(fw, -fw.get_size() * 0.5)
			draw_set_transform(Vector2.ZERO)
		if running:
			for k in 3:
				var sp := Vector2(drive.x - 160, 70 - k * 30 - fmod(_wheel * 40.0, 30.0))
				draw_circle(sp, 14.0 + k * 6.0, Color(0.9, 0.9, 0.92, 0.25))
	draw_texture(post, pivot + Vector2(-55, -20))
	var ang := (head - pivot).angle()
	var stretch := (head - pivot).length() / 460.0
	draw_set_transform(pivot, ang, Vector2(stretch, 1.0))
	draw_texture(beam, Vector2(-30, -30))
	draw_set_transform(Vector2.ZERO)
	draw_texture(head_t, head + Vector2(-60, -30))
	return true


## Hochformat-Maschine aus den Einzelteilen des Auftraggebers: Antrieb rechts hinten,
## Gestell mit Lager rechts neben dem Amboss, Balken mit Kopf schlägt auf die Ambossbahn.
func _draw_user() -> bool:
	var beam := Assets.user("machine_helve_beam.png")
	var frame := Assets.user("machine_helve_frame.png")
	if beam == null or frame == null:
		return false
	var beam_scale := BEAM_REACH / maxf(1.0, BEAM_HEAD.x - BEAM_PIVOT.x)
	var frame_scale := FRAME_DRAW_HEIGHT / maxf(1.0, FRAME_SIZE.y)
	var reach := BEAM_REACH
	var pivot := Vector2(head_x + reach, strike_y - (BEAM_HEAD.y - BEAM_PIVOT.y) * beam_scale)
	if water_powered:
		var wheel := Assets.user("machine_water_wheel.png")
		if wheel == null:
			return false
		var wc := pivot + Vector2(150, 80)
		var ws := wheel.get_size() * WHEEL_SCALE
		draw_set_transform(wc, _wheel, Vector2.ONE)
		draw_texture_rect(wheel, Rect2(-ws * 0.5, ws), false)
		draw_set_transform(Vector2.ZERO)
	else:
		var eng := Assets.user("machine_engine_body.png")
		var eb := Assets.user("machine_engine_beam.png")
		var fw := Assets.user("machine_flywheel.png")
		if eng == null or eb == null or fw == null:
			return false
		var engine_scale := ENGINE_DRAW_HEIGHT / maxf(1.0, ENGINE_SIZE.y)
		var es := eng.get_size() * engine_scale
		# rechte Kante knapp innerhalb der Bühne (Bühnenbreite 1080, eigene Position abziehen)
		var eo := Vector2(1060.0 - position.x - es.x, pivot.y + 320.0 - es.y)
		var fc := eo + Vector2(es.x + 10.0, es.y - 140.0)
		var fs := fw.get_size() * 0.6
		draw_set_transform(fc, _wheel * 2.0, Vector2.ONE)
		draw_texture_rect(fw, Rect2(-fs * 0.5, fs), false)
		draw_set_transform(Vector2.ZERO)
		draw_texture_rect(eng, Rect2(eo, es), false)
		var col_top := eo + ENGINE_PIVOT * engine_scale
		var rod_top := eo + ENGINE_ROD * engine_scale
		var bs := (col_top.x - rod_top.x) / ENGINE_BEAM_HALF
		draw_set_transform(col_top, sin(_wheel * 2.0) * 0.18, Vector2(bs, bs))
		draw_texture(eb, -ENGINE_BEAM_PIVOT)
		draw_set_transform(Vector2.ZERO)
		if running:
			for k in 3:
				var sp := rod_top + Vector2(-30, -20 - k * 30 - fmod(_wheel * 40.0, 30.0))
				draw_circle(sp, 16.0 + k * 7.0, Color(0.9, 0.9, 0.92, 0.25))
	var fsz := frame.get_size() * frame_scale
	draw_texture_rect(frame, Rect2(pivot - FRAME_BEARING * frame_scale, fsz), false)
	# Balken: Bild gespiegelt (Kopf links über dem Amboss), Drehpunkt im Lagerloch
	var ang := 0.25 * (1.0 - drop)
	draw_set_transform(pivot, ang, Vector2(-beam_scale, beam_scale))
	draw_texture(beam, -BEAM_PIVOT)
	draw_set_transform(Vector2.ZERO)
	if water_powered:
		# Wasserstand rechts am Bühnenrand
		var gauge := Rect2(1040.0 - position.x, strike_y - 210.0, 20, 150)
		draw_rect(gauge, Color(0.1, 0.1, 0.1, 0.65))
		var h := gauge.size.y * clampf(water_level, 0.0, 1.0)
		draw_rect(Rect2(gauge.position.x, gauge.end.y - h, gauge.size.x, h), Color(0.3, 0.55, 0.8))
		draw_string(Assets.ui_font(), Vector2(gauge.position.x - 60, gauge.end.y + 32), "%d %%" % int(round(water_level * 100.0)), HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color("e9dcc0"))
	return true


func has_user_parts() -> bool:
	return Assets.user("machine_helve_beam.png") != null and Assets.user("machine_helve_frame.png") != null


# ------------------------------------------------------------------ Dampfhammer

## Dampfhammer über dem Amboss: Grafikteile des Auftraggebers (machine_steam_hammer_*.png), sonst im Code
## gezeichnet. Gestell mit zwei Ständern und Zylinder, Bär an der Kolbenstange fällt auf die Bahn.
func _draw_steam_hammer() -> void:
	# k: Breite (großer Hammer breiter); die Höhe bleibt, damit der Zylinder die Esse nicht verdeckt
	var k := 1.25 if large else 1.0
	var cx := head_x
	var base := strike_y + 276.0
	var top := strike_y - 200.0
	var lift: float = RAM_LIFT[clampi(force_level, 0, 2)]
	var ram_bottom := strike_y - lift * (1.0 - drop)
	var frame_t := Assets.user("machine_steam_hammer_large_frame.png" if large else "machine_steam_hammer_frame.png")
	if frame_t == null:
		frame_t = Assets.user("machine_steam_hammer_frame.png")
	var ram_t := Assets.user("machine_steam_hammer_ram.png")
	if frame_t != null and ram_t != null:
		# Gestell: Unterkante auf dem Boden, Mitte über dem Amboss
		var fh := base - (top - 130.0)
		var fw := fh * frame_t.get_width() / frame_t.get_height()
		draw_texture_rect(frame_t, Rect2(cx - fw * 0.5, base - fh, fw, fh), false)
		# Bär: so breit wie der Hammerblock; von der Kolbenstange nur der Teil unterhalb des Zylinders
		var rw := 150.0 * k
		var rs := rw / float(ram_t.get_width())
		var vis := minf(float(ram_t.get_height()) * rs, ram_bottom - (top - 40.0))
		var src_h := vis / rs
		draw_texture_rect_region(ram_t, Rect2(cx - rw * 0.5, ram_bottom - vis, rw, vis),
			Rect2(0.0, float(ram_t.get_height()) - src_h, float(ram_t.get_width()), src_h))
		_draw_steam_puffs(Vector2(cx + 70.0 * k, top - 120.0 * k))
		return
	var iron := Color("34363b")
	var iron_hi := Color("5b5f66")
	var line := Color("15161a")
	# Ständer (A-förmig) links und rechts
	for side_i in 2:
		var side: float = -1.0 if side_i == 0 else 1.0
		var outer: float = cx + side * 300.0 * k
		var inner: float = cx + side * 190.0 * k
		var pts := PackedVector2Array([
			Vector2(outer, base), Vector2(outer - side * 70.0 * k, base), Vector2(inner + side * 10.0 * k, top), Vector2(inner + side * 55.0 * k, top)])
		draw_colored_polygon(pts, iron)
		pts.append(pts[0])
		draw_polyline(pts, line, 3.0, true)
		draw_line(Vector2(outer - side * 35.0 * k, base - 10.0), Vector2(inner + side * 32.0 * k, top + 10.0), iron_hi, 4.0)
		# Fußplatte
		draw_rect(Rect2(outer - (60.0 if side > 0 else 30.0) * k, base - 14.0, 100.0 * k, 14.0), Color("26272b"))
	# Querhaupt und Zylinder
	draw_rect(Rect2(cx - 250.0 * k, top - 36.0 * k, 500.0 * k, 40.0 * k), iron)
	draw_rect(Rect2(cx - 250.0 * k, top - 36.0 * k, 500.0 * k, 40.0 * k), line, false, 3.0)
	var cyl := Rect2(cx - 62.0 * k, top - 130.0, 124.0 * k, 96.0)
	draw_rect(cyl, Color("3d4046"))
	draw_rect(Rect2(cyl.position.x + 12.0 * k, cyl.position.y, 22.0 * k, cyl.size.y), Color("5d6168"))
	for fy: float in [cyl.position.y, cyl.position.y + cyl.size.y * 0.5, cyl.end.y - 10.0 * k]:
		draw_rect(Rect2(cyl.position.x - 8.0 * k, fy, cyl.size.x + 16.0 * k, 10.0 * k), Color("2a2c30"))
	draw_rect(cyl, line, false, 3.0)
	# Ventilkasten mit Steuerhebel
	draw_rect(Rect2(cyl.end.x + 6.0 * k, cyl.position.y + 30.0 * k, 34.0 * k, 50.0 * k), Color("4a3a2a"))
	draw_line(Vector2(cyl.end.x + 40.0 * k, cyl.position.y + 40.0 * k), Vector2(cyl.end.x + 120.0 * k, top + 80.0 * k), Color("6b5a3a"), 6.0)
	draw_circle(Vector2(cyl.end.x + 120.0 * k, top + 80.0 * k), 9.0 * k, Color("b08d57"))
	# Führungen
	for gx: float in [cx - 92.0 * k, cx + 92.0 * k]:
		draw_rect(Rect2(gx - 7.0 * k, top + 4.0, 14.0 * k, strike_y - top + 10.0), Color("2c2e33"))
	# Kolbenstange und Bär
	var ram_h := 112.0
	draw_rect(Rect2(cx - 11.0 * k, top - 34.0 * k, 22.0 * k, ram_bottom - ram_h - top + 34.0 * k), Color("8a8f97"))
	var ram := Rect2(cx - 80.0 * k, ram_bottom - ram_h, 160.0 * k, ram_h)
	draw_rect(ram, iron)
	draw_rect(Rect2(ram.position.x + 8.0, ram.position.y + 6.0, 18.0 * k, ram.size.y - 12.0), iron_hi)
	draw_rect(Rect2(ram.position.x - 6.0 * k, ram.end.y - 22.0 * k, ram.size.x + 12.0 * k, 22.0 * k), Color("4a4d54"))
	draw_rect(ram, line, false, 3.0)
	_draw_steam_puffs(Vector2(cyl.position.x + 20.0 * k, cyl.position.y))


func _draw_steam_puffs(origin: Vector2) -> void:
	if not running:
		return
	for k in 3:
		var sp := origin + Vector2(-10.0 * k, -20.0 - k * 26.0 - fmod(_wheel * 40.0, 26.0))
		draw_circle(sp, 14.0 + k * 7.0, Color(0.92, 0.92, 0.94, 0.28))
