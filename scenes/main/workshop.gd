extends Control
## Werkstatt (Hauptspiel, 6.2): links die Esse, rechts Amboss und Löschtrog,
## darunter Glutfarben-Skala, Fortschritt und Aktionen; oben/unten das HUD.

const UIKit = preload("res://scenes/ui/ui_kit.gd")
const Assets = preload("res://scripts/assets.gd")
const Economy = preload("res://scripts/economy.gd")
const HeatModel = preload("res://scripts/heat_model.gd")
const Overlay = preload("res://scenes/ui/overlay.gd")
const Background = preload("res://scenes/main/workshop_background.gd")
const ForgeView = preload("res://scenes/main/forge_view.gd")
const AnvilView = preload("res://scenes/main/anvil_view.gd")
const TroughView = preload("res://scenes/main/trough_view.gd")
const MachineView = preload("res://scenes/main/machine_view.gd")
const PieceView = preload("res://scenes/main/piece_view.gd")
const GlowScale = preload("res://scenes/ui/glow_scale.gd")
const Hud = preload("res://scenes/ui/hud.gd")
const Tutorial = preload("res://scenes/ui/tutorial.gd")
const StepMarks = preload("res://scenes/ui/step_marks.gd")

const STAGE_SIZE := Vector2(1080, 1920)
## Bühnen-Positionen (Hochformat)
const FORGE_X := 120.0
const ANVIL_POS := Vector2(270, 880)
const MACHINE_POS := Vector2(210, 650)
const TROUGH_POS := Vector2(20, 1110)
## Rohling-Stapel links vor dem Amboss (Bühnen-Koordinaten)
const RAW_STACK := Rect2(130, 975, 260, 90)
## Bedienfeld unten (Bildschirm-Koordinaten)
const CONTROLS_SIZE := Vector2(720, 380)

signal quit_to_menu()

var background: Background
var stage: Control
var forge_view: ForgeView
var anvil_view: AnvilView
var trough_view: TroughView
var machine_view: MachineView
var glow_scale: GlowScale
var hud: Hud
var tutorial: Tutorial
var pieces_layer: Node2D
var fx_layer: Node2D
var overlay_layer: Control
var controls: Control
var _stage_base := Vector2.ZERO
var progress_bar: ProgressBar
var step_marks: StepMarks
var info_label: Label
var btn_load: Button
var btn_move: Button
var btn_hammer: Button
## Beschriftung unter dem großen Glut-Knopf (nur wenn dessen Grafik vorhanden ist)
var hammer_label: Label
var btn_quench: Button
## Schlagstärke-Wahl (leicht, mittel, schwer)
var force_buttons: Array = []
var _force_hint_checked: bool = false
var sparks: CPUParticles2D
var weld_sparks: CPUParticles2D
var smoke: CPUParticles2D

