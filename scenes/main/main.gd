extends Control
## Wurzelszene: wechselt zwischen Hauptmenü und Werkstatt.

const MainMenu = preload("res://scenes/ui/main_menu.gd")
const Workshop = preload("res://scenes/main/workshop.gd")

var _current: Control


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	show_main_menu()
	if SaveManager.last_load_status == "newer":
		(_current as MainMenu).show_notice("UI_SAVE_NEWER")


func _swap(c: Control) -> void:
	if _current != null:
		_current.queue_free()
	_current = c
	add_child(c)


func show_main_menu() -> void:
	GameManager.end_session()
	SoundManager.update_ambience()
	var m := MainMenu.new()
	m.start_game.connect(show_workshop)
	_swap(m)
	if SaveManager.has_save() and SaveManager.read_best_save().is_empty():
		if SaveManager.last_load_status == "newer":
			m.show_notice("UI_SAVE_NEWER")
		elif SaveManager.last_load_status == "corrupt":
			m.show_notice("UI_SAVE_CORRUPT")
	elif SaveManager.last_load_status == "backup" or SaveManager.last_load_status == "tmp":
		m.show_notice("UI_SAVE_RESTORED")


func show_workshop() -> void:
	var w := Workshop.new()
	w.quit_to_menu.connect(show_main_menu)
	_swap(w)
