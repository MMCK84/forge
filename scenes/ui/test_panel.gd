extends "res://scenes/ui/overlay.gd"
## Testmenü (F12, nur Testversionen): Epochen springen, Test-Spielstände, Geld, Zeitraffer.

const Economy = preload("res://scripts/economy.gd")

## Wird ausgelöst, wenn aus dem Hauptmenü heraus ein Spiel gestartet bzw. geladen wurde.
signal game_started()


func _init() -> void:
	title_key = "TEST_TITLE"
	panel_width = 1300.0


func build(box: VBoxContainer) -> void:
	var gm := GameManager
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 10)
	box.add_child(scroll(list, 900))
	if gm.in_game:
		list.add_child(UIKit.wrap_label(tr("TEST_INFO").format({
			"e": gm.current_epoch, "n": gm.jobs_completed_in_epoch + 1, "total": gm.epoch_job_count(),
			"c": "%.2f" % gm.current_complexity(), "m": Economy.format_lsd(gm.total_pence),
		}), 22, UIKit.INK, UIKit.CW - 20.0))
	# --- Epochen
	list.add_child(_section("TEST_EPOCHS"))
	list.add_child(UIKit.wrap_label(tr("TEST_EPOCHS_NOTE"), 20, UIKit.INK_LIGHT, UIKit.CW))
	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 6)
	for e in range(1, GameManager.EPOCH_COUNT + 1):
		grid.add_child(UIKit.label("%d" % e, 24, UIKit.INK))
		for pos in [[0.0, "TEST_START"], [0.5, "TEST_MIDDLE"], [1.0, "TEST_END"]]:
			grid.add_child(UIKit.button(tr(pos[1]), _jump.bind(e, float(pos[0])), Vector2(170, 52), 20))
	list.add_child(grid)
	# --- Schnellaktionen (nur im laufenden Spiel)
	if gm.in_game:
		list.add_child(_section("TEST_QUICK"))
		var row := HBoxContainer.new()
		row.add_child(UIKit.button("+ £10", _money.bind(2400), Vector2(150, 52), 20))
		row.add_child(UIKit.button("+ £100", _money.bind(24000), Vector2(150, 52), 20))
		row.add_child(UIKit.button("+ £1.000", _money.bind(240000), Vector2(160, 52), 20))
		list.add_child(row)
		row = HBoxContainer.new()
		var fin := UIKit.button(tr("TEST_FINISH_JOB"), _finish, Vector2(0, 52), 20)
		fin.disabled = gm.active_job == null
		row.add_child(fin)
		row.add_child(UIKit.button(tr("TEST_REROLL"), _reroll, Vector2(0, 52), 20))
		list.add_child(row)
		var speed := HBoxContainer.new()
		speed.add_child(UIKit.label(tr("TEST_SPEED"), 22, UIKit.INK))
		for sc in [1.0, 2.0, 4.0]:
			var b := UIKit.button("×%d" % int(sc), _speed.bind(sc), Vector2(90, 52), 20)
			b.disabled = is_equal_approx(Engine.time_scale, sc)
			speed.add_child(b)
		list.add_child(speed)
	# --- Test-Spielstände
	list.add_child(_section("TEST_SLOTS"))
	for i in range(1, SaveManager.TEST_SLOTS + 1):
		var info := SaveManager.test_slot_info(i)
		var r := HBoxContainer.new()
		var text := tr("TEST_SLOT_EMPTY").format({"i": i})
		if not info.is_empty():
			text = tr("TEST_SLOT_INFO").format({
				"i": i, "e": info["epoch"], "n": int(info["n"]) + 1, "m": Economy.format_lsd(int(info["pence"])),
				"date": Time.get_datetime_string_from_unix_time(int(info["saved_at"]) + _tz_offset(), true),
			})
		var l := UIKit.wrap_label(text, 20, UIKit.INK if not info.is_empty() else UIKit.INK_LIGHT, UIKit.CW)
		list.add_child(l)
		var sv := UIKit.button(tr("TEST_SAVE"), _save.bind(i), Vector2(160, 52), 20)
		sv.disabled = not gm.in_game
		r.add_child(sv)
		var ld := UIKit.button(tr("TEST_LOAD"), _load.bind(i), Vector2(170, 52), 20)
		ld.disabled = info.is_empty()
		r.add_child(ld)
		var dl := UIKit.button(tr("TEST_DELETE"), _delete.bind(i), Vector2(170, 52), 20)
		dl.disabled = info.is_empty()
		r.add_child(dl)
		list.add_child(r)
	list.add_child(UIKit.button(tr("TEST_NEW_GAME"), _new_game, Vector2(320, 56), 22))


func _section(key: String) -> Control:
	return UIKit.label(tr(key), 28, UIKit.LEATHER)


func _tz_offset() -> int:
	return int(Time.get_time_zone_from_system().get("bias", 0)) * 60


func _ensure_game() -> void:
	if not GameManager.in_game:
		SaveManager.start_new_game()


func _jump(epoch: int, progress: float) -> void:
	var was_in_game := GameManager.in_game
	_ensure_game()
	GameManager.debug_set_epoch(epoch, progress, true)
	SaveManager.save_game()
	_done(was_in_game)


func _money(pence: int) -> void:
	GameManager.debug_add_money(pence)
	rebuild()


func _finish() -> void:
	GameManager.debug_finish_job()
	close()


func _reroll() -> void:
	GameManager.debug_reroll_now()
	rebuild()


func _speed(sc: float) -> void:
	GameManager.debug_set_time_scale(sc)
	rebuild()


func _save(i: int) -> void:
	SaveManager.save_test_slot(i)
	rebuild()


func _load(i: int) -> void:
	var was_in_game := GameManager.in_game
	if SaveManager.load_test_slot(i):
		_done(was_in_game)


func _delete(i: int) -> void:
	SaveManager.delete_test_slot(i)
	rebuild()


func _new_game() -> void:
	var was_in_game := GameManager.in_game
	SaveManager.start_new_game()
	_done(was_in_game)


## Nach Sprung/Laden: im Spiel einfach schließen, aus dem Hauptmenü in die Werkstatt wechseln.
func _done(was_in_game: bool) -> void:
	close()
	if not was_in_game:
		game_started.emit()
