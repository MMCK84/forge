class_name ItemData
extends Resource
## Basis-Gegenstand für den Auftrags-Generator (Lastenheft 3.2)

## Kategorien: "normal", "weld" (Feuerschweißen), "harden" (Härten), "big" (Großschmiedestück)
@export var id: String = ""
@export var epoch: int = 1
@export var factor: float = 1.0
@export_enum("normal", "weld", "harden", "big") var category: String = "normal"
## Platzhalter-Sprite (Grundform), siehe scripts/item_shapes.gd
@export var shape: String = "bar"
@export var allow_quantity: bool = true
## Werkstoff: "iron" (Schmiedeeisen) oder "steel" (Stahl: kühler schmieden, verbrennt früher)
@export_enum("iron", "steel") var material: String = "iron"
## Arbeitsgänge in Reihenfolge: [{"id": "draw", "share": 0.5}, ...]; Anteile ergeben zusammen 1.
## Bei Schweißgegenständen liegt eine Grenze genau bei weld_at_progress (dort wird geschweißt).
@export var steps: Array = []
