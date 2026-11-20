class_name MachineData
extends Resource
## Maschinen-Katalog (Lastenheft 5.4)

@export var id: String = ""
@export var tier: int = 1
@export var name_key: String = ""
@export var p_base: float = 100.0
@export var hits_per_s: float = 1.0
## Preis in Pence
@export var price: int = 0
## Betriebskosten in Pence je Betriebsminute (0 = keine)
@export var cost_per_minute: int = 0
## Leistung schwankt mit dem Wasserstand
@export var water_powered: bool = false
@export var min_epoch: int = 5
## "heavy": schlägt nur schwer (arbeitet nur in schweren Arbeitsgängen mit);
## "adjustable": schlägt mit der gewählten Schlagstärke (Dampfhammer nach Nasmyth)
@export var force_mode: String = "heavy"
