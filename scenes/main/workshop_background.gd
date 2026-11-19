extends Control
## Werkstatt-Hintergrund je Epoche (6 Hintergründe). Nutzt die gerenderten Bilder
## (assets/sprites/environment/background_N.jpg); ohne sie wird im Code gezeichnet.

const Assets = preload("res://scripts/assets.gd")

var epoch: int = 1
var reputation_level: int = 1
var stage_offset: Vector2 = Vector2.ZERO

const WALLS := [Color("4a3a2c"), Color("54402e"), Color("3e4448"), Color("4e3f3a"), Color("3f3a33"), Color("5a3a30")]
const FLOORS := [Color("2e2218"), Color("33261b"), Color("2a2a28"), Color("2f2620"), Color("29251f"), Color("2b211c")]


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_epoch(e: int, rep: int) -> void:
	epoch = clampi(e, 1, 6)
	reputation_level = rep
	queue_redraw()


func _draw() -> void:
	var tex := Assets.background(epoch)
	if tex != null:
		# Ränder (Ultrabreit/4:3) mit gedimmtem, gestrecktem Bild füllen, dann exakt zur Bühne ausgerichtet zeichnen.
		draw_texture_rect(tex, Rect2(Vector2.ZERO, size), false, Color(0.55, 0.5, 0.45))
		draw_texture_rect(tex, Rect2(stage_offset, Vector2(1920, 1080)), false)
		_draw_reputation_sign()
		return
	var r := get_rect()
	var wall: Color = WALLS[epoch - 1]
	var floor_c: Color = FLOORS[epoch - 1]
	var o := stage_offset
	var floor_y := o.y + 700.0
	draw_rect(Rect2(0, 0, r.size.x, floor_y), wall)
	draw_rect(Rect2(0, floor_y, r.size.x, r.size.y - floor_y), floor_c)
	# Wandstruktur: Bretter (Ep. 1–2), Steine (3–4), Ziegel (5–6)
	if epoch <= 2:
		var x := 0.0
		while x < r.size.x:
			draw_line(Vector2(x, 0), Vector2(x, floor_y), wall.darkened(0.2), 3.0)
			x += 90.0
	else:
		var row := 0
		var y := 0.0
		var bw := 120.0 if epoch <= 4 else 80.0
		var bh := 60.0 if epoch <= 4 else 36.0
		while y < floor_y:
			var x2 := -bw * 0.5 * (row % 2)
			while x2 < r.size.x:
				draw_rect(Rect2(x2, y, bw, bh), wall.darkened(0.25), false, 2.0)
				x2 += bw
			y += bh
			row += 1
	# Bodendielen
	var fx := 0.0
	while fx < r.size.x:
		draw_line(Vector2(fx, floor_y), Vector2(fx - 120, r.size.y), floor_c.lightened(0.06), 2.0)
		fx += 160.0
	# Fenster mit epochentypischem Ausblick
	var win := Rect2(o.x + 470, o.y + 110, 260, 180)
	if epoch >= 3:
		win = Rect2(o.x + 450, o.y + 105, 300, 190)
	_draw_window(win)
	# Werkzeugregal links
	draw_rect(Rect2(o.x + 20, o.y + 130, 8, 300), Color("2a1d14"))
	for k in 4:
		var tx := o.x + 836 + k * 22
		draw_line(Vector2(tx, o.y + 140), Vector2(tx, o.y + 260), Color("6d6f73"), 6.0)
		draw_rect(Rect2(tx - 10, o.y + 128, 20, 16), Color("4a3524"))
	draw_rect(Rect2(o.x + 820, o.y + 125, 110, 8), Color("2a1d14"))
	# Epochen-Details
	match epoch:
		2:
			_draw_sign(Vector2(o.x + 1700, o.y + 120), "POST")
		3:
			_draw_rope(Vector2(o.x + 1650, o.y + 100))
		4:
			for k in 3:
				draw_rect(Rect2(o.x + 1620 + k * 70, o.y + 250, 60, 90), [Color("6a3a4a"), Color("3a5a6a"), Color("7a6a3a")][k])
		6:
			draw_rect(Rect2(0, o.y + 70, r.size.x, 22), Color("2b2b2e"))
			for k in int(r.size.x / 200.0) + 1:
				draw_circle(Vector2(k * 200 + 40, o.y + 81), 5, Color("55585e"))
	_draw_reputation_sign()


