extends Control
## Hauptmenü (6.3): Fortsetzen, Neues Spiel (mit Warnung), Einstellungen, Mitwirkende, Beenden (nur Desktop).

const UIKit = preload("res://scenes/ui/ui_kit.gd")
const Assets = preload("res://scripts/assets.gd")
const Background = preload("res://scenes/main/workshop_background.gd")

signal start_game()

var _overlay_layer: Control
var _notice: Label
var _locale: String = ""
var _needs_rebuild: bool = false


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = UIKit.theme()
	_locale = TranslationServer.get_locale()
	var title_art := Assets.user("title_art.png")
	if title_art != null:
		# Titelbild des Auftraggebers füllt den Bildschirm (Hochformat: mittlerer Ausschnitt)
		var art := TextureRect.new()
		art.texture = title_art
		art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		art.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(art)
	else:
		var bg := Background.new()
		add_child(bg)
		bg.set_epoch(1, 1)
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.25 if title_art != null else 0.45)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 18)
	center.add_child(col)
	var title_tex := Assets.tex("ui/title.png")
	if title_tex != null:
		var tr_title := TextureRect.new()
		tr_title.texture = title_tex
		tr_title.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr_title.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		var tw := minf(660.0, float(title_tex.get_width()))
		tr_title.custom_minimum_size = Vector2(tw, tw * title_tex.get_height() / title_tex.get_width())
		col.add_child(tr_title)
	else:
		var title := UIKit.label(tr("GAME_TITLE"), 72, UIKit.GOLD, HORIZONTAL_ALIGNMENT_CENTER)
		title.add_theme_color_override("font_outline_color", Color(0.1, 0.06, 0.03))
		title.add_theme_constant_override("outline_size", 12)
		col.add_child(title)
	var sub_l := UIKit.wrap_label(tr("GAME_SUBTITLE"), 26, UIKit.TEXT_LIGHT, 640.0)
	sub_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_l.add_theme_color_override("font_outline_color", Color(0.1, 0.06, 0.03))
	sub_l.add_theme_constant_override("outline_size", 6)
	col.add_child(sub_l)
	var spacer := Control.new()
	spacer.custom_minimum_size.y = 30
	col.add_child(spacer)
	var has_save := SaveManager.has_save()
	var cont := UIKit.button(tr("UI_CONTINUE_GAME"), _continue, Vector2(520, 76), 30)
	cont.disabled = not has_save
	col.add_child(cont)
	col.add_child(UIKit.button(tr("UI_NEW_GAME"), _new_game, Vector2(520, 76), 30))
	col.add_child(UIKit.button(tr("UI_SETTINGS"), _open.bind("res://scenes/ui/settings_panel.gd"), Vector2(520, 76), 30))
	col.add_child(UIKit.button(tr("UI_CREDITS"), _open.bind("res://scenes/ui/credits_panel.gd"), Vector2(520, 76), 30))
	if not OS.has_feature("web") and not OS.has_feature("mobile"):
		col.add_child(UIKit.button(tr("UI_QUIT"), _quit, Vector2(520, 76), 30))
	if GameManager.test_tools_enabled():
		col.add_child(UIKit.button(tr("TEST_TITLE") + " [F12]", _open_test_menu, Vector2(520, 60), 24))
	_notice = UIKit.wrap_label("", 24, UIKit.TEXT_LIGHT, 520.0)
	_notice.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(_notice)
	col.add_child(UIKit.label("v" + GameManager.GAME_VERSION, 18, Color(1, 1, 1, 0.5), HORIZONTAL_ALIGNMENT_CENTER))
	_overlay_layer = Control.new()
	_overlay_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_overlay_layer)
	GameManager.settings_changed.connect(_on_settings_changed)
	SaveManager.imported.connect(_on_imported)
	if has_save:
		cont.grab_focus.call_deferred()
	# Musik erst nach dem ersten Bild erzeugen, damit das Menü sofort erscheint.
	get_tree().create_timer(0.3).timeout.connect(_start_menu_music)


func _start_menu_music() -> void:
	if is_inside_tree() and not GameManager.in_game:
		SoundManager.play_music_for_epoch(0)


func show_notice(key: String) -> void:
	_notice.text = tr(key)


func _open(path: String) -> void:
	var p = load(path).new()
	_overlay_layer.add_child(p)


func _continue() -> void:
	if SaveManager.load_game():
		start_game.emit()
		return
	match SaveManager.last_load_status:
		"newer":
			show_notice("UI_SAVE_NEWER")
		_:
			show_notice("UI_SAVE_CORRUPT")


func _new_game() -> void:
	if SaveManager.has_save():
		var p = load("res://scenes/ui/info_panel.gd").new()
		p.setup("UI_NEW_GAME", tr("UI_NEW_GAME_WARNING"), [[tr("UI_CANCEL"), Callable()], [tr("UI_NEW_GAME"), _start_new]])
		_overlay_layer.add_child(p)
	else:
		_start_new()


func _start_new() -> void:
	SaveManager.start_new_game()
	start_game.emit()


func _quit() -> void:
	get_tree().quit()


func _on_settings_changed() -> void:
	# Nur bei geänderter Sprache neu aufbauen (nicht während ein Spielstand geladen wird).
	if GameManager.in_game or TranslationServer.get_locale() == _locale:
		return
	_locale = TranslationServer.get_locale()
	_needs_rebuild = true


func _process(_delta: float) -> void:
	if _needs_rebuild and _overlay_layer.get_child_count() == 0:
		_needs_rebuild = false
		_rebuild.call_deferred()


func _rebuild() -> void:
	if GameManager.in_game or is_queued_for_deletion():
		return
	var parent := get_parent()
	if parent != null and parent.has_method("show_main_menu"):
		parent.call("show_main_menu")


func _on_imported(ok: bool) -> void:
	if ok and GameManager.in_game:
		start_game.emit()
	elif not ok:
		show_notice("UI_IMPORT_FAILED")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test_menu") and GameManager.test_tools_enabled() and _overlay_layer.get_child_count() == 0:
		get_viewport().set_input_as_handled()
		_open_test_menu()


func _open_test_menu() -> void:
	var p = load("res://scenes/ui/test_panel.gd").new()
	p.game_started.connect(func() -> void: start_game.emit())
	_overlay_layer.add_child(p)