var piece_views: Dictionary = {}
var _hold_active: bool = false
var _hold_timer: float = 0.0
var _shake: float = 0.0
var _hint_queue: Array = []
var _hint_open: bool = false
var _cold_msgs: int = 0
var _off_msgs: int = 0
var _force_msgs: int = 0
var _locale: String = ""


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	theme = UIKit.theme()
	_locale = TranslationServer.get_locale()
	background = Background.new()
	add_child(background)
	stage = Control.new()
	stage.size = STAGE_SIZE
	stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(stage)

	# Bühne (Bühnen-Koordinaten 1080 × 1920, skaliert): Esse oben an der Rückwand,
	# Amboss davor auf dem Boden, Maschine/Löschtrog rechts daneben.
	machine_view = MachineView.new()
	machine_view.position = MACHINE_POS
	machine_view.size = Vector2(1020, 330)
	machine_view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(machine_view)

	forge_view = ForgeView.new()
	forge_view.position = Vector2(FORGE_X, 200)
	forge_view.slot_clicked.connect(_on_slot_clicked)
	forge_view.raw_clicked.connect(_on_raw_clicked)
	stage.add_child(forge_view)
	# Maschinen stehen vor der Esse (sonst verdeckt die große Esse Zylinder und Antrieb)
	stage.move_child(machine_view, forge_view.get_index())

	anvil_view = AnvilView.new()
	anvil_view.position = ANVIL_POS
	anvil_view.size = Vector2(540, 430)
	anvil_view.anvil_pressed.connect(_hammer_press)
	anvil_view.anvil_released.connect(_hammer_release)
	stage.add_child(anvil_view)
	machine_view.head_x = anvil_view.position.x + anvil_view.size.x * 0.5 - machine_view.position.x
	machine_view.strike_y = anvil_point().y - 4.0 - machine_view.position.y

	trough_view = TroughView.new()
	trough_view.position = TROUGH_POS
	trough_view.size = Vector2(320, 170)
	trough_view.trough_clicked.connect(_on_quench)
	stage.add_child(trough_view)

	pieces_layer = Node2D.new()
	stage.add_child(pieces_layer)
	fx_layer = Node2D.new()
	stage.add_child(fx_layer)
	_build_particles()

	# Bedienfeld (Bildschirm-Koordinaten) unten über der Navigationsleiste
	controls = Control.new()
	controls.size = CONTROLS_SIZE
	controls.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(controls)

	glow_scale = GlowScale.new()
	glow_scale.position = Vector2(20, 0)
	glow_scale.size = Vector2(680, 92)
	glow_scale.mouse_filter = Control.MOUSE_FILTER_IGNORE
	controls.add_child(glow_scale)

	progress_bar = ProgressBar.new()
	progress_bar.position = Vector2(20, 98)
	progress_bar.size = Vector2(680, 30)
	progress_bar.show_percentage = false
	progress_bar.max_value = 1.0
	progress_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	controls.add_child(progress_bar)
	step_marks = StepMarks.new()
	step_marks.position = progress_bar.position
	step_marks.size = progress_bar.size
	step_marks.mouse_filter = Control.MOUSE_FILTER_IGNORE
	controls.add_child(step_marks)
	info_label = UIKit.label("", 19, UIKit.TEXT_LIGHT)
	info_label.position = Vector2(20, 131)
	info_label.size = Vector2(680, 28)
	info_label.clip_text = true
	info_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	info_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	info_label.add_theme_constant_override("outline_size", 4)
	controls.add_child(info_label)

	var buttons := VBoxContainer.new()
	buttons.position = Vector2(20, 166)
	buttons.size = Vector2(330, 170)
	buttons.add_theme_constant_override("separation", 6)
	controls.add_child(buttons)
	btn_load = UIKit.button(tr("UI_BTN_LOAD"), _on_raw_clicked, Vector2(330, 52), 22)
	buttons.add_child(btn_load)
	btn_move = UIKit.button(tr("UI_BTN_MOVE"), _on_move, Vector2(330, 52), 22)
	buttons.add_child(btn_move)
	btn_quench = UIKit.button(tr("UI_BTN_QUENCH"), _on_quench, Vector2(330, 52), 22)
	buttons.add_child(btn_quench)
	# Schlagstärke: drei Knöpfe über dem Hammer
	var force_row := HBoxContainer.new()
	force_row.position = Vector2(385, 166)
	force_row.size = Vector2(300, 46)
	force_row.add_theme_constant_override("separation", 4)
	force_row.tooltip_text = tr("UI_FORCE_TIP")
	controls.add_child(force_row)
	var group := ButtonGroup.new()
	for lvl in 3:
		var fb := UIKit.button(tr("FORCE_%d" % lvl), _set_force.bind(lvl), Vector2(97, 46), 19)
		fb.toggle_mode = true
		fb.button_group = group
		fb.focus_mode = Control.FOCUS_NONE
		fb.tooltip_text = tr("UI_FORCE_TIP")
		force_row.add_child(fb)
		force_buttons.append(fb)
	btn_hammer = UIKit.button(_hammer_text(), Callable(), Vector2(330, 168), 30)
	btn_hammer.button_down.connect(_hammer_press)
	btn_hammer.button_up.connect(_hammer_release)
	btn_hammer.position = Vector2(370, 218)
	btn_hammer.custom_minimum_size = Vector2(330, 130)
	btn_hammer.size = btn_hammer.custom_minimum_size
	controls.add_child(btn_hammer)
	_make_ember_hammer()
	for b in [btn_load, btn_move, btn_hammer, btn_quench]:
		b.focus_mode = Control.FOCUS_NONE

	hud = Hud.new()
	add_child(hud)
	_connect_hud()

	tutorial = Tutorial.new()
	add_child(tutorial)
	GameManager.sim.force = clampi(int(GameManager.settings.get("force", 2)), 0, 2)
	_sync_force_buttons()

	overlay_layer = Control.new()
	overlay_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(overlay_layer)

	var gm := GameManager
	gm.sim_event.connect(_on_sim_event)
	gm.state_changed.connect(_on_state_changed)
	gm.active_job_changed.connect(_clear_piece_views)
	gm.settlement_ready.connect(_on_settlement)
	gm.hint_requested.connect(_queue_hint)
	gm.offline_earnings_ready.connect(_on_offline)
	gm.epoch_unlocked.connect(_on_epoch_unlocked)
	gm.message.connect(_on_message)
	gm.settings_changed.connect(_on_settings_changed)
	resized.connect(_layout)
	_layout()
	_on_state_changed()
	SoundManager.play_music_for_epoch(gm.current_epoch)
	SoundManager.update_ambience()
	gm.take_pending_offline.call_deferred()
	if gm.active_job == null and int(gm.stats.get("jobs_completed", 0)) == 0:
		_queue_hint("welcome")


