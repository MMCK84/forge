extends Control
## Amboss auf Holzklotz. Drücken/Tippen = Hammerschlag (hold_started/hold_ended für Halten-Modus).

const Assets = preload("res://scripts/assets.gd")

signal anvil_pressed()
signal anvil_released()

var swing: float = 0.0
var has_piece: bool = false
var big: bool = false
## Ausgerüsteter Handhammer; gibt es dazu eine Grafik des Auftraggebers, schwingt diese.
var hammer_id: String = ""
## Handhammer ausblenden, wenn ein Schwanzhammer auf den Amboss schlägt
var hand_hammer_visible: bool = true
## Unter dem Dampfhammer steht statt des Ambosses die Schabotte (wenn die Grafik vorhanden ist)
var schabotte: bool = false
## Schlagstärke des letzten Schlags (0 leicht … 2 schwer): bestimmt die Ausholweite
var force_level: int = 1
const FORCE_SWING := [0.55, 1.0, 1.6]
## Hammergrafiken des Auftraggebers in reiner Seitenansicht (Kopf links senkrecht, Bahn unten,
## Stiel waagerecht nach rechts): Griffpunkt am Stielende, Mitte der Bahn, Richtung der
## Kopfachse zur Bahn (90° = nach unten). Beim Schlag sitzt die Bahn flach auf dem Werkstück.
const UserToolMeta = preload("res://scripts/user_tool_meta.gd")
const USER_HAMMERS: Dictionary = UserToolMeta.HAMMERS
const USER_HAMMER_SCALE := 0.62
## Ausholwinkel (Bogenmaß) zwischen Schlag und angehobenem Hammer
const USER_HAMMER_RAISE := 0.55


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
		var block_t := Assets.user("machine_steam_hammer_anvil.png") if schabotte else null
		if block_t != null:
			# Schabotte: Oberkante (Gesenk) auf Höhe der Ambossbahn, Unterkante auf dem Boden
			var bh := 276.0
			var bw := bh * block_t.get_width() / block_t.get_height()
			draw_texture_rect(block_t, Rect2(rest_point().x - bw * 0.5, 137.0, bw, bh), false)
		elif user_t != null:
			# Amboss des Auftraggebers: Bahnmitte über der Ablage, Bahnoberkante bei y ≈ 137 (Werkstück liegt bei 138);
			# die Maße misst der Import (scripts/user_tool_meta.gd)
			var face: Vector2 = UserToolMeta.ANVIL.get("face", Vector2(153, 3))
			draw_texture(user_t, Vector2(rest_point().x - face.x, 137.0 - face.y))
		else:
			draw_texture(anvil_t, Vector2(-10, -10))
		# Handhammer: liegt beim Schlag auf (swing = 1) und hebt sich wieder (swing → 0)
		if not hand_hammer_visible:
			return
		var pivot := Vector2(cx + 176, 108)
		var ang := 0.55 * (1.0 - swing) + 0.05
		var user_h := Assets.user(hammer_id + ".png") if hammer_id != "" else null
		if user_h != null:
			var spec: Array = USER_HAMMERS.get(hammer_id, [Vector2(340, 88), Vector2(38, 175), 90.0])
			var grip: Vector2 = spec[0]
			var face: Vector2 = spec[1]
			var base := deg_to_rad(90.0 - float(spec[2]))
			var k := USER_HAMMER_SCALE
			# Drehpunkt (Hand) so, dass die Bahn beim Schlag genau auf dem Werkstück sitzt
			var hand := Vector2(cx, 126.0) - (face - grip).rotated(base) * k
			# Ohne Werkstück liegt der Hammer auf der Ambossbahn, mit Werkstück ist er zum Schlag erhoben
			var raise := (1.0 - swing) if has_piece else 0.0
			draw_set_transform(hand, base + USER_HAMMER_RAISE * FORCE_SWING[clampi(force_level, 0, 2)] * raise, Vector2(k, k))
			draw_texture(user_h, -grip)
		else:
			draw_set_transform(pivot, ang, Vector2.ONE)
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
