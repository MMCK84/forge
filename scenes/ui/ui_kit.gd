extends RefCounted
## Gemeinsame UI-Bausteine und das Werkstatt-Theme (Messing, Pergament, Holz, Leder).
## Nutzt die gerenderten UI-Texturen und Schriften aus assets/, sonst flache Stile.

const Assets = preload("res://scripts/assets.gd")

const PARCHMENT := Color("e9dcc0")
const PARCHMENT_DARK := Color("d6c39c")
const INK := Color("3a2a1a")
const INK_LIGHT := Color("6b5640")
const BRASS := Color("b08d57")
const BRASS_LIGHT := Color("d9b77a")
const WOOD := Color("3b2a1e")
const WOOD_LIGHT := Color("5a4030")
const LEATHER := Color("6b4a2f")
const RED := Color("8c2f1f")
const GREEN := Color("4f6b2f")
const TEXT_LIGHT := Color("f3e7cf")
const GOLD := Color("e8b54a")

## Nutzbare Inhaltsbreite in Fenstern (Hochformat 720 px minus Rand und Pergament)
const CW := 580.0
## Fensterbreite im Hochformat
const PANEL_W := 696.0

static var _theme: Theme = null


static func _box(bg: Color, border: Color, border_w: int = 3, radius: int = 10, margin: int = 14) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = border
	sb.set_border_width_all(border_w)
	sb.set_corner_radius_all(radius)
	sb.content_margin_left = margin
	sb.content_margin_right = margin
	sb.content_margin_top = margin * 0.6
	sb.content_margin_bottom = margin * 0.6
	sb.shadow_color = Color(0, 0, 0, 0.25)
	sb.shadow_size = 4
	return sb


static func _tex_box(rel: String, margin: float, content_h: float, content_v: float) -> StyleBoxTexture:
	var tex := Assets.tex(rel)
	if tex == null:
		return null
	var sb := StyleBoxTexture.new()
	sb.texture = tex
	sb.texture_margin_left = margin
	sb.texture_margin_right = margin
	sb.texture_margin_top = margin
	sb.texture_margin_bottom = margin
	sb.content_margin_left = content_h
	sb.content_margin_right = content_h
	sb.content_margin_top = content_v
	sb.content_margin_bottom = content_v
	return sb


static func heading_font() -> Font:
	return Assets.font("IMFellEnglishSC.ttf")


static func theme() -> Theme:
	if _theme != null:
		return _theme
	var t := Theme.new()
	t.default_font_size = 26
	var body_font := Assets.font("EBGaramond.ttf")
	if body_font != null:
		t.default_font = body_font
		t.default_font_size = 28
	# Buttons: Holz mit Messingrand
	t.set_stylebox("normal", "Button", _box(WOOD_LIGHT, BRASS, 3, 10, 18))
	t.set_stylebox("hover", "Button", _box(LEATHER, BRASS_LIGHT, 3, 10, 18))
	t.set_stylebox("pressed", "Button", _box(WOOD, BRASS_LIGHT, 3, 10, 18))
	t.set_stylebox("disabled", "Button", _box(Color("4a4038"), Color("6d6250"), 3, 10, 18))
	var focus := _box(Color(0, 0, 0, 0), GOLD, 3, 10, 18)
	focus.draw_center = false
	t.set_stylebox("focus", "Button", focus)
	t.set_color("font_color", "Button", TEXT_LIGHT)
	t.set_color("font_hover_color", "Button", Color.WHITE)
	t.set_color("font_pressed_color", "Button", BRASS_LIGHT)
	t.set_color("font_disabled_color", "Button", Color("9d9384"))
	t.set_color("font_focus_color", "Button", Color.WHITE)
	for st in ["normal", "hover", "pressed", "disabled"]:
		var sb := _tex_box("ui/user/btn_%s.png" % st, 20.0, 24.0, 10.0)
		if sb == null:
			sb = _tex_box("ui/button_%s.png" % st, 16.0, 20.0, 8.0)
		if sb != null:
			t.set_stylebox(st, "Button", sb)
			t.set_stylebox(st, "OptionButton", sb)
	t.set_constant("h_separation", "Button", 8)
	# Panels: Pergament
	t.set_stylebox("panel", "PanelContainer", _box(PARCHMENT, BRASS, 4, 12, 24))
	t.set_stylebox("panel", "Panel", _box(PARCHMENT, BRASS, 4, 12, 24))
	var parch := _tex_box("ui/user/panel_parchment_m.png", 66.0, 46.0, 38.0)
	if parch == null:
		parch = _tex_box("ui/parchment.png", 40.0, 30.0, 24.0)
	if parch != null:
		t.set_stylebox("panel", "PanelContainer", parch)
		t.set_stylebox("panel", "Panel", parch)
		t.set_stylebox("panel", "PopupMenu", parch)
		t.set_stylebox("panel", "TooltipPanel", parch)
	t.set_color("font_color", "Label", INK)
	t.set_color("default_color", "RichTextLabel", INK)
	t.set_font_size("normal_font_size", "RichTextLabel", 24)
	t.set_font_size("bold_font_size", "RichTextLabel", 24)
	# Fortschrittsbalken
	t.set_stylebox("background", "ProgressBar", _box(Color("2a1f17"), BRASS, 2, 6, 0))
	t.set_stylebox("fill", "ProgressBar", _box(Color("c8762a"), Color("c8762a"), 0, 6, 0))
	t.set_color("font_color", "ProgressBar", TEXT_LIGHT)
	# Schieberegler / Checkboxen
	t.set_color("font_color", "CheckBox", INK)
	t.set_color("font_hover_color", "CheckBox", INK)
	t.set_color("font_pressed_color", "CheckBox", INK)
	t.set_color("font_hover_pressed_color", "CheckBox", INK)
	t.set_color("font_focus_color", "CheckBox", INK)
	var empty := StyleBoxEmpty.new()
	t.set_stylebox("normal", "CheckBox", empty)
	t.set_stylebox("hover", "CheckBox", empty)
	t.set_stylebox("pressed", "CheckBox", empty)
	t.set_stylebox("hover_pressed", "CheckBox", empty)
	t.set_stylebox("focus", "CheckBox", focus)
	t.set_stylebox("slider", "HSlider", _box(Color("8a7656"), Color("8a7656"), 0, 4, 4))
	t.set_stylebox("grabber_area", "HSlider", _box(BRASS, BRASS, 0, 4, 4))
	t.set_stylebox("grabber_area_highlight", "HSlider", _box(BRASS_LIGHT, BRASS_LIGHT, 0, 4, 4))
	t.set_stylebox("normal", "OptionButton", _box(WOOD_LIGHT, BRASS, 3, 10, 18))
	t.set_stylebox("hover", "OptionButton", _box(LEATHER, BRASS_LIGHT, 3, 10, 18))
	t.set_stylebox("pressed", "OptionButton", _box(WOOD, BRASS_LIGHT, 3, 10, 18))
	t.set_color("font_color", "OptionButton", TEXT_LIGHT)
	t.set_stylebox("panel", "PopupMenu", _box(PARCHMENT, BRASS, 3, 8, 10))
	t.set_color("font_color", "PopupMenu", INK)
	t.set_color("font_hover_color", "PopupMenu", Color.BLACK)
	t.set_stylebox("hover", "PopupMenu", _box(PARCHMENT_DARK, PARCHMENT_DARK, 0, 4, 6))
	t.set_stylebox("panel", "TooltipPanel", _box(PARCHMENT, BRASS, 2, 6, 10))
	t.set_color("font_color", "TooltipLabel", INK)
	t.set_stylebox("separator", "HSeparator", _box(BRASS, BRASS, 0, 0, 0))
	t.set_constant("separation", "HSeparator", 12)
	t.set_constant("separation", "VBoxContainer", 10)
	t.set_constant("separation", "HBoxContainer", 12)
	_theme = t
	return t