func _exit_tree() -> void:
	var gm := GameManager
	for sig in [gm.sim_event, gm.state_changed, gm.active_job_changed, gm.settlement_ready, gm.hint_requested,
			gm.offline_earnings_ready, gm.epoch_unlocked, gm.message, gm.settings_changed]:
		for c in sig.get_connections():
			if c["callable"].get_object() == self:
				sig.disconnect(c["callable"])


func _connect_hud() -> void:
	hud.open_jobs.connect(_open_if_free.bind("res://scenes/ui/job_book.gd"))
	hud.open_shop.connect(_open_if_free.bind("res://scenes/ui/shop.gd"))
	hud.open_staff.connect(_open_if_free.bind("res://scenes/ui/staff_panel.gd"))
	hud.open_stats.connect(_open_if_free.bind("res://scenes/ui/stats_panel.gd"))
	hud.open_menu.connect(_open_pause)
	hud.open_epoch.connect(_open_epoch_offer)


func _open_if_free(path: String) -> void:
	if Overlay.open_count == 0:
		open_overlay(path)


## Großer HAMMERN-Knopf aus der Glut-Grafik des Auftraggebers (Daumen-Knopf rechts unten).
func _make_ember_hammer() -> bool:
	var boxes := {}
	for st in ["normal", "hover", "pressed", "disabled"]:
		var tex := Assets.user("ember_%s.png" % st)
		if tex == null:
			return false
		var sb := StyleBoxTexture.new()
		sb.texture = tex
		boxes[st] = sb
	for st in boxes:
		btn_hammer.add_theme_stylebox_override(st, boxes[st])
	btn_hammer.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	btn_hammer.text = ""
	btn_hammer.tooltip_text = tr("UI_BTN_HAMMER")
	btn_hammer.custom_minimum_size = Vector2(262, 136)
	btn_hammer.position = Vector2(404, 218)
	btn_hammer.size = btn_hammer.custom_minimum_size
	hammer_label = UIKit.label(_hammer_text(), 20, UIKit.TEXT_LIGHT, HORIZONTAL_ALIGNMENT_CENTER)
	hammer_label.position = Vector2(385, 352)
	hammer_label.size = Vector2(300, 26)
	hammer_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	hammer_label.add_theme_constant_override("outline_size", 6)
	hammer_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	controls.add_child(hammer_label)
	return true


## Kurzer Text für den Hammer-Knopf (ohne Tastenhinweis auf Touch-Geräten).
func _hammer_text() -> String:
	var t := tr("UI_BTN_HAMMER")
	if DisplayServer.is_touchscreen_available() or OS.has_feature("mobile"):
		return t.get_slice(" – ", 0)
	return t


## Esse an die Wand-Boden-Kante des Hintergrunds stellen; Rohling-Stapel bleibt vor dem Amboss.
func _place_forge() -> void:
	var floor_y := Background.floor_y_for(GameManager.current_epoch)
	var bottom := forge_view.body_bottom()
	forge_view.position = Vector2(FORGE_X, floor_y + 40.0 - bottom)
	forge_view.raw_rect = Rect2(RAW_STACK.position - forge_view.position, RAW_STACK.size)
	forge_view.size = Vector2(920, RAW_STACK.end.y - forge_view.position.y + 10.0)
	_place_smoke()


## Rauch aus dem Schornstein der jeweiligen Esse (schmal bei den Essen des Auftraggebers).
func _place_smoke() -> void:
	if smoke == null:
		return
	smoke.position = forge_view.position + forge_view.smoke_point()
	smoke.emission_rect_extents = Vector2(200, 10) if forge_view.user_forge().is_empty() else Vector2(40, 6)


func _layout() -> void:
	var f := Background.fit(size)
	_stage_base = f[0]
	stage.position = _stage_base
	stage.scale = Vector2(f[1], f[1])
	background.queue_redraw()
	var nav_h := hud.nav_height() if hud != null else 80.0
	controls.position = Vector2(floor((size.x - CONTROLS_SIZE.x) * 0.5), size.y - nav_h - CONTROLS_SIZE.y)
	if tutorial != null:
		tutorial.position = Vector2(floor((size.x - 680.0) * 0.5), (hud.top_height() if hud != null else 150.0) + 8.0)


