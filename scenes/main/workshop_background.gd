extends Control
## Werkstatt-Hintergrund je Epoche im Hochformat. Gezeichnet wird in Bühnen-Koordinaten
## (1080 × 1920), skaliert und verschoben wie die Werkstatt-Bühne.
## Reihenfolge: Hochformat-Bild des Auftraggebers (ui/user/background_N.jpg) →
## gerendertes Querformat-Bild als Ausschnitt → im Code gezeichnet.

const Assets = preload("res://scripts/assets.gd")

const STAGE := Vector2(1080, 1920)
## Höhe der Wand-Boden-Kante (Bühnen-Koordinaten) in den Hochformat-Bildern je Epoche
const USER_FLOOR_Y := [1053.0, 991.0, 833.0, 867.0, 984.0, 932.0, 812.0, 827.0, 1005.0, 1000.0]
## Wand-Boden-Kante, wenn nur das Querformat-Bild oder der Code-Hintergrund vorhanden ist
const DEFAULT_FLOOR_Y := 800.0

const WALLS := [Color("4a3a2c"), Color("54402e"), Color("3e4448"), Color("4e3f3a"), Color("3f3a33"), Color("5a3a30"), Color("5a5040"), Color("5a3028"), Color("3a3330"), Color("2e2a2a")]
const FLOORS := [Color("2e2218"), Color("33261b"), Color("2a2a28"), Color("2f2620"), Color("29251f"), Color("2b211c"), Color("2c2a24"), Color("26201c"), Color("24221f"), Color("201e1d")]

var epoch: int = 1
var reputation_level: int = 1
## true: Bühne selbst in die eigene Größe einpassen (wie die Werkstatt); false: Werte unten setzen
var auto_fit: bool = true
var stage_offset: Vector2 = Vector2.ZERO
var stage_scale: float = 1.0


func _ready() -> void:
	if auto_fit:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)


func set_epoch(e: int, rep: int) -> void:
	epoch = clampi(e, 1, USER_FLOOR_Y.size())
	reputation_level = rep
	queue_redraw()


## Bühnen-Einpassung für eine Fläche: [Verschiebung, Maßstab] (ganze Bühne sichtbar, mittig).
static func fit(area: Vector2) -> Array:
	var s := minf(area.x / STAGE.x, area.y / STAGE.y)
	return [((area - STAGE * s) * 0.5).floor(), s]


## Wand-Boden-Kante der aktuellen Epoche in Bühnen-Koordinaten.
static func floor_y_for(e: int) -> float:
	if Assets.user("background_%d.jpg" % clampi(e, 1, USER_FLOOR_Y.size())) != null:
		return USER_FLOOR_Y[clampi(e, 1, USER_FLOOR_Y.size()) - 1]
	return DEFAULT_FLOOR_Y


func _draw() -> void:
	if auto_fit:
		var f := fit(size)
		stage_offset = f[0]
		stage_scale = f[1]
	var s := stage_scale
	var o := stage_offset
	var user_tex := Assets.user("background_%d.jpg" % epoch)
	## Breite Fassung (volles 1:1-Bild im selben Maßstab) für breite Fenster bzw. später das Querformat
	var wide_tex := Assets.user("background_%d_wide.jpg" % epoch)
	var land_tex := Assets.background(epoch)
	# Flächen außerhalb der Bühne (breite Fenster am PC, sehr hohe Handys)
	draw_rect(Rect2(Vector2.ZERO, size), FLOORS[epoch - 1].darkened(0.6))
	if user_tex != null:
		_fill_bands(wide_tex if wide_tex != null else user_tex)
	draw_set_transform(o, 0.0, Vector2(s, s))
	if wide_tex != null:
		var ww := float(wide_tex.get_width())
		draw_texture_rect(wide_tex, Rect2((STAGE.x - ww) * 0.5, 0, ww, STAGE.y), false)
	elif user_tex != null:
		draw_texture_rect(user_tex, Rect2(Vector2.ZERO, STAGE), false)
	elif land_tex != null:
		_draw_landscape(land_tex)
	else:
		_draw_code()
	_draw_reputation_sign()
	draw_set_transform(Vector2.ZERO)


