class_name StaffData
extends Resource
## Personal (Lastenheft 5.5)

@export var id: String = ""
@export var name_key: String = ""
@export var desc_key: String = ""
## Einstellungspreis in Pence
@export var price: int = 0
## Lohnanteil (Lehrling/Zuschläger: am Auftragslohn; Geselle: an eigenen Einnahmen)
@export var wage_share: float = 0.05
@export var min_epoch: int = 2
## Nur Zuschläger: Schlagkraft und Abstand zwischen zwei Schlägen
@export var p_base: float = 0.0
@export var hit_interval_s: float = 0.0
## Nur Geselle: Anteil an der Referenzleistung
@export var performance_share: float = 0.0