func _build_particles() -> void:
	sparks = _make_sparks(28, Color(1.0, 0.75, 0.3))
	weld_sparks = _make_sparks(60, Color(1.0, 0.95, 0.7))
	smoke = CPUParticles2D.new()
	smoke.position = forge_view.position + Vector2(440, 260)
	smoke.amount = 24
	smoke.lifetime = 4.0
	smoke.direction = Vector2(0, -1)
	smoke.spread = 20.0
	smoke.gravity = Vector2(0, -20)
	smoke.initial_velocity_min = 20.0
	smoke.initial_velocity_max = 50.0
	smoke.scale_amount_min = 14.0
	smoke.scale_amount_max = 26.0
	smoke.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	smoke.emission_rect_extents = Vector2(200, 10)
	smoke.color = Color(0.5, 0.5, 0.5, 0.18)
	var smoke_tex := Assets.tex("ui/particle_smoke.png")
	if smoke_tex != null:
		smoke.texture = smoke_tex
		smoke.scale_amount_min = 0.5
		smoke.scale_amount_max = 1.1
		smoke.color = Color(0.55, 0.52, 0.5, 0.22)
	stage.add_child(smoke)
	stage.move_child(smoke, 0)


func _make_sparks(amount: int, col: Color) -> CPUParticles2D:
	var p := CPUParticles2D.new()
	p.emitting = false
	p.one_shot = true
	p.amount = amount
	p.lifetime = 0.6
	p.explosiveness = 1.0
	p.direction = Vector2(0, -1)
	p.spread = 75.0
	p.gravity = Vector2(0, 900)
	p.initial_velocity_min = 220.0
	p.initial_velocity_max = 520.0
	p.scale_amount_min = 2.0
	p.scale_amount_max = 5.0
	p.color = col
	var spark_tex := Assets.tex("ui/particle_spark.png")
	if spark_tex != null:
		p.texture = spark_tex
		p.scale_amount_min = 0.25
		p.scale_amount_max = 0.6
	fx_layer.add_child(p)
	return p


func anvil_point() -> Vector2:
	return anvil_view.position + Vector2(anvil_view.size.x * 0.5, 138)


func slot_point(i: int) -> Vector2:
	return forge_view.position + forge_view.slot_center(i)


func raw_point() -> Vector2:
	return forge_view.position + forge_view.raw_center()


# ================================================================== Bildaufbau je Frame

func _process(delta: float) -> void:
	var gm := GameManager
	var sim = gm.sim
	if _hold_active and Overlay.open_count == 0:
		_hold_timer += delta
		var iv: float = 1.0 / gm.cfg.hold_hits_per_s
		while _hold_timer >= iv:
			_hold_timer -= iv
			_do_hit()
	if _shake > 0.0:
		_shake = maxf(0.0, _shake - delta)
		var amp := 6.0 * _shake / 0.15
		stage.position = _stage_base + Vector2(randf_range(-amp, amp), randf_range(-amp, amp))
	elif stage.position != _stage_base:
		stage.position = _stage_base
	var j: JobInstance = gm.active_job
	forge_view.slots = sim.slot_count
	forge_view.selected_slot = sim.selected_slot
	forge_view.raw_count = sim.raw_count()
	forge_view.heating = false
	for idx in sim.forge_slots:
		if idx >= 0:
			forge_view.heating = true
	var m := gm.current_machine()
	machine_view.water_level = sim.water_level
	machine_view.running = m != null and sim.anvil >= 0
	trough_view.visible = gm.has_trough()
	_update_force_state()
	_update_hand_hammer()
	_sync_pieces()
	_update_scale_and_progress(j)
	_update_buttons(j)
	tutorial.update_step()


func _sync_pieces() -> void:
	var gm := GameManager
	var sim = gm.sim
	var j: JobInstance = gm.active_job
	if j == null:
		_clear_piece_views()
		return
	var item: ItemData = gm.items.get(j.template_id, null)
	var shape: String = item.shape if item != null else "bar"
	var fp := j.piece_fp()
	for i in j.pieces.size():
		var p: JobInstance.Piece = j.pieces[i]
		var visible_here := p.location == JobInstance.LOC_FORGE or p.location == JobInstance.LOC_ANVIL
		if not visible_here:
			if piece_views.has(i):
				piece_views[i].queue_free()
				piece_views.erase(i)
			continue
		var v: PieceView
		if not piece_views.has(i):
			v = PieceView.new()
			v.shape = shape
			v.item_id = j.template_id
			v.damage_warning = gm.cfg.damage_warning
			v.position = raw_point()
			pieces_layer.add_child(v)
			piece_views[i] = v
		else:
			v = piece_views[i]
		var on_anvil := p.location == JobInstance.LOC_ANVIL
		v.target_pos = anvil_point() if on_anvil else slot_point(maxi(0, p.slot))
		v.size_px = 190.0 if on_anvil else 150.0
		var badge := ""
		if sim.in_weld_phase(i):
			badge = "weld"
		elif sim.awaiting_quench(i):
			badge = "quench"
		var sel: bool = (not on_anvil) and p.slot == sim.selected_slot
		v.update_state(p.temp, p.progress / maxf(fp, 0.001), p.damage, sel, badge)


