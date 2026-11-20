extends RefCounted
## Meisterstück je Epoche (Kernausbau, docs/Roter_Faden.md): Der Abschluss-Meilenstein jeder Epoche
## wird zum mehrteiligen Meisterstück. Vor dem Hauptstück (dem Meilenstein selbst) kommen Vorarbeiten,
## die zusammen die Mechaniken des Kapitels abfragen. Jeder Teil ist ein eigener Auftrag; die Zunft
## prüft jeden Teil und verlangt mindestens MIN_STARS Sterne, sonst muss er neu geschmiedet werden.

const MIN_STARS := 2
## Nach so vielen nicht bestandenen Versuchen am selben Teil genügt ein Stern (keine Sackgasse)
const LENIENT_AFTER := 2


## Verlangte Sterne für einen Teil nach `fails` nicht bestandenen Versuchen.
static func required_stars(fails: int) -> int:
	return MIN_STARS if fails < LENIENT_AFTER else 1

## Abschluss-Meilenstein -> Vorarbeiten [item_id, Menge, präzise]
const PARTS := {
	# Epoche 1: Hitze, Arbeitsgänge, Präzision – Beschläge für die Kirchentür
	"ms_e1_05_church": [["door_hinge", 2, false]],
	# Epoche 2: Mengen – Beschläge und Hemmschuh für die Postkutsche, dann die Radreifen
	"ms_e2_07_tyres": [["coach_fitting", 3, false], ["drag_shoe", 1, false]],
	# Epoche 3: Feuerschweißen – Kette und Ring für den Anker
	"ms_e3_08_anchor": [["chain_link", 3, false], ["mooring_ring", 1, false]],
	# Epoche 4: Stahl und Härten, Präzision – Federn und Kette für die Victory
	"ms_e4_09_victory": [["spring", 2, false], ["cargo_chain", 2, false]],
	# Epoche 5: Maschine – Ventilteile und Pumpenstange für die Dampfmaschine
	"ms_e5_10_piston": [["valve_part", 2, false], ["pump_rod", 1, false]],
	# Epoche 6: Große Schmiedestücke – Nieten und Blattfeder für das Eisenwerk
	"ms_e6_11_ironworks": [["boiler_rivet", 4, false], ["leaf_spring", 1, false]],
	# Epoche 7: Präzision im Maschinenbau – Bolzen für die Kettenglieder der Menai-Brücke
	"ms_e7_09_menai": [["block_pin", 4, true]],
	# Epoche 8: Eisenbahn – Kupplungen und Puffer für die Schnellzuglok
	"ms_e8_09_express": [["coupling_hook", 2, false], ["buffer_spring", 2, false]],
	# Epoche 9: Dampfhammer – Nieten und Anker für die SS Great Britain
	"ms_e9_09_great_britain": [["bridge_rivet", 4, false], ["admiralty_anchor", 1, false]],
	# Epoche 10: Bessemer-Stahl – Achsen und Geschützringe vor der Hauptwelle
	"ms_e10_09_masterpiece": [["steel_axle", 2, false], ["gun_hoop", 2, false]],
}


static func is_masterpiece(ms_id: String) -> bool:
	return PARTS.has(ms_id)


## Anzahl Teile insgesamt (Vorarbeiten + Hauptstück), 1 bei gewöhnlichen Meilensteinen.
static func part_count(ms_id: String) -> int:
	return PARTS.get(ms_id, []).size() + 1


## Vorarbeit k (0-basiert) oder [] für das Hauptstück.
static func part(ms_id: String, k: int) -> Array:
	var arr: Array = PARTS.get(ms_id, [])
	return arr[k] if k >= 0 and k < arr.size() else []
