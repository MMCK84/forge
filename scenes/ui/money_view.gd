extends HBoxContainer
## Geldbetrag mit Münzsymbolen statt Buchstaben (Entscheidung des Auftraggebers, 21.11.):
## „1 [Gold] 6 [Silber] 6 [Kupfer]“ = £1 6s 6d. Gold = Pfund, Silber = Shilling, Kupfer = Pence.
## Ab Epoche 9 viktorianische Münzen. Tooltip erklärt £ s d und nennt den Betrag in Buchstaben.

const UIKit = preload("res://scenes/ui/ui_kit.gd")
const Assets = preload("res://scripts/assets.gd")
const Economy = preload("res://scripts/economy.gd")

var font_size: int = 30
var color: Color = UIKit.GOLD
var coin_size: float = 34.0
var _pence: int = -1
var _epoch: int = -1


func _init(size_px: int = 30, col: Color = UIKit.GOLD) -> void:
	font_size = size_px
	color = col
	coin_size = roundf(size_px * 1.15)
	add_theme_constant_override("separation", 3)
	mouse_filter = Control.MOUSE_FILTER_PASS


func set_pence(pence: int) -> void:
	var e: int = GameManager.current_epoch
	if pence == _pence and e == _epoch:
		return
	_pence = pence
	_epoch = e
	for c in get_children():
		c.queue_free()
	var v: int = absi(pence)
	var pounds: int = v / Economy.PENCE_PER_POUND
	var shillings: int = (v % Economy.PENCE_PER_POUND) / Economy.PENCE_PER_SHILLING
	var d: int = v % Economy.PENCE_PER_SHILLING
	var victoria: bool = e >= 9 and Assets.user("coin_victoria_sovereign.png") != null
	var names := ["coin_victoria_sovereign.png", "coin_victoria_shilling.png", "coin_victoria_penny.png"] if victoria \
		else ["coin_guinea.png", "coin_shilling.png", "coin_halfpenny.png"]
	var parts: Array = []
	if pounds > 0:
		var ps := str(pounds)
		if pounds >= 10000:
			ps = Economy.group_thousands(pounds, "." if TranslationServer.get_locale().begins_with("de") else ",")
		parts.append([ps, names[0]])
	if shillings > 0:
		parts.append([str(shillings), names[1]])
	if d > 0 or parts.is_empty():
		parts.append([str(d), names[2] if v > 0 else names[0]])
	if pence < 0:
		add_child(_num("-"))
	for k in parts.size():
		if k > 0:
			var gap := Control.new()
			gap.custom_minimum_size.x = 8
			add_child(gap)
		add_child(_num(str(parts[k][0])))
		if Assets.user(str(parts[k][1])) != null:
			var ic := UIKit.icon("ui/user/" + str(parts[k][1]), coin_size)
			ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			add_child(ic)
	tooltip_text = Economy.format_lsd(pence) + "\n" + tr("UI_MONEY_TIP")


func _num(t: String) -> Label:
	var l := UIKit.label(t, font_size, color)
	l.mouse_filter = Control.MOUSE_FILTER_PASS
	return l
