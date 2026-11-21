extends "res://scenes/ui/overlay.gd"
## Auftragsbuch (3.1, 6.3): 3 Angebote, Neu würfeln (60 s), aktiver Auftrag.
## Im Hochformat als Seite eines Kontorbuchs (Grafik des Auftraggebers), sonst Standardfenster.

const Economy = preload("res://scripts/economy.gd")
const Mastery = preload("res://scripts/mastery.gd")
const Seal = preload("res://scenes/ui/mastery_seal.gd")
const Masterpieces = preload("res://scripts/masterpieces.gd")
const Assets = preload("res://scripts/assets.gd")
## Kunden der Marine bekommen das Admiralitätssiegel
const NAVY := ["navy_board", "dockyard_chatham", "harbourmaster", "shipwright_portsmouth"]
## Beschreibbarer Bereich der Buchseite (Anteile der Grafik ledger_page.png)
const PAGE_RECT := Rect2(0.21, 0.065, 0.675, 0.77)
const BOOK_MAX_W := 700.0

var _reroll_btn: Button
var _book: Control
var _page_box: VBoxContainer


func _init() -> void:
	title_key = "UI_JOB_BOOK"
	panel_width = 1400.0


## Aufbau als Kontorbuch-Seite; ohne Grafik das Standardfenster (build()).
func build_custom(center: CenterContainer) -> bool:
	var tex := Assets.user("ledger_page.png")
	if tex == null:
		return false
	var vp := get_viewport_rect().size
	var w := minf(BOOK_MAX_W, vp.x - 16.0)
	var h := w * tex.get_height() / tex.get_width()
	if h > vp.y - 20.0:
		h = vp.y - 20.0
		w = h * tex.get_width() / tex.get_height()
	_book = Control.new()
	_book.custom_minimum_size = Vector2(w, h)
	center.add_child(_book)
	var bg := TextureRect.new()
	bg.texture = tex
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.size = Vector2(w, h)
	_book.add_child(bg)
	_page_box = VBoxContainer.new()
	_page_box.add_theme_constant_override("separation", 6)
	_page_box.position = PAGE_RECT.position * Vector2(w, h)
	_page_box.size = PAGE_RECT.size * Vector2(w, h)
	_book.add_child(_page_box)
	var x := UIKit.button("X", close, Vector2(56, 56), 26)
	x.tooltip_text = tr("UI_CLOSE") + UIKit.key_hint("Esc")
	x.position = Vector2(w - 72.0, 8.0)
	_book.add_child(x)
	_fill_page()
	return true


func _fill_page() -> void:
	var gm := GameManager
	var width := _page_box.size.x
	var head := UIKit.label(tr("UI_JOB_BOOK"), 34, UIKit.INK)
	var hf := UIKit.heading_font()
	if hf != null:
		head.add_theme_font_override("font", hf)
	_page_box.add_child(head)
	_page_box.add_child(UIKit.label(tr("UI_EPOCH_PROGRESS").format({"n": gm.jobs_completed_in_epoch, "total": gm.epoch_job_count()}), 18, UIKit.INK_LIGHT))
	if gm.free_play:
		_page_box.add_child(UIKit.wrap_label(tr("UI_FREE_PLAY_NOTE"), 18, UIKit.INK_LIGHT, width))
	if gm.active_job != null:
		_page_box.add_child(UIKit.wrap_label(tr("UI_ACTIVE_JOB") + ": " + gm.job_title(gm.active_job), 20, UIKit.INK, width))
		_page_box.add_child(UIKit.button(tr("UI_ABORT_JOB"), _confirm_abort, Vector2(240, 48), 19))
	_page_box.add_child(UIKit.hsep())
	var sc := ScrollContainer.new()
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_page_box.add_child(sc)
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 6)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(list)
	for i in gm.job_offers.size():
		list.add_child(_book_entry(i, gm.job_offers[i], width - 14.0))
		list.add_child(UIKit.hsep())
	_reroll_btn = UIKit.button(tr("UI_REROLL"), _reroll, Vector2(300, 52), 20)
	_reroll_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_page_box.add_child(_reroll_btn)
	_update_reroll()


