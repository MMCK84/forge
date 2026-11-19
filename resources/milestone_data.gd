class_name MilestoneData
extends Resource
## Handgeschriebener Story-Meilenstein (Lastenheft 3.5)

@export var id: String = ""
@export var epoch: int = 1
## Position innerhalb der Epoche (1..Anzahl); der letzte ist der Abschluss-Meilenstein
@export var index: int = 1
@export var item_id: String = ""
@export var customer_id: String = ""
@export var quantity: int = 1
@export var precision: bool = false
## Zusätzlicher Faktor auf die Form-Punkte (neben dem Gegenstands-Faktor)
@export var fp_factor: float = 1.0