## Freie Flächen neben bzw. über/unter der Bühne füllen. Seitlich: das Bild gespiegelt und abgedunkelt
## fortsetzen, mit weichem Übergang (statt einen Randstreifen zu strecken); oben/unten die äußerste Bildzeile.
func _fill_bands(tex: Texture2D) -> void:
	var s := stage_scale
	var o := stage_offset
	var tw := float(tex.get_width())
	var th := float(tex.get_height())
	# Bildfläche in Bildschirm-Koordinaten (das Bild ist ggf. breiter als die Bühne)
	var img := Rect2(o.x + (STAGE.x - tw) * 0.5 * s, o.y, tw * s, STAGE.y * s)
	if o.y > 0.5:
		draw_texture_rect_region(tex, Rect2(img.position.x, 0, img.size.x, o.y), Rect2(0, 0, tw, th * 0.01), Color(0.6, 0.6, 0.6))
		var bottom := o.y + STAGE.y * s
		draw_texture_rect_region(tex, Rect2(img.position.x, bottom, img.size.x, size.y - bottom), Rect2(0, th * 0.99, tw, th * 0.01))
	var dim := Color(0.42, 0.4, 0.38)
	var shade := Color(0, 0, 0, 0.0)
	var dark := Color(0, 0, 0, 0.55)
	var fade_w := minf(img.size.x * 0.25, 160.0)
	if img.position.x > 0.5:
		# links: gespiegelte Kopie direkt links neben dem Bild
		draw_set_transform(Vector2(img.position.x, 0), 0.0, Vector2(-1, 1))
		draw_texture_rect(tex, Rect2(0, img.position.y, img.size.x, img.size.y), false, dim)
		draw_set_transform(Vector2.ZERO)
		var x1 := img.position.x
		draw_polygon(PackedVector2Array([Vector2(maxf(0.0, x1 - fade_w), 0), Vector2(x1, 0), Vector2(x1, size.y), Vector2(maxf(0.0, x1 - fade_w), size.y)]),
			PackedColorArray([dark, shade, shade, dark]))
		draw_rect(Rect2(0, 0, maxf(0.0, x1 - fade_w), size.y), dark)
	if img.end.x < size.x - 0.5:
		draw_set_transform(Vector2(img.end.x + img.size.x, 0), 0.0, Vector2(-1, 1))
		draw_texture_rect(tex, Rect2(0, img.position.y, img.size.x, img.size.y), false, dim)
		draw_set_transform(Vector2.ZERO)
		var x2 := img.end.x
		draw_polygon(PackedVector2Array([Vector2(x2, 0), Vector2(minf(size.x, x2 + fade_w), 0), Vector2(minf(size.x, x2 + fade_w), size.y), Vector2(x2, size.y)]),
			PackedColorArray([shade, dark, dark, shade]))
		draw_rect(Rect2(minf(size.x, x2 + fade_w), 0, size.x, size.y), dark)


## Gerendertes Querformat-Bild: so vergrößern, dass seine Bodenkante (y 700) bei 800 liegt,
## mittig zuschneiden; darunter die unterste Bildzeile als Boden strecken.
func _draw_landscape(tex: Texture2D) -> void:
	var k := DEFAULT_FLOOR_Y / 700.0
	var w := tex.get_width() * k
	var h := tex.get_height() * k
	var x0 := (STAGE.x - w) * 0.5
	draw_texture_rect(tex, Rect2(x0, 0, w, h), false)
	var th := float(tex.get_height())
	draw_texture_rect_region(tex, Rect2(0, h, STAGE.x, STAGE.y - h), Rect2(0, th * 0.98, tex.get_width(), th * 0.02), Color(0.7, 0.7, 0.7))
	draw_rect(Rect2(0, h, STAGE.x, STAGE.y - h), Color(0, 0, 0, 0.35))


func _draw_code() -> void:
	var floor_y := DEFAULT_FLOOR_Y
	draw_rect(Rect2(0, 0, STAGE.x, floor_y), WALLS[epoch - 1])
	draw_rect(Rect2(0, floor_y, STAGE.x, STAGE.y - floor_y), FLOORS[epoch - 1])
	var x := 0.0
	while x < STAGE.x:
		draw_line(Vector2(x, 0), Vector2(x, floor_y), WALLS[epoch - 1].darkened(0.2), 3.0)
		x += 90.0
	var fx := -400.0
	while fx < STAGE.x + 400.0:
		draw_line(Vector2(fx, floor_y), Vector2(fx + (fx - 540.0) * 0.8, STAGE.y), FLOORS[epoch - 1].lightened(0.06), 2.0)
		fx += 160.0
	var win := Rect2(60, 160, 240, 200)
	draw_rect(win, Color("8fb3c9") if epoch < 5 else Color("8a8f94"))
	draw_rect(Rect2(win.position.x, win.position.y + win.size.y * 0.65, win.size.x, win.size.y * 0.35), Color("5d6a4f"))
	draw_rect(win, Color("2a1d14"), false, 10.0)
	# Abdunkeln nach unten (dort liegt das Bedienfeld)
	for k in 8:
		draw_rect(Rect2(0, 1300 + k * 80, STAGE.x, 80), Color(0, 0, 0, 0.08 * k))


## Zunftschild je nach Ruf (kosmetische Belohnung), oben rechts an der Wand
func _draw_reputation_sign() -> void:
	if reputation_level >= 2:
		var sp := Vector2(880, 300)
		draw_rect(Rect2(sp.x - 70, sp.y, 140, 70), Color("6b4a2f"))
		draw_rect(Rect2(sp.x - 70, sp.y, 140, 70), Color("b08d57"), false, 4.0)
		for k in mini(reputation_level, 5):
			draw_circle(Vector2(sp.x - 48 + k * 24, sp.y + 35), 8, Color("e8b54a"))
