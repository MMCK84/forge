extends Control
## Schwanzhammer über dem Amboss mit Antrieb (Wasserrad oder Dampfmaschine).

var machine_id: String = ""
var water_powered: bool = false
var water_level: float = 1.0
var drop: float = 0.0
var running: bool = false
var _wheel: float = 0.0
## Position des Hammerkopfs über dem Amboss (lokal)
var head_x: float = 300.0


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
	var pivot := Vector2(size.x - 330, 130)
	var head := Vector2(head_x, 110 + 210 * drop)
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
		var gauge := Rect2(size.x - 40, 40, 22, 200)
		draw_rect(gauge, Color(0.1, 0.1, 0.1, 0.6))
		var h := gauge.size.y * clampf(water_level, 0.0, 1.0)
		draw_rect(Rect2(gauge.position.x, gauge.end.y - h, gauge.size.x, h), Color(0.3, 0.55, 0.8))
		draw_string(ThemeDB.fallback_font, Vector2(gauge.position.x - 40, gauge.end.y + 28), "%d %%" % int(round(water_level * 100.0)), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("e9dcc0"))
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
