class_name JobInstance
extends RefCounted
## Laufzeitobjekt eines Auftrags (Angebot oder aktiver Auftrag).
## Alle Werte (Form-Punkte, Lohn, Zeitlimit) werden beim Erzeugen fest berechnet
## und im Spielstand gespeichert (Lastenheft 3.2).

const TYPE_STANDARD := "standard"
const TYPE_PRECISION := "precision"
const TYPE_RUSH := "rush"
const TYPE_MILESTONE := "milestone"

const LOC_RAW := "raw"
const LOC_FORGE := "forge"
const LOC_ANVIL := "anvil"
const LOC_DONE := "done"


class Piece:
	extends RefCounted
	var progress: float = 0.0
	var temp: float = 20.0
	var location: String = "raw"
	var damage: float = 0.0
	var points_in_window: float = 0.0
	var weld_hits: int = 0
	## Abzug auf Q durch das Härten (0 = kein Abzug)
	var quench_penalty: float = 0.0
	var quenched: bool = false
	## Esse-Platz (nur gültig bei location == "forge")
	var slot: int = -1

	func to_dict() -> Dictionary:
		return {
			"progress": progress, "temp": temp, "location": location, "damage": damage,
			"points_in_window": points_in_window, "weld_hits": weld_hits,
			"quench_penalty": quench_penalty, "quenched": quenched, "slot": slot,
		}

	static func from_dict(d: Dictionary) -> Piece:
		var p := Piece.new()
		p.progress = float(d.get("progress", 0.0))
		p.temp = float(d.get("temp", 20.0))
		p.location = str(d.get("location", "raw"))
		if not p.location in ["raw", "forge", "anvil", "done"]:
			p.location = "raw"
		p.damage = float(d.get("damage", 0.0))
		p.points_in_window = float(d.get("points_in_window", 0.0))
		p.weld_hits = int(d.get("weld_hits", 0))
		p.quench_penalty = float(d.get("quench_penalty", 0.0))
		p.quenched = bool(d.get("quenched", false))
		p.slot = int(d.get("slot", -1))
		return p


var uid: String = ""
var template_id: String = ""
var quality: String = "solid"
var customer_id: String = ""
var type: String = TYPE_STANDARD
var quantity: int = 1
## Gesamt-Form-Punkte (gleichmäßig auf die Stücke verteilt)
var form_points: int = 0
## Lohn in Pence bei 2 Sternen und rechtzeitiger Lieferung (inkl. Typfaktor)
var reward_base_pence: int = 0
## Zeitlimit in Sekunden (nur Eilaufträge), sonst -1
var time_limit_s: float = -1.0
var elapsed_s: float = 0.0
var category: String = "normal"
var epoch: int = 1
var milestone_id: String = ""
## Enges Zielfenster (Präzisionsaufträge und Präzisions-Meilensteine)
var precise: bool = false
## Geschätzte Dauer laut Referenzmodell (Anzeige im Auftragsbuch)
var estimate_s: float = 0.0
## Während der Arbeit angefallene Kosten (Ausschuss, Betriebskosten) in Pence
var costs_pence: int = 0
## Letzte Abschrecktemperatur (Anzeige)
var quench_temp: float = -1.0
var pieces: Array = []


func is_milestone() -> bool:
	return type == TYPE_MILESTONE


func is_precision() -> bool:
	return type == TYPE_PRECISION or precise


func is_rush() -> bool:
	return type == TYPE_RUSH


func needs_weld() -> bool:
	return category == "weld"


func needs_harden() -> bool:
	return category == "harden"


func is_big() -> bool:
	return category == "big"


func piece_fp() -> float:
	return float(form_points) / float(maxi(1, quantity))


func is_late() -> bool:
	return is_rush() and time_limit_s > 0.0 and elapsed_s > time_limit_s


func reset_pieces(room_temp: float) -> void:
	pieces.clear()
	for i in quantity:
		var p := Piece.new()
		p.temp = room_temp
		pieces.append(p)


func pieces_done() -> int:
	var n := 0
	for p in pieces:
		if p.location == LOC_DONE:
			n += 1
	return n


func all_done() -> bool:
	return pieces.size() > 0 and pieces_done() == pieces.size()


func duplicate_offer() -> JobInstance:
	return from_dict(to_dict())


func to_dict(include_pieces: bool = true) -> Dictionary:
	var d := {
		"uid": uid, "template_id": template_id, "quality": quality,
		"customer_id": customer_id, "type": type, "quantity": quantity,
		"form_points": form_points, "reward_base_pence": reward_base_pence,
		"time_limit_s": (time_limit_s if time_limit_s > 0.0 else null),
		"category": category, "epoch": epoch, "milestone_id": milestone_id,
		"precise": precise, "estimate_s": estimate_s,
	}
	if include_pieces:
		d["elapsed_s"] = elapsed_s
		d["costs_pence"] = costs_pence
		d["quench_temp"] = (quench_temp if quench_temp >= 0.0 else null)
		var weld := 0
		var arr: Array = []
		for p in pieces:
			arr.append(p.to_dict())
			weld += p.weld_hits
		d["weld_hits"] = weld
		d["pieces"] = arr
	return d


static func from_dict(d: Dictionary) -> JobInstance:
	var j := JobInstance.new()
	j.uid = str(d.get("uid", ""))
	j.template_id = str(d.get("template_id", ""))
	j.quality = str(d.get("quality", "solid"))
	j.customer_id = str(d.get("customer_id", ""))
	j.type = str(d.get("type", TYPE_STANDARD))
	j.quantity = maxi(1, int(d.get("quantity", 1)))
	j.form_points = int(d.get("form_points", 0))
	j.reward_base_pence = int(d.get("reward_base_pence", 0))
	var tl = d.get("time_limit_s", null)
	j.time_limit_s = float(tl) if tl != null else -1.0
	j.elapsed_s = float(d.get("elapsed_s", 0.0))
	j.costs_pence = int(d.get("costs_pence", 0))
	j.category = str(d.get("category", "normal"))
	j.epoch = int(d.get("epoch", 1))
	j.milestone_id = str(d.get("milestone_id", ""))
	j.estimate_s = float(d.get("estimate_s", 0.0))
	j.precise = bool(d.get("precise", j.type == TYPE_PRECISION))
	var qt = d.get("quench_temp", null)
	j.quench_temp = float(qt) if qt != null else -1.0
	j.pieces.clear()
	var arr = d.get("pieces", [])
	if arr is Array:
		for pd in arr:
			if pd is Dictionary:
				j.pieces.append(Piece.from_dict(pd))
	return j