## Ein Angebot als Eintrag im Kontorbuch (Porträt, Text, Siegel, Annehmen).
func _book_entry(i: int, j: JobInstance, width: float) -> Control:
	var gm := GameManager
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	var row := HBoxContainer.new()
	box.add_child(row)
	var ptex := Assets.portrait(j.customer_id)
	if ptex != null:
		var pr := TextureRect.new()
		pr.texture = ptex
		pr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		pr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		pr.custom_minimum_size = Vector2(72, 88)
		row.add_child(pr)
	var title := UIKit.wrap_label(gm.job_title(j), 24, UIKit.INK, width - 170.0)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(title)
	var seal_name := ""
	if j.is_milestone():
		# Königliches Siegel der Zeit: George III bis 1820 (Epoche 7), Victoria ab 1837 (Epoche 9)
		seal_name = "seal_victoria.png" if j.epoch >= 9 else "seal_george_iii.png"
	elif NAVY.has(j.customer_id):
		seal_name = "seal_admiralty.png"
	if seal_name != "" and Assets.user(seal_name) != null:
		var seal := TextureRect.new()
		seal.texture = Assets.user(seal_name)
		seal.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		seal.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		seal.custom_minimum_size = Vector2(70, 70)
		seal.tooltip_text = tr("TYPE_MILESTONE") if j.is_milestone() else tr("CUST_" + j.customer_id.to_upper())
		row.add_child(seal)
	if j.is_masterpiece():
		box.add_child(UIKit.wrap_label(tr("MP_HEAD").format({"title": tr("MS_" + j.milestone_id.to_upper() + "_TITLE")}), 20, UIKit.LEATHER, width))
	if j.is_milestone():
		box.add_child(UIKit.wrap_label(tr("MS_" + j.milestone_id.to_upper() + "_TEXT"), 18, UIKit.INK_LIGHT, width))
	if j.is_masterpiece():
		box.add_child(UIKit.wrap_label(_masterpiece_parts(j), 18, UIKit.INK, width))
		box.add_child(UIKit.wrap_label(tr("MP_RULE" if gm.masterpiece_required_stars(j.milestone_id) > 1 else "MP_RULE_LENIENT").format({"n": gm.masterpiece_required_stars(j.milestone_id)}), 18, UIKit.RED, width))
	var tags: PackedStringArray = [tr("TYPE_MASTERPIECE") if j.is_masterpiece() else tr("TYPE_" + j.type.to_upper())]
	if j.is_milestone() and j.precise:
		tags.append(tr("TYPE_PRECISION"))
	if j.category != "normal":
		tags.append(tr("CAT_" + j.category.to_upper()))
	if j.quantity > 1:
		tags.append(tr("UI_QUANTITY").format({"n": j.quantity}))
	box.add_child(UIKit.wrap_label(" · ".join(tags), 19, UIKit.LEATHER, width))
	var mlv := gm.mastery_level(j.template_id)
	var mrow := HBoxContainer.new()
	mrow.add_theme_constant_override("separation", 8)
	mrow.add_child(Seal.make(mlv, 30.0))
	var mtext := ""
	if mlv > 0:
		mtext = tr("UI_MASTERY_OFFER").format({"level": tr(Mastery.LEVEL_KEYS[mlv]), "p": int(round((Mastery.payout_factor(gm.cfg, mlv) - 1.0) * 100.0))})
	else:
		mtext = tr("UI_MASTERY_NEXT").format({"n": gm.mastery_jobs(j.template_id), "t": int(gm.cfg.mastery_jobs[0]), "level": tr(Mastery.LEVEL_KEYS[1])})
	mrow.add_child(UIKit.label(mtext, 18, UIKit.LEATHER if mlv > 0 else UIKit.INK_LIGHT))
	box.add_child(mrow)
	if not j.steps.is_empty():
		var names: PackedStringArray = []
		for st in j.steps:
			names.append(tr("STEP_" + str(st.get("id", "")).to_upper()))
		box.add_child(UIKit.wrap_label(tr("MAT_" + j.material.to_upper()) + ":  " + " – ".join(names), 18, UIKit.INK_LIGHT, width))
	var details := tr("UI_OFFER_DETAILS").format({
		"fp": Economy.group_thousands(j.form_points, "." if TranslationServer.get_locale().begins_with("de") else ","),
		"wage": Economy.format_lsd(j.reward_base_pence),
		"time": Economy.format_duration(j.estimate_s) if j.estimate_s >= 0.0 else "–",
	})
	if j.is_rush():
		details += "  ·  " + tr("UI_TIME_LIMIT").format({"time": Economy.format_duration(j.time_limit_s)})
	box.add_child(UIKit.wrap_label(details, 19, UIKit.INK, width))
	var issue := gm.job_requirement_issue(j)
	if issue != "":
		box.add_child(UIKit.wrap_label(tr(issue), 19, UIKit.RED, width))
	var accept := UIKit.button(tr("UI_ACCEPT") + (UIKit.key_hint(str(i + 1)) if i < 9 else ""), _accept.bind(i), Vector2(200, 52), 20)
	accept.disabled = gm.active_job != null or issue != ""
	accept.size_flags_horizontal = Control.SIZE_SHRINK_END
	box.add_child(accept)
	return box