## Zunftschild je nach Ruf (kosmetische Belohnung)
func _draw_reputation_sign() -> void:
	var o := stage_offset
	if reputation_level >= 2:
		var sp := Vector2(o.x + 1500, o.y + 150)
		draw_rect(Rect2(sp.x - 70, sp.y, 140, 70), Color("6b4a2f"))
		draw_rect(Rect2(sp.x - 70, sp.y, 140, 70), Color("b08d57"), false, 4.0)
		for k in mini(reputation_level, 5):
			draw_circle(Vector2(sp.x - 48 + k * 24, sp.y + 35), 8, Color("e8b54a"))


func _draw_window(win: Rect2) -> void:
	var sky := Color("8fb3c9") if epoch < 5 else Color("8a8f94")
	draw_rect(win, sky)
	var ground_y := win.position.y + win.size.y * 0.65
	match epoch:
		1:
			draw_rect(Rect2(win.position.x, ground_y, win.size.x, win.size.y * 0.35), Color("5d8a3f"))
			draw_circle(Vector2(win.position.x + 70, ground_y), 30, Color("3f6a2f"))
		2:
			draw_rect(Rect2(win.position.x, ground_y, win.size.x, win.size.y * 0.35), Color("7a8a4f"))
			draw_rect(Rect2(win.position.x, ground_y + 20, win.size.x, 20), Color("9a8a6a"))
			draw_rect(Rect2(win.position.x + 150, ground_y - 5, 60, 30), Color("5a2a1a"))
			draw_circle(Vector2(win.position.x + 160, ground_y + 28), 12, Color("2a1a10"))
			draw_circle(Vector2(win.position.x + 200, ground_y + 28), 12, Color("2a1a10"))
		3:
			draw_rect(Rect2(win.position.x, ground_y, win.size.x, win.size.y * 0.35), Color("3d6a8a"))
			for k in 2:
				var mx := win.position.x + 80 + k * 120
				draw_line(Vector2(mx, ground_y), Vector2(mx, win.position.y + 20), Color("3a2a1a"), 5.0)
				draw_colored_polygon(PackedVector2Array([Vector2(mx + 4, win.position.y + 30), Vector2(mx + 50, ground_y - 30), Vector2(mx + 4, ground_y - 20)]), Color("e8e0cc"))
		4:
			draw_rect(Rect2(win.position.x, ground_y, win.size.x, win.size.y * 0.35), Color("6a7a5a"))
			draw_rect(Rect2(win.position.x + 40, ground_y - 60, 90, 60), Color("7a5a4a"))
			draw_rect(Rect2(win.position.x + 170, ground_y - 80, 70, 80), Color("6a4a3a"))
		5:
			draw_rect(Rect2(win.position.x, ground_y, win.size.x, win.size.y * 0.35), Color("4a5a4a"))
			draw_rect(Rect2(win.position.x + 30, ground_y + 15, win.size.x - 60, 18), Color("4a7a9a"))
		6:
			draw_rect(Rect2(win.position.x, ground_y, win.size.x, win.size.y * 0.35), Color("3a3a3a"))
			for k in 3:
				var cx := win.position.x + 50 + k * 90
				draw_rect(Rect2(cx, ground_y - 90, 26, 90), Color("5a3a2a"))
				draw_circle(Vector2(cx + 13, ground_y - 100), 18, Color(0.5, 0.5, 0.5, 0.6))
	draw_rect(win, Color("2a1d14"), false, 10.0)
	draw_line(Vector2(win.position.x + win.size.x * 0.5, win.position.y), Vector2(win.position.x + win.size.x * 0.5, win.end.y), Color("2a1d14"), 6.0)
	draw_line(Vector2(win.position.x, win.position.y + win.size.y * 0.5), Vector2(win.end.x, win.position.y + win.size.y * 0.5), Color("2a1d14"), 6.0)


func _draw_sign(p: Vector2, text: String) -> void:
	draw_rect(Rect2(p.x - 60, p.y, 120, 50), Color("2f4f7a"))
	draw_string(ThemeDB.fallback_font, p + Vector2(-40, 36), text, HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("e9dcc0"))


func _draw_rope(p: Vector2) -> void:
	for k in 4:
		draw_arc(p + Vector2(0, 20 + k * 14), 50, 0, PI, 20, Color("a08050"), 6.0)