func _clear_piece_views() -> void:
	for k in piece_views.keys():
		piece_views[k].queue_free()
	piece_views.clear()


func _update_scale_and_progress(j: JobInstance) -> void:
	var gm := GameManager
	var sim = gm.sim
	glow_scale.show_celsius = bool(gm.settings.get("show_celsius", false))
	glow_scale.pyrometer = gm.has_pyrometer()
	if j == null:
		glow_scale.temp = -1.0
		glow_scale.weld_window = Vector2(-1, -1)
		glow_scale.quench_window = Vector2(-1, -1)
		glow_scale.window_label = ""
		step_marks.steps = []
		step_marks.queue_redraw()
		progress_bar.value = 0.0
		info_label.text = ""
		glow_scale.queue_redraw()
		return
	var f: int = sim.focus_piece()
	glow_scale.burn = sim.burn_temp()
	glow_scale.window = sim.step_window(f) if f >= 0 else HeatModel.window(gm.cfg, j.is_precision())
	glow_scale.window_label = ""
	step_marks.steps = j.steps
	step_marks.current = sim.step_index(f) if f >= 0 else -1
	step_marks.queue_redraw()
	if f >= 0:
		var p: JobInstance.Piece = j.pieces[f]
		var k: int = sim.step_index(f)
		if j.steps.size() > 0 and not sim.in_weld_phase(f) and not sim.awaiting_quench(f):
			glow_scale.window_label = tr("STEP_" + j.step_id(k).to_upper())
			var rf: int = sim.required_force(f)
			if rf >= 0 and sim.force_enabled:
				glow_scale.window_label += " · " + tr("FORCE_%d_LC" % rf)
		glow_scale.temp = p.temp
		glow_scale.label_text = tr(HeatModel.glow_name_key(p.temp))
		glow_scale.weld_window = Vector2(gm.cfg.weld_min, gm.cfg.weld_max) if sim.in_weld_phase(f) else Vector2(-1, -1)
		glow_scale.quench_window = Vector2(gm.cfg.quench_good_min, gm.cfg.quench_good_max) if sim.awaiting_quench(f) else Vector2(-1, -1)
		progress_bar.value = clampf(p.progress / maxf(j.piece_fp(), 0.001), 0.0, 1.0)
		var txt := tr("UI_PIECE_INFO").format({"i": f + 1, "n": j.quantity, "p": int(progress_bar.value * 100.0)})
		if j.steps.size() > 0 and not sim.in_weld_phase(f) and not sim.awaiting_quench(f):
			var w: Vector2 = sim.step_window(f)
			txt += "  ·  " + tr("UI_STEP_INFO").format({"k": k + 1, "n": j.steps.size(), "step": tr("STEP_" + j.step_id(k).to_upper()), "lo": int(w.x), "hi": int(w.y)})
		if sim.in_weld_phase(f):
			txt += "  ·  " + tr("UI_WELD_INFO").format({"h": p.weld_hits, "n": gm.cfg.weld_hits_required})
		elif sim.awaiting_quench(f):
			txt += "  ·  " + tr("UI_QUENCH_INFO")
		if p.damage > 0.0:
			txt += "  ·  " + tr("UI_DAMAGE_INFO").format({"d": int(round(p.damage * 100.0))})
		var mach: MachineData = gm.current_machine()
		if f == sim.anvil and mach != null and mach.force_mode == "adjustable" and sim.force_enabled \
				and sim.required_force(f) >= 0 and sim.effective_force(f) - sim.required_force(f) >= 2:
			txt = tr("UI_STEAM_WAITS") + "  ·  " + txt
		info_label.text = txt
	else:
		glow_scale.temp = -1.0
		progress_bar.value = sim.total_progress_ratio()
		info_label.text = tr("UI_JOB_INFO").format({"p": int(progress_bar.value * 100.0)})
	glow_scale.queue_redraw()


func _update_buttons(j: JobInstance) -> void:
	var gm := GameManager
	var sim = gm.sim
	var has := j != null
	btn_load.disabled = not has or sim.next_raw() < 0 or sim.free_slot() < 0
	btn_move.disabled = not has or (sim.anvil < 0 and sim.hottest_forge_piece() < 0)
	btn_hammer.disabled = not has or sim.anvil < 0
	btn_quench.visible = gm.has_trough() and has and j.needs_harden()
	var can_quench := false
	if has and j.needs_harden():
		for i in j.pieces.size():
			if sim.awaiting_quench(i):
				can_quench = true
	btn_quench.disabled = not can_quench
	trough_view.active = can_quench


# ================================================================== Eingabe