func rebuild() -> void:
	if _book == null:
		super.rebuild()
		return
	for c in _page_box.get_children():
		c.queue_free()
	_fill_page.call_deferred()


## Standardfenster (ohne Buchgrafik): Angebote als Karten untereinander.
func build(box: VBoxContainer) -> void:
	var gm := GameManager
	if gm.active_job != null:
		box.add_child(UIKit.wrap_label(tr("UI_ACTIVE_JOB") + ": " + gm.job_title(gm.active_job), 22, UIKit.INK, UIKit.CW))
		box.add_child(UIKit.button(tr("UI_ABORT_JOB"), _confirm_abort, Vector2(240, 56), 20))
		box.add_child(UIKit.hsep())
	if gm.free_play:
		box.add_child(UIKit.wrap_label(tr("UI_FREE_PLAY_NOTE"), 20, UIKit.INK_LIGHT, UIKit.CW))
	for i in gm.job_offers.size():
		var j: JobInstance = gm.job_offers[i]
		var card := PanelContainer.new()
		var bgc := UIKit.PARCHMENT_DARK if not j.is_milestone() else Color("e3cf9a")
		card.add_theme_stylebox_override("panel", UIKit.panel_box(bgc, UIKit.BRASS if not j.is_milestone() else UIKit.GOLD, 3, 10, 12))
		card.add_child(_book_entry(i, j, UIKit.CW - 30.0))
		box.add_child(card)
	box.add_child(UIKit.label(tr("UI_EPOCH_PROGRESS").format({"n": gm.jobs_completed_in_epoch, "total": gm.epoch_job_count()}), 20, UIKit.INK_LIGHT))
	_reroll_btn = UIKit.button(tr("UI_REROLL"), _reroll, Vector2(320, 60))
	box.add_child(_reroll_btn)
	_update_reroll()


func _process(_delta: float) -> void:
	_update_reroll()


func _update_reroll() -> void:
	if _reroll_btn == null or not is_instance_valid(_reroll_btn):
		return
	var left := GameManager.reroll_seconds_left()
	_reroll_btn.disabled = left > 0
	_reroll_btn.text = (tr("UI_REROLL") + UIKit.key_hint("N")) if left <= 0 else tr("UI_REROLL_WAIT").format({"s": left})


## Zifferntasten nehmen das Angebot an (1 = oberstes), N = neue Angebote.
func _unhandled_key_input(event: InputEvent) -> void:
	var k := event as InputEventKey
	if k != null and k.pressed and not k.echo and not _stack.is_empty() and _stack.back() == self:
		var gm := GameManager
		var n := -1
		if k.keycode >= KEY_1 and k.keycode <= KEY_9:
			n = k.keycode - KEY_1
		elif k.keycode >= KEY_KP_1 and k.keycode <= KEY_KP_9:
			n = k.keycode - KEY_KP_1
		if n >= 0:
			if n < gm.job_offers.size() and gm.active_job == null and gm.job_requirement_issue(gm.job_offers[n]) == "":
				_accept(n)
			get_viewport().set_input_as_handled()
			return
		if k.keycode == KEY_N and _reroll_btn != null and is_instance_valid(_reroll_btn) and not _reroll_btn.disabled:
			_reroll_btn.pressed.emit()
			get_viewport().set_input_as_handled()
			return
	super._unhandled_key_input(event)


func _reroll() -> void:
	if GameManager.reroll_offers():
		rebuild()


func _accept(i: int) -> void:
	var err := GameManager.accept_offer(i)
	if err == "":
		close()
	else:
		rebuild()


func _confirm_abort() -> void:
	var p = load("res://scenes/ui/info_panel.gd").new()
	p.setup("UI_ABORT_JOB", tr("UI_ABORT_CONFIRM"), [[tr("UI_CANCEL"), Callable()], [tr("UI_ABORT_JOB"), _do_abort]])
	get_parent().add_child(p)


func _do_abort() -> void:
	GameManager.abort_job()
	rebuild()


## Teile des Meisterstücks mit Stand: ✔ fertig, ▶ jetzt, · noch offen.
func _masterpiece_parts(j: JobInstance) -> String:
	var gm := GameManager
	var names: PackedStringArray = []
	for k in j.parts:
		var item_id: String = gm.milestones[j.milestone_id].item_id
		var qty: int = gm.milestones[j.milestone_id].quantity
		var pt: Array = Masterpieces.part(j.milestone_id, k)
		if not pt.is_empty():
			item_id = str(pt[0])
			qty = int(pt[1])
		var mark := "✔" if k + 1 < j.part else ("▶" if k + 1 == j.part else "·")
		var name := gm.item_name(item_id, qty > 1)
		names.append("%s %s%s" % [mark, ("%d× " % qty) if qty > 1 else "", name])
	return "   ".join(names)
