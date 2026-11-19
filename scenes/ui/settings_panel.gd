extends "res://scenes/ui/overlay.gd"
## Einstellungen (6.3, 9.2): Lautstärken, Sprache, Temperatur in °C, Halten-Modus,
## Bildschirmwackeln, Blitzeffekte, Vollbild, Tutorial, Spielstand-Export/-Import (7.4).

const Localization = preload("res://scripts/localization.gd")
var _file_dialog: FileDialog


func _init() -> void:
	title_key = "UI_SETTINGS"
	panel_width = 1100.0


func build(box: VBoxContainer) -> void:
	var s: Dictionary = GameManager.settings
	box.add_child(_slider("UI_SFX_VOLUME", float(s.get("sfx_volume", 0.8)), "sfx_volume"))
	box.add_child(_slider("UI_MUSIC_VOLUME", float(s.get("music_volume", 0.6)), "music_volume"))
	var lang_row := HBoxContainer.new()
	var ll := UIKit.label(tr("UI_LANGUAGE"), 24, UIKit.INK)
	ll.custom_minimum_size.x = 270
	lang_row.add_child(ll)
	var opt := OptionButton.new()
	opt.custom_minimum_size = Vector2(290, 60)
	var langs := Localization.languages
	for i in langs.size():
		opt.add_item(tr("LANG_" + langs[i].to_upper()), i)
		if langs[i] == str(s.get("language", "de")):
			opt.select(i)
	opt.item_selected.connect(func(i: int) -> void: _set_lang(langs[i]))
	lang_row.add_child(opt)
	box.add_child(lang_row)
	box.add_child(_check("UI_SHOW_CELSIUS", "show_celsius"))
	box.add_child(_check("UI_HOLD_TO_HAMMER", "hold_to_hammer"))
	box.add_child(_check("UI_SCREEN_SHAKE", "screen_shake"))
	box.add_child(_check("UI_FLASH_EFFECTS", "flash_effects"))
	if not OS.has_feature("web") and not OS.has_feature("mobile"):
		box.add_child(_check("UI_FULLSCREEN", "fullscreen"))
	box.add_child(_check("UI_TUTORIAL", "tutorial"))
	box.add_child(UIKit.hsep())
	var row := HBoxContainer.new()
	row.add_child(UIKit.button(tr("UI_EXPORT_SAVE"), _export, Vector2(280, 60), 22))
	row.add_child(UIKit.button(tr("UI_IMPORT_SAVE"), _import, Vector2(280, 60), 22))
	box.add_child(row)
	box.add_child(UIKit.wrap_label(tr("UI_EXPORT_NOTE"), 20, UIKit.INK_LIGHT, UIKit.CW))


func _slider(key: String, value: float, setting: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	var l := UIKit.label(tr(key), 24, UIKit.INK)
	l.custom_minimum_size.x = 270
	row.add_child(l)
	var sl := HSlider.new()
	sl.min_value = 0.0
	sl.max_value = 1.0
	sl.step = 0.05
	sl.value = value
	sl.custom_minimum_size = Vector2(290, 48)
	sl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sl.value_changed.connect(func(v: float) -> void: GameManager.set_setting(setting, v))
	row.add_child(sl)
	return row


func _check(key: String, setting: String) -> CheckBox:
	var c := CheckBox.new()
	c.text = tr(key)
	c.button_pressed = bool(GameManager.settings.get(setting, false))
	c.add_theme_font_size_override("font_size", 24)
	c.custom_minimum_size.y = 52
	c.toggled.connect(func(on: bool) -> void: GameManager.set_setting(setting, on))
	return c


func _set_lang(code: String) -> void:
	GameManager.set_setting("language", code)
	set_title(tr(title_key))
	rebuild()


func _export() -> void:
	if not SaveManager.has_save() and not GameManager.in_game:
		return
	if OS.has_feature("web"):
		SaveManager.export_to_browser()
		return
	_open_dialog(FileDialog.FILE_MODE_SAVE_FILE)


func _import() -> void:
	if OS.has_feature("web"):
		SaveManager.import_from_browser()
		return
	_open_dialog(FileDialog.FILE_MODE_OPEN_FILE)


func _open_dialog(mode: FileDialog.FileMode) -> void:
	if _file_dialog != null:
		_file_dialog.queue_free()
	_file_dialog = FileDialog.new()
	_file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	_file_dialog.file_mode = mode
	_file_dialog.filters = PackedStringArray(["*.json"])
	_file_dialog.current_file = "forge_workshop_save.json"
	_file_dialog.size = Vector2i(1200, 800)
	_file_dialog.file_selected.connect(_on_file)
	add_child(_file_dialog)
	_file_dialog.popup_centered()


func _on_file(path: String) -> void:
	if _file_dialog.file_mode == FileDialog.FILE_MODE_SAVE_FILE:
		SaveManager.export_to_path(path)
	else:
		SaveManager.import_from_path(path)
