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
var _scroll: ScrollContainer
## Hauptknopf des Fensters: Enter löst ihn aus (am Rechner mit Hinweis „[Enter]“).
var default_button: Button = null
## Taste, die dieses Fenster öffnet (z. B. "open_jobs") – schließt es auch wieder.
var toggle_action: String = ""

static var open_count: int = 0
## Offene Fenster in Reihenfolge; nur das oberste reagiert auf Tasten.
static var _stack: Array = []


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
	if build_custom(center):
		_finish_ready()
		return
	panel = PanelContainer.new()
	panel.custom_minimum_size.x = minf(panel_width, UIKit.PANEL_W)
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
		x.tooltip_text = tr("UI_CLOSE") + UIKit.key_hint("Esc")
		head.add_child(x)
	outer.add_child(UIKit.hsep())
	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# Inhalt scrollt, wenn das Fenster höher als der Bildschirm würde (Hochformat)
	_scroll = ScrollContainer.new()
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_scroll.add_child(content)
	outer.add_child(_scroll)
	build(content)
	_fit_scroll.call_deferred()
	_finish_ready()


## Scrollbereich so hoch wie der Inhalt, höchstens bis zum Bildschirmrand.
func _fit_scroll() -> void:
	if _scroll == null or content == null or not is_inside_tree():
		return
	# Platz zwischen Status- und Navigationsleiste (zusammen ca. 230) abzüglich Titelzeile und Rand des Fensters
	var chrome := 0.0
	if panel != null:
		chrome = panel.get_combined_minimum_size().y - _scroll.get_combined_minimum_size().y
	var max_h := get_viewport_rect().size.y - 250.0 - maxf(chrome, 150.0)
	_scroll.custom_minimum_size.y = minf(content.get_combined_minimum_size().y, max_h)


func _finish_ready() -> void:
	_stack.append(self)
	if pauses_sim:
		_counted = true
		open_count += 1
		GameManager.sim_paused = true
	_focus_first.call_deferred()


func _exit_tree() -> void:
	_stack.erase(self)
	if _counted:
		_counted = false
		open_count = maxi(0, open_count - 1)
		if open_count == 0:
			GameManager.sim_paused = false


## Für Fenster mit eigenem Aufbau (z. B. Auftragsbuch als Buch): true zurückgeben, wenn gebaut.
func build_custom(_center: CenterContainer) -> bool:
	return false


func _focus_first() -> void:
	if default_button != null and is_instance_valid(default_button) and not default_button.disabled:
		default_button.grab_focus()
		return
	if content == null:
		return
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


## Tasten am Rechner: Esc schließt (bzw. cancel()), Enter = Hauptknopf, eigene Fenster-Taste schließt.
func _unhandled_key_input(event: InputEvent) -> void:
	if not event.is_pressed() or event.is_echo() or _stack.is_empty() or _stack.back() != self:
		return
	var k := event as InputEventKey
	if k == null:
		return
	if k.keycode == KEY_ESCAPE or (toggle_action != "" and event.is_action_pressed(toggle_action)):
		cancel()
	elif (k.keycode == KEY_ENTER or k.keycode == KEY_KP_ENTER) and default_button != null \
			and is_instance_valid(default_button) and not default_button.disabled and default_button.is_visible_in_tree():
		default_button.pressed.emit()
	else:
		return
	get_viewport().set_input_as_handled()


## Esc: schließen, falls erlaubt. Zum Überschreiben (z. B. Abrechnung: wie „Weiter“).
func cancel() -> void:
	if closable:
		close()


## Knopf als Hauptknopf (Enter) festlegen und am Rechner beschriften.
func set_default(b: Button) -> Button:
	default_button = b
	b.text += UIKit.key_hint("Enter")
	return b


func set_title(text: String) -> void:
	if _title_label != null:
		_title_label.text = text


## Zum Überschreiben.
func build(_box: VBoxContainer) -> void:
	pass


## Inhalt neu aufbauen.
func rebuild() -> void:
	for c in content.get_children():
		c.queue_free()
	build(content)
	_fit_scroll.call_deferred()


func close() -> void:
	_stack.erase(self)
	closed.emit()
	queue_free()


static func scroll(child: Control, height: float) -> ScrollContainer:
	var sc := ScrollContainer.new()
	sc.custom_minimum_size.y = height
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	child.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(child)
	return sc