func _unhandled_input(event: InputEvent) -> void:
	if Overlay.open_count > 0:
		return
	if event is InputEventKey and event.is_echo():
		return
	var sim = GameManager.sim
	if event.is_action_pressed("hammer"):
		_hammer_press()
	elif event.is_action_released("hammer"):
		_hammer_release()
	elif event.is_action_pressed("move_piece"):
		_on_move()
	elif event.is_action_pressed("load_raw"):
		_on_raw_clicked()
	elif event.is_action_pressed("quench"):
		_on_quench()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_UP:
		_set_force(sim.force + 1)
	elif event is InputEventKey and event.pressed and event.keycode == KEY_DOWN:
		_set_force(sim.force - 1)
	elif event.is_action_pressed("select_1"):
		sim.selected_slot = 0
	elif event.is_action_pressed("select_2"):
		sim.selected_slot = mini(1, sim.slot_count - 1)
	elif event.is_action_pressed("select_3"):
		sim.selected_slot = mini(2, sim.slot_count - 1)
	elif event.is_action_pressed("open_jobs"):
		open_overlay("res://scenes/ui/job_book.gd")
	elif event.is_action_pressed("open_shop"):
		open_overlay("res://scenes/ui/shop.gd")
	elif event.is_action_pressed("open_staff") and GameManager.current_epoch >= 2:
		open_overlay("res://scenes/ui/staff_panel.gd")
	elif event.is_action_pressed("pause"):
		_open_pause()
	elif event.is_action_pressed("test_menu") and GameManager.test_tools_enabled():
		open_overlay("res://scenes/ui/test_panel.gd")
	else:
		return
	get_viewport().set_input_as_handled()


func _hammer_press() -> void:
	if Overlay.open_count > 0:
		return
	_do_hit()
	if bool(GameManager.settings.get("hold_to_hammer", false)):
		_hold_active = true
		_hold_timer = 0.0


func _hammer_release() -> void:
	_hold_active = false


func _do_hit() -> void:
	var sim = GameManager.sim
	var used: int = sim.effective_force(sim.anvil) if sim.anvil >= 0 else 1
	var kind: String = sim.player_hit()
	if kind != "none":
		anvil_view.force_level = used
		anvil_view.play_swing()
		# Arbeitet die Maschine gerade mit, führt sie auch die eigenen Schläge sichtbar aus
		if machine_view.machine_id != "" and sim.machine_engaged():
			machine_view.strike()


func _on_slot_clicked(slot: int) -> void:
	var sim = GameManager.sim
	if sim.job == null:
		return
	sim.selected_slot = slot
	if sim.forge_slots[slot] >= 0:
		sim.move_slot_to_anvil(slot)
	elif sim.anvil >= 0:
		sim.move_anvil_to_forge(slot)
	else:
		sim.load_raw(slot)


func _on_raw_clicked() -> void:
	GameManager.sim.load_raw()


func _on_move() -> void:
	GameManager.sim.smart_move()


func _on_quench() -> void:
	if GameManager.sim.quench():
		trough_view.puff()


# ================================================================== Effekte

func _on_sim_event(kind: String, data: Dictionary) -> void:
	var flash := bool(GameManager.settings.get("flash_effects", true))
	match kind:
		"hit_good", "hit_overheat":
			sparks.position = anvil_point()
			sparks.amount = 28 if flash else 8
			sparks.restart()
			_shake_screen()
		"hit_weld":
			weld_sparks.position = anvil_point()
			weld_sparks.amount = 60 if flash else 12
			weld_sparks.restart()
			_shake_screen()
		"hit_cold":
			if _cold_msgs < 3 or randf() < 0.15:
				_cold_msgs += 1
				_float_text(tr("FX_TOO_COLD"), anvil_point() + Vector2(0, -80), Color("9fc5e8"))
		"step":
			var sid := str(data.get("id", ""))
			if sid != "" and GameManager.active_job != null:
				var w: Vector2 = GameManager.sim.window_for_step(sid)
				_float_text(tr("FX_NEXT_STEP").format({"step": tr("STEP_" + sid.to_upper()), "lo": int(w.x), "hi": int(w.y)}), anvil_point() + Vector2(0, -140), Color(1, 0.92, 0.7))
		"hit_too_hard", "hit_too_soft":
			if kind == "hit_too_hard":
				sparks.position = anvil_point()
				sparks.amount = 18 if flash else 6
				sparks.restart()
				_shake_screen()
			if _force_msgs < 4 or randf() < 0.12:
				_force_msgs += 1
				var hard := kind == "hit_too_hard"
				_float_text(tr("FX_TOO_HARD" if hard else "FX_TOO_SOFT"), anvil_point() + Vector2(0, -80), Color(1, 0.55, 0.4) if hard else Color(0.8, 0.85, 1.0))
		"hit_off":
			if _off_msgs < 3 or randf() < 0.1:
				_off_msgs += 1
				_float_text(tr("FX_WRONG_HEAT"), anvil_point() + Vector2(0, -80), Color(1, 0.8, 0.5))
		"weld_phase":
			_float_text(tr("FX_WELD_PHASE"), anvil_point() + Vector2(0, -110), Color(1, 1, 0.7))
		"weld_done":
			_float_text(tr("FX_WELD_DONE"), anvil_point() + Vector2(0, -110), Color(1, 0.95, 0.6))
		"ready_to_quench":
			_float_text(tr("FX_READY_TO_QUENCH"), anvil_point() + Vector2(0, -110), Color(0.7, 0.9, 1.0))
		"quench_good", "quench_uneven", "quench_soft", "quench_crack":
			trough_view.puff()
			var col := Color(0.6, 1.0, 0.6) if kind == "quench_good" else Color(1, 0.6, 0.4)
			_float_text(tr("FX_" + kind.to_upper()) + " (%d °C)" % int(data.get("temp", 0.0)), trough_view.position + Vector2(160, -40), col)
		"ruin_burned":
			_float_text(tr("FX_BURNED"), anvil_point() + Vector2(-200, -60), Color(1, 0.4, 0.3))
		"ruin_damage":
			_float_text(tr("FX_CRACKED"), anvil_point() + Vector2(0, -60), Color(1, 0.4, 0.3))
		"machine":
			machine_view.strike()
			if str(data.get("kind", "")) in ["good", "overheat", "weak"]:
				sparks.position = anvil_point()
				sparks.amount = 16 if flash else 6
				sparks.restart()
				_shake_screen()
		"striker":
			anvil_view.play_swing()
		"piece_done":
			_float_text(tr("FX_PIECE_DONE"), anvil_point() + Vector2(0, -120), Color(0.9, 0.95, 0.7))


