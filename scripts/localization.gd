extends RefCounted
## Lädt localization/translations.csv zur Laufzeit (Spalten: keys, de, en, ...).
## Die CSV wird mit dem Importer "keep" unverändert exportiert, damit weitere Sprachen
## ohne Codeänderung ergänzt werden können (Lastenheft 9.3).

const CSV_PATH := "res://localization/translations.csv"

static var _loaded: bool = false
static var languages: PackedStringArray = []
## Zum Testen der Handy-Fassung am Rechner: Startparameter „-- --touch“
static var force_touch: bool = false


## Handy/Tablet: keine Tastenhinweise. Am Rechner (auch mit Touchscreen) stehen sie immer dabei.
static func is_touch() -> bool:
	return force_touch or OS.has_feature("mobile") or OS.get_cmdline_user_args().has("--touch")


## Entfernt Tastenhinweise aus einem Text und macht aus „Klickt“ ein „Tippt“ (Handy-Fassung).
static func touch_text(text: String) -> String:
	var t := text
	for pair in [[" – Klick / Leertaste", ""], [" – click / space", ""],
			[" (am Rechner auch mit den Pfeiltasten ← und →)", ""], [" (arrow keys ← and → on a computer)", ""],
			[" (Pfeiltasten ← ↓ →)", ""], [" (arrow keys ← ↓ →)", ""],
			[" (oder die Leertaste)", ""], [" (or the space bar)", ""],
			[" oder drückt die Leertaste", ""], [" or press the space bar", ""]]:
		t = t.replace(pair[0], pair[1])
	var re := RegEx.new()
	re.compile("\\s*(oder drückt |or press )?\\[(?:[A-ZÄÖÜ0-9]|Esc|F\\d+|Enter|Leertaste|Space|[←↑↓→])\\]")
	t = re.sub(t, "", true)
	for pair in [["Klickt", "Tippt"], ["klickt", "tippt"], ["Klick", "Tipp"], ["Click", "Tap"], ["click", "tap"]]:
		t = t.replace(pair[0], pair[1])
	return t.replace(" .", ".").replace(" ,", ",").replace("  ", " ")


static func load_translations() -> void:
	if _loaded:
		return
	_loaded = true
	var f := FileAccess.open(CSV_PATH, FileAccess.READ)
	if f == null:
		push_error("Übersetzungen nicht gefunden: " + CSV_PATH)
		return
	var header := f.get_csv_line()
	var translations: Array = []
	for col in range(1, header.size()):
		var t := Translation.new()
		t.locale = header[col].strip_edges()
		translations.append(t)
		languages.append(t.locale)
	while not f.eof_reached():
		var row := f.get_csv_line()
		if row.size() < 2 or row[0].strip_edges() == "" or row[0].begins_with("#"):
			continue
		for col in range(1, mini(row.size(), header.size())):
			var text: String = row[col].replace("\\n", "\n")
			if is_touch():
				text = touch_text(text)
			if text != "":
				translations[col - 1].add_message(row[0], text)
	for t in translations:
		TranslationServer.add_translation(t)


## Übersetzt einen Schlüssel mit Platzhaltern {name}.
static func trf(key: String, args: Dictionary = {}) -> String:
	var s: String = str(TranslationServer.translate(key))
	return s.format(args)
