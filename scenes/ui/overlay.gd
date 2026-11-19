extends Control
## Basis für modale Fenster (Auftragsbuch, Laden, Personal, Einstellungen, ...).
## Abgeleitete Klassen überschreiben build(content) und optional refresh().
## Solange ein Fenster offen ist, pausiert die Werkstatt-Simulation.

const UIKit = preload("res://scenes/ui/ui_kit.gd")

signal closed()

var title_key: String = ""
var panel_width: float = 1100.0
var closable: bool = true
var pauses_sim: bool = true
var panel: PanelContainer
var content: VBoxContainer
var _title_label: Label
var _counted: bool = false

static var open_count: int = 0


func _ready() -> void:
	theme = UIKit.theme()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	process_mode = Node.PROCESS_MODE_ALWAYS
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.55)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)
	panel = PanelContainer.new()
	panel.custom_minimum_size.x = panel_width
	center.add_child(panel)
	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 14)
	panel.add_child(outer)
	var head := HBoxContainer.new()
	outer.add_child(head)
	_title_label = UIKit.label(tr(title_key), 40, UIKit.INK)
	var hf := UIKit.heading_font()
	if hf != null:
		_title_label.add_theme_font_override("font", hf)
	_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(_title_label)
	if closable:
		var x := UIKit.button("X", close, Vector2(64, 64), 28)
		x.tooltip_text = tr("UI_CLOSE")
		head.add_child(x)
	outer.add_child(UIKit.hsep())
	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	outer.add_child(content)
	build(content)
	if pauses_sim:
		_counted = true
		open_count += 1
		GameManager.sim_paused = true
	_focus_first.call_deferred()


func _exit_tree() -> void:
	if _counted:
		_counted = false
		open_count = maxi(0, open_count - 1)
		if open_count == 0:
			GameManager.sim_paused = false


func _focus_first() -> void:
	var b := _find_button(content)
	if b != null:
		b.grab_focus()


func _find_button(n: Node) -> Button:
	for c in n.get_children():
		var btn := c as Button
		if btn != null and not btn.disabled and btn.visible:
			return btn
		var r := _find_button(c)
		if r != null:
			return r
	return null


func set_title(text: String) -> void:
	_title_label.text = text


## Zum Überschreiben.
func build(_box: VBoxContainer) -> void:
	pass


## Inhalt neu aufbauen.
func rebuild() -> void:
	for c in content.get_children():
		c.queue_free()
	build(content)


func _unhandled_input(event: InputEvent) -> void:
	if closable and event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		close()


func close() -> void:
	closed.emit()
	queue_free()


static func scroll(child: Control, height: float) -> ScrollContainer:
	var sc := ScrollContainer.new()
	sc.custom_minimum_size.y = height
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	child.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(child)
	return sc
