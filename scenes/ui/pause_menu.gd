extends "res://scenes/ui/overlay.gd"
## Pause (6.3): Fortsetzen, Einstellungen, Statistik, Neues Spiel, Speichern & zum Hauptmenü.

signal quit_to_menu()
signal new_game_requested()


func _init() -> void:
	title_key = "UI_PAUSE"
	panel_width = 640.0


func build(box: VBoxContainer) -> void:
	box.add_child(UIKit.button(tr("UI_RESUME"), close, Vector2(520, 72)))
	box.add_child(UIKit.button(tr("UI_SETTINGS"), _open.bind("res://scenes/ui/settings_panel.gd"), Vector2(520, 72)))
	box.add_child(UIKit.button(tr("UI_STATS"), _open.bind("res://scenes/ui/stats_panel.gd"), Vector2(520, 72)))
	if GameManager.test_tools_enabled():
		box.add_child(UIKit.button(tr("TEST_TITLE") + " [F12]", _open.bind("res://scenes/ui/test_panel.gd"), Vector2(520, 72)))
	box.add_child(UIKit.button(tr("UI_NEW_GAME"), _ask_new_game, Vector2(520, 72)))
	box.add_child(UIKit.button(tr("UI_SAVE_AND_QUIT"), _save_quit, Vector2(520, 72)))


func _open(path: String) -> void:
	var p = load(path).new()
	get_parent().add_child(p)


func _ask_new_game() -> void:
	var p = load("res://scenes/ui/info_panel.gd").new()
	p.setup("UI_NEW_GAME", tr("UI_NEW_GAME_WARNING"), [[tr("UI_CANCEL"), Callable()], [tr("UI_NEW_GAME"), _new_game]])
	get_parent().add_child(p)


func _new_game() -> void:
	close()
	new_game_requested.emit()


func _save_quit() -> void:
	SaveManager.save_game()
	close()
	quit_to_menu.emit()