## Handhammer nur zeigen, wenn keine Maschine gerade mitarbeitet (Schwanzhämmer pausieren
## in leichten Arbeitsgängen – dann arbeitet der Schmied von Hand).
func _update_hand_hammer() -> void:
	var sim = GameManager.sim
	var busy: bool = machine_view.machine_id != "" and sim.machine_engaged() and (machine_view.steam_hammer or machine_view.has_user_parts())
	anvil_view.hand_hammer_visible = not busy
	if sim.anvil >= 0:
		machine_view.force_level = sim.effective_force(sim.anvil)


## Schlagstärke wählen (0 leicht, 1 mittel, 2 schwer).
func _set_force(level: int) -> void:
	GameManager.sim.force = clampi(level, 0, 2)
	GameManager.settings["force"] = GameManager.sim.force
	_sync_force_buttons()


func _sync_force_buttons() -> void:
	var sim = GameManager.sim
	for k in force_buttons.size():
		var b: Button = force_buttons[k]
		var on: bool = k == (sim.force if sim.force_enabled else 1)
		b.disabled = not sim.force_enabled
		b.set_pressed_no_signal(on)
		# Gewählte Stärke deutlich hervorheben: hell mit Goldschrift, die anderen gedämpft
		b.modulate = Color.WHITE if on else Color(0.62, 0.6, 0.58)
		b.add_theme_color_override("font_color", UIKit.GOLD if on else UIKit.TEXT_LIGHT)
		b.add_theme_color_override("font_pressed_color", UIKit.GOLD)
		b.add_theme_color_override("font_hover_pressed_color", UIKit.GOLD)


## Im Tutorial (erste Aufträge) spielt die Schlagstärke noch keine Rolle.
func _update_force_state() -> void:
	var sim = GameManager.sim
	var enabled: bool = not tutorial.force_locked()
	if enabled != sim.force_enabled:
		sim.force_enabled = enabled
		_sync_force_buttons()
	if enabled and not _force_hint_checked:
		_force_hint_checked = true
		_queue_hint("force")
	var j: JobInstance = GameManager.active_job
	if enabled and j != null and not GameManager.seen_hints.has("force_medium") and j.epoch > GameManager.cfg.force_simple_until_epoch and j.steps.size() > 0:
		for st in j.steps:
			if int(GameManager.cfg.step_force.get(str(st.get("id", "")), 2)) == 1:
				_queue_hint("force_medium")
				break


func _shake_screen() -> void:
	if bool(GameManager.settings.get("screen_shake", true)):
		_shake = 0.15


func _float_text(text: String, pos: Vector2, col: Color) -> void:
	var l := UIKit.label(text, 44, col, HORIZONTAL_ALIGNMENT_CENTER)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	l.add_theme_constant_override("outline_size", 9)
	l.size = Vector2(1000, 60)
	l.position = Vector2(clampf(pos.x - 500.0, 40.0, STAGE_SIZE.x - 1040.0), pos.y - 30.0)
	stage.add_child(l)
	var tw := l.create_tween()
	tw.set_parallel(true)
	tw.tween_property(l, "position:y", l.position.y - 60.0, 1.4)
	tw.tween_property(l, "modulate:a", 0.0, 1.4).set_delay(0.5)
	tw.chain().tween_callback(l.queue_free)


