extends RefCounted
## Zugriff auf gerenderte Assets (assets/…) mit Cache. Fehlt eine Datei (oder ist sie noch
## nicht importiert), wird null zurückgegeben und der Aufrufer nutzt seine Code-Grafik bzw. -Synthese.

const SPRITES := "res://assets/sprites/"
const AUDIO := "res://assets/audio/"
const FONTS := "res://assets/fonts/"

static var _cache: Dictionary = {}


static func _load(path: String) -> Resource:
	if _cache.has(path):
		return _cache[path]
	var res: Resource = null
	if ResourceLoader.exists(path):
		res = load(path)
	_cache[path] = res
	return res


static func tex(rel: String) -> Texture2D:
	return _load(SPRITES + rel) as Texture2D


## Werkstück-Sprite; eine Grafik des Auftraggebers (ui/user/item_<id>.png) hat Vorrang.
## Rohformen (Stufensprung), die sich mehrere Werkstücke teilen: nur dort, wo ein eigenes Bild nichts bringt,
## weil der Stand nach dem ersten Arbeitsgang gleich ist (Entscheidung des Auftraggebers, 21.11.).
## Werkstück → Werkstück, dessen Rohform mitbenutzt wird. Das Prompt-Heft liest diese Tabelle mit.
const ROUGH_SHARED := {
	"post_horseshoe": "horseshoe",
	"cargo_chain": "chain_link",
	"conveyor_chain": "chain_link",
	"ship_chain": "chain_link",
	"coupling_chain": "chain_link",
	"loco_tyre": "wheel_tyre",
	"gun_hoop": "wheel_tyre",
}


## Rohform eines Werkstücks: eigenes Bild, sonst die geteilte Rohform, sonst null.
static func rough_tex(item_id: String) -> Texture2D:
	var t := user("item_" + item_id + "_rough.png")
	if t == null and ROUGH_SHARED.has(item_id):
		t = user("item_" + str(ROUGH_SHARED[item_id]) + "_rough.png")
	return t


static func item_tex(item_id: String) -> Texture2D:
	var t := user("item_" + item_id + ".png")
	return t if t != null else tex("items/" + item_id + ".png")


## Kundenporträt; ein Bild des Auftraggebers (ui/user/portrait_<kunde>.png) hat Vorrang.
static func portrait(customer_id: String) -> Texture2D:
	var u := user("portrait_" + customer_id + ".png")
	return u if u != null else tex("portraits/" + customer_id + ".png")


static func background(epoch: int) -> Texture2D:
	return tex("environment/background_%d.jpg" % epoch)


static func sound(rel: String, loop: bool = false) -> AudioStream:
	var s := _load(AUDIO + rel) as AudioStream
	if s != null and loop and s is AudioStreamOggVorbis:
		(s as AudioStreamOggVorbis).loop = true
	return s


static func font(file: String) -> Font:
	return _load(FONTS + file) as Font


## Schrift für direkt gezeichnete Texte (draw_string): EB Garamond, sonst Godot-Standard.
static func ui_font() -> Font:
	var f := font("EBGaramond.ttf")
	return f if f != null else ThemeDB.fallback_font


## Grafiken des Auftraggebers (aufbereitet von tools/art/import_user_art.py)
static func user(name: String) -> Texture2D:
	return tex("ui/user/" + name)
