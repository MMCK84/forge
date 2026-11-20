extends RefCounted
## Werkstatt-Einrichtung (Konzept docs/Konzept_Aufbau.md): je Epoche fünf Plätze mit je einem
## zeit- und ortstypischen Stück. Die Art der Wirkung ist je Platz in allen Epochen gleich;
## mit dem Umzug in die nächste Epoche beginnt die Einrichtung von vorn.

const SLOTS := ["fuel", "tools", "bench", "trade", "light"]

## Wirkungen je Platz
const HEAT_FACTOR := 1.15          # fuel: Esse heizt schneller
const POWER_FACTOR := 1.10         # tools: Arbeitsfortschritt je Schlag
const BIG_FACTOR_MULT := 1.6       # tools ab Epoche 9 (Dreh-/Laufkran): Handarbeit an großen Stücken leichter
const BIG_FROM_EPOCH := 9
const WINDOW_BONUS := 25.0         # bench: Zielfenster je Seite breiter (°C)
const DAMAGE_FACTOR := 0.8         # bench: Gefügeschaden
const OFFERS_COUNT := 4            # trade: Angebote im Auftragsbuch
const REROLL_COOLDOWN_S := 30      # trade: Neu-Würfeln
const PAYOUT_FACTOR := 1.05        # light: Lohn
const RUIN_COST_FACTOR := 0.5      # light: Materialverlust bei Ausschuss

## Preis je Platz als Anteil der Einrichtungs-Basis der Epoche (Summe 0,40)
const PRICE_SHARE := {"fuel": 0.04, "tools": 0.06, "bench": 0.08, "trade": 0.09, "light": 0.13}
## Basis = Meistergebühr der Epoche (Epoche 10 hat keine: 1,5 × Gebühr von Epoche 9)
const LAST_EPOCH_BASE := 1440000
## Prämie der Zunft, wenn alle fünf Plätze eingerichtet sind (Anteil der Basis)
const COMPLETE_BONUS_SHARE := 0.04

## Platz in der Werkstatt (Bühnen-Koordinaten, Mitte unten des Stücks) und Größe der Darstellung
const ANCHORS := {
	"fuel": {"pos": Vector2(1000, 0), "floor": true, "size": Vector2(150, 120)},
	"tools": {"pos": Vector2(118, -330), "floor": true, "size": Vector2(170, 200)},
	"bench": {"pos": Vector2(955, -10), "floor": true, "size": Vector2(210, 150)},
	"trade": {"pos": Vector2(900, -420), "floor": true, "size": Vector2(170, 120)},
	"light": {"pos": Vector2(540, -560), "floor": true, "size": Vector2(70, 120)},
}

