extends PanelContainer
## Geführtes Tutorial der ersten 5 Aufträge (6.4): Einlegen → auf Kirschrot warten →
## schmieden → zu kalt → nachheizen → abliefern → ersten Hammer kaufen. Überspringbar.

const UIKit = preload("res://scenes/ui/ui_kit.gd")

const TUTORIAL_JOBS := 5

var _label: Label
var _step: String = ""


func _ready() -> void:
	add_theme_stylebox_override("panel", UIKit.panel_box(UIKit.PARCHMENT, UIKit.GOLD, 4, 14, 18))
	custom_minimum_size = Vector2(680, 0)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var col := VBoxContainer.new()
	add_child(col)
	var head := HBoxContainer.new()
	col.add_child(head)
	var title := UIKit.label(tr("TUT_TITLE"), 24, UIKit.LEATHER)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(title)
	head.add_child(UIKit.button(tr("TUT_SKIP"), _skip, Vector2(0, 48), 20))
	_label = UIKit.wrap_label("", 22, UIKit.INK, 630.0)
	col.add_child(_label)
	visible = false


## Während der ersten Tutorial-Aufträge zählt die Schlagstärke noch nicht.
func force_locked() -> bool:
	if not is_active():
		return false
	return int(GameManager.stats.get("jobs_completed", 0)) < TUTORIAL_JOBS


func is_active() -> bool:
	var gm := GameManager
	if not bool(gm.settings.get("tutorial", true)) or gm.seen_hints.has("tutorial_done"):
		return false
	return gm.current_epoch == 1


func update_step() -> void:
	if not is_active():
		visible = false
		return
	var gm := GameManager
	var sim = gm.sim
	var jobs := int(gm.stats.get("jobs_completed", 0))
	var step := ""
	var j: JobInstance = gm.active_job
	if jobs >= 1 and not gm.owned_hammer_ids.has("hammer_cross_peen") and gm.total_pence >= 120:
		step = "TUT_BUY_HAMMER"
	elif j == null:
		if jobs >= TUTORIAL_JOBS:
			gm.mark_hint_seen("tutorial_done")
			visible = false
			return
		step = "TUT_OPEN_BOOK"
	elif jobs < TUTORIAL_JOBS:
		var anvil_piece: JobInstance.Piece = sim.anvil_piece()
		if anvil_piece != null:
			var w: Vector2 = sim.step_window(sim.anvil)
			if anvil_piece.temp + sim.temp_offset() < gm.cfg.cold_limit:
				step = "TUT_COLD"
			elif anvil_piece.temp < w.x:
				step = "TUT_TOO_COLD_SOON"
			elif anvil_piece.temp > w.y:
				step = "TUT_TOO_HOT"
			else:
				step = "TUT_HAMMER"
		else:
			var hot: int = sim.hottest_forge_piece()
			if hot < 0:
				step = "TUT_LOAD"
			elif j.pieces[hot].temp >= sim.step_window(hot).x:
				step = "TUT_TAKE"
			else:
				step = "TUT_WAIT_HEAT"
	if step == "":
		visible = false
		return
	visible = true
	if step != _step:
		_step = step
		_label.text = tr(step)


func _skip() -> void:
	GameManager.mark_hint_seen("tutorial_done")
	visible = false
	# ohne Lehrzeit gleich das volle Auftragsbuch
	GameManager.refresh_offers()