func _on_message(key: String, args: Dictionary) -> void:
	_float_text(tr(key).format(args), forge_view.position + forge_view.smoke_point() + Vector2(-80, 180), Color(1, 0.7, 0.5))


# ================================================================== Fenster

func open_overlay(path: String) -> Node:
	var p = load(path).new()
	overlay_layer.add_child(p)
	return p


func _open_pause() -> void:
	if Overlay.open_count > 0:
		return
	var p = open_overlay("res://scenes/ui/pause_menu.gd")
	p.quit_to_menu.connect(func() -> void: quit_to_menu.emit())


func _open_epoch_offer() -> void:
	if not GameManager.can_advance_epoch():
		return
	var p = load("res://scenes/ui/epoch_panel.gd").new()
	p.mode = "offer"
	p.epoch = GameManager.current_epoch + 1
	overlay_layer.add_child(p)


func _on_settlement(report: Dictionary) -> void:
	_hold_active = false
	var p = load("res://scenes/ui/settlement_panel.gd").new()
	p.report = report
	p.continue_pressed.connect(_after_settlement)
	overlay_layer.add_child(p)


func _after_settlement(report: Dictionary) -> void:
	if bool(report.get("game_done", false)):
		var p = load("res://scenes/ui/epoch_panel.gd").new()
		p.mode = "finale"
		p.epoch = GameManager.EPOCH_COUNT
		overlay_layer.add_child(p)
	elif bool(report.get("epoch_done", false)):
		_open_epoch_offer()
	_show_next_hint()


func _queue_hint(id: String) -> void:
	if _hint_queue.has(id):
		return
	_hint_queue.append(id)
	_show_next_hint.call_deferred()


func _show_next_hint() -> void:
	if _hint_open or _hint_queue.is_empty():
		return
	var id: String = _hint_queue.pop_front()
	if GameManager.seen_hints.has(id):
		_show_next_hint()
		return
	_hint_open = true
	var p = load("res://scenes/ui/info_panel.gd").new()
	p.setup("HINT_" + id.to_upper() + "_TITLE", tr("HINT_" + id.to_upper() + "_TEXT"), [[tr("UI_UNDERSTOOD"), Callable()]], 1000.0)
	p.closed.connect(_on_hint_closed.bind(id))
	overlay_layer.add_child(p)


func _on_hint_closed(id: String) -> void:
	GameManager.mark_hint_seen(id)
	_hint_open = false
	_show_next_hint.call_deferred()


func _on_offline(pence: int, seconds: float) -> void:
	var p = load("res://scenes/ui/info_panel.gd").new()
	p.setup("UI_WELCOME_BACK", tr("UI_OFFLINE_EARNINGS").format({"m": Economy.format_lsd(pence), "t": Economy.format_duration(seconds)}))
	overlay_layer.add_child(p)


func _on_state_changed() -> void:
	var gm := GameManager
	background.set_epoch(gm.current_epoch, _rep_level())
	var f := gm.current_forge()
	forge_view.tier = f.tier
	_place_forge()
	anvil_view.hammer_id = gm.current_hammer().id
	anvil_view.queue_redraw()
	_place_smoke()
	var m := gm.current_machine()
	machine_view.machine_id = m.id if m != null else ""
	machine_view.water_powered = m != null and m.water_powered
	machine_view.steam_hammer = m != null and m.force_mode == "adjustable"
	machine_view.large = m != null and m.tier >= 4
	anvil_view.schabotte = machine_view.steam_hammer
	_update_hand_hammer()
	hud.refresh()
	SoundManager.update_ambience()
	SoundManager.play_music_for_epoch(gm.current_epoch)


func _rep_level() -> int:
	match GameManager.reputation_title_key():
		"REP_5":
			return 5
		"REP_4":
			return 4
		"REP_3":
			return 3
		"REP_2":
			return 2
	return 1


func _on_epoch_unlocked(_e: int) -> void:
	_on_state_changed()
	_clear_piece_views()


func _on_settings_changed() -> void:
	# Nur bei geänderter Sprache: HUD neu aufbauen und Texte setzen.
	if TranslationServer.get_locale() == _locale:
		return
	_locale = TranslationServer.get_locale()
	var old := hud
	hud = Hud.new()
	add_child(hud)
	move_child(hud, old.get_index())
	old.queue_free()
	_connect_hud()
	btn_load.text = tr("UI_BTN_LOAD")
	btn_move.text = tr("UI_BTN_MOVE")
	if hammer_label != null:
		hammer_label.text = _hammer_text()
	else:
		btn_hammer.text = _hammer_text()
	btn_quench.text = tr("UI_BTN_QUENCH")