## Namen je Epoche und Platz: [deutsch, englisch]
const NAMES := {
	1: {"fuel": ["Holzkohlekorb", "Charcoal basket"], "tools": ["Zangenbrett", "Tong rack"],
		"bench": ["Schleifstein mit Kurbel", "Hand-cranked grindstone"], "trade": ["Bemaltes Brett mit Hufeisen über dem Tor", "Painted board with a horseshoe over the door"],
		"light": ["Talglaterne", "Tallow lantern"]},
	2: {"fuel": ["Kohlenkiste", "Coal chest"], "tools": ["Werkzeugwand mit Gesenken", "Tool wall with swages"],
		"bench": ["Werkbank mit Schraubstock", "Workbench with leg vice"], "trade": ["Schild „Smith & Farrier“ an der Straße", "“Smith & Farrier” sign by the road"],
		"light": ["Stabeisenregal", "Bar iron rack"]},
	3: {"fuel": ["Kohlenschütte", "Coal chute"], "tools": ["Gesenkblock", "Swage block"],
		"bench": ["Werkbank mit Feilen", "Workbench with files"], "trade": ["Anschlagtafel der Admiralität", "Admiralty notice board"],
		"light": ["Schiffslaterne", "Ship's lantern"]},
	4: {"fuel": ["Koksvorrat", "Coke store"], "tools": ["Zangenreihe für Klingen", "Row of blade tongs"],
		"bench": ["Schleifbock mit Wasserrad", "Water-driven grinding bench"], "trade": ["Firmenmarke der Cutlers' Company", "Cutlers' Company mark"],
		"light": ["Öllampen", "Oil lamps"]},
	5: {"fuel": ["Kohlenhund", "Coal tub"], "tools": ["Werkzeugwand mit Setzhämmern", "Tool wall with set hammers"],
		"bench": ["Drehbank mit Fußantrieb", "Treadle lathe"], "trade": ["Schreibpult mit Auftragsbuch", "Writing desk with order book"],
		"light": ["Stabeisenlager", "Bar iron store"]},
	6: {"fuel": ["Koksbunker", "Coke bunker"], "tools": ["Gesenksatz", "Set of swages"],
		"bench": ["Schraubstockbank", "Vice bench"], "trade": ["Kontor mit Schreiber", "Counting house with clerk"],
		"light": ["Öllampenreihe", "Row of oil lamps"]},
	7: {"fuel": ["Kohlenaufzug", "Coal hoist"], "tools": ["Normallehren und Schablonen", "Standard gauges and templates"],
		"bench": ["Werkbank mit Messschraube", "Workbench with micrometer"], "trade": ["Messingschild am Tor", "Brass plate at the gate"],
		"light": ["Gaslicht", "Gas lighting"]},
	8: {"fuel": ["Kohlenwagen auf Schienen", "Coal wagon on rails"], "tools": ["Gesenke für Kupplungen", "Coupling swages"],
		"bench": ["Prüfbank", "Proving bench"], "trade": ["Anschlag der Eisenbahngesellschaft", "Railway company notice"],
		"light": ["Gaslicht", "Gas lighting"]},
	9: {"fuel": ["Bunker mit Schütte", "Bunker with chute"], "tools": ["Drehkran", "Jib crane"],
		"bench": ["Prüfbank mit Lehren", "Proving bench with gauges"], "trade": ["Telegraf", "Telegraph"],
		"light": ["Gaslaternen", "Gas lamps"]},
	10: {"fuel": ["Gasgenerator", "Gas producer"], "tools": ["Laufkran", "Overhead travelling crane"],
		"bench": ["Werkstoff-Prüfmaschine", "Materials testing machine"], "trade": ["Kontor mit Telegraf", "Office with telegraph"],
		"light": ["Gaslicht und Bogenlampe", "Gas light and arc lamp"]},
}


static func item_id(epoch: int, slot: String) -> String:
	return "furn_e%d_%s" % [epoch, slot]


static func name_key(epoch: int, slot: String) -> String:
	return "FURN_E%d_%s" % [epoch, slot.to_upper()]


## Einrichtungs-Basis der Epoche (Meistergebühr bzw. Ersatzwert für die letzte Epoche).
static func base(cfg: BalanceConfig, epoch: int) -> int:
	if epoch >= 1 and epoch <= cfg.epoch_fees.size():
		return cfg.epoch_fees[epoch - 1]
	return LAST_EPOCH_BASE


static func price(cfg: BalanceConfig, epoch: int, slot: String) -> int:
	return maxi(1, int(round(float(base(cfg, epoch)) * float(PRICE_SHARE.get(slot, 0.1)))))


static func complete_bonus(cfg: BalanceConfig, epoch: int) -> int:
	return int(round(float(base(cfg, epoch)) * COMPLETE_BONUS_SHARE))


## Plätze in Kaufreihenfolge (günstigster zuerst).
static func slots_by_price() -> Array:
	var arr: Array = SLOTS.duplicate()
	arr.sort_custom(func(a, b): return float(PRICE_SHARE[a]) < float(PRICE_SHARE[b]))
	return arr


## Wirkungen einer Einrichtung (Liste der gekauften Plätze) als Werte für Simulation und Abrechnung.
static func effects(owned: Array, epoch: int) -> Dictionary:
	return {
		"heat_factor": HEAT_FACTOR if owned.has("fuel") else 1.0,
		"power_factor": POWER_FACTOR if owned.has("tools") else 1.0,
		"big_factor_mult": BIG_FACTOR_MULT if owned.has("tools") and epoch >= BIG_FROM_EPOCH else 1.0,
		"window_bonus": WINDOW_BONUS if owned.has("bench") else 0.0,
		"damage_factor": DAMAGE_FACTOR if owned.has("bench") else 1.0,
		"offers_count": OFFERS_COUNT if owned.has("trade") else -1,
		"reroll_cooldown_s": REROLL_COOLDOWN_S if owned.has("trade") else -1,
		"payout_factor": PAYOUT_FACTOR if owned.has("light") else 1.0,
		"ruin_cost_factor": RUIN_COST_FACTOR if owned.has("light") else 1.0,
	}