static func label(text: String, size: int = 26, color: Color = INK, align: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.horizontal_alignment = align
	return l


static func wrap_label(text: String, size: int = 24, color: Color = INK, min_width: float = 400.0) -> Label:
	var l := label(text, size, color)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = min_width
	return l


static func button(text: String, callback: Callable, min_size: Vector2 = Vector2(0, 64), font_size: int = 26) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = min_size
	b.add_theme_font_size_override("font_size", font_size)
	b.focus_mode = Control.FOCUS_ALL
	b.pressed.connect(func() -> void: _click_sound())
	if callback.is_valid():
		b.pressed.connect(callback)
	return b


static func _click_sound() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return
	var sm = tree.root.get_node_or_null("SoundManager")
	if sm != null:
		sm.ui_click()


static func hsep() -> HSeparator:
	return HSeparator.new()


## Sterne als gezeichnete Polygone (unabhängig von Schrift-Glyphen).
static func stars_view(stars: int, size: float = 40.0) -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(size * 3.3, size)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.draw.connect(func() -> void: draw_stars(c, Vector2(size * 0.5, size * 0.5), stars, size))
	return c


static func draw_stars(ci: CanvasItem, origin: Vector2, stars: int, size: float) -> void:
	var full := Assets.tex("ui/star_full.png")
	var empty := Assets.tex("ui/star_empty.png")
	if full != null and empty != null:
		for i in 3:
			var c := origin + Vector2(i * size * 1.1, 0)
			ci.draw_texture_rect(full if i < stars else empty, Rect2(c - Vector2(size, size) * 0.55, Vector2(size, size) * 1.1), false)
		return
	for i in 3:
		var center := origin + Vector2(i * size * 1.1, 0)
		var pts := PackedVector2Array()
		for k in 10:
			var r := size * (0.5 if k % 2 == 0 else 0.22)
			var ang := -PI / 2.0 + k * PI / 5.0
			pts.append(center + Vector2(cos(ang), sin(ang)) * r)
		var filled := i < stars
		ci.draw_colored_polygon(pts, GOLD if filled else Color(0.35, 0.3, 0.25, 0.35))
		pts.append(pts[0])
		ci.draw_polyline(pts, INK if filled else Color(0.45, 0.38, 0.3), 2.0, true)


static func panel_box(bg: Color, border: Color, border_w: int = 3, radius: int = 10, margin: int = 14) -> StyleBoxFlat:
	return _box(bg, border, border_w, radius, margin)


static func icon(rel: String, size: float) -> Control:
	var tex := Assets.tex(rel)
	if tex == null:
		var c := Control.new()
		c.custom_minimum_size = Vector2.ZERO
		return c
	var r := TextureRect.new()
	r.texture = tex
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	r.custom_minimum_size = Vector2(size, size)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


## Leder-Leiste für HUD-Balken (oder flacher Stil).
static func bar_box() -> StyleBox:
	var sb := _tex_box("ui/user/hud_bar.png", 24.0, 22.0, 10.0)
	if sb == null:
		sb = _tex_box("ui/leather_bar.png", 12.0, 12.0, 8.0)
	if sb != null:
		return sb
	return _box(Color(0.16, 0.11, 0.08, 0.92), BRASS, 0, 0, 12)
