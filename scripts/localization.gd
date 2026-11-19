extends RefCounted
## Lädt localization/translations.csv zur Laufzeit (Spalten: keys, de, en, ...).
## Die CSV wird mit dem Importer "keep" unverändert exportiert, damit weitere Sprachen
## ohne Codeänderung ergänzt werden können (Lastenheft 9.3).

const CSV_PATH := "res://localization/translations.csv"

static var _loaded: bool = false
static var languages: PackedStringArray = []


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
			if text != "":
				translations[col - 1].add_message(row[0], text)
	for t in translations:
		TranslationServer.add_translation(t)


## Übersetzt einen Schlüssel mit Platzhaltern {name}.
static func trf(key: String, args: Dictionary = {}) -> String:
	var s: String = str(TranslationServer.translate(key))
	return s.format(args)
