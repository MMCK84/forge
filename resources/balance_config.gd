class_name BalanceConfig
extends Resource
## Alle Balancing-Konstanten des Spiels (Lastenheft 5.8 / 8.4).
## Werte werden ausschließlich in data/balance/balance_config.tres gepflegt.

@export_group("Temperatur (2.3)")
@export var room_temp: float = 20.0
@export var k_cool: float = 15.0
@export var transfer_time: float = 0.5
## Oberhalb von Gelbglut (optimal_max) heizt jede Esse höchstens so schnell (°C/s): Weißglut strahlt viel
## Wärme ab – und das Schweißfenster (1200–1300 °C) bleibt auch mit schnellen Essen gut zwei Sekunden offen.
@export var white_heat_rate: float = 60.0

@export_group("Schlagwirkung M(T) (2.4)")
@export var cold_limit: float = 400.0
@export var optimal_min: float = 700.0
@export var optimal_max: float = 1100.0
@export var burn_limit: float = 1300.0
@export var warm_min_mult: float = 0.1
@export var overheat_min_mult: float = 0.5

@export_group("Gefügeschaden (2.5)")
@export var cold_hit_damage: float = 0.02
@export var overheat_damage_per_s: float = 0.06
@export var damage_warning: float = 0.5
@export var ruin_material_cost: float = 0.2

@export_group("Qualität & Sterne (2.6)")
@export var q_damage_weight: float = 0.5
@export var precision_window_min: float = 850.0
@export var precision_window_max: float = 1000.0
## Schwellen für 1, 2, 3 Sterne
@export var star_thresholds: PackedFloat32Array = PackedFloat32Array([0.55, 0.75, 0.90])
## Lohnfaktor für 0, 1, 2, 3 Sterne
@export var star_factor_standard: PackedFloat32Array = PackedFloat32Array([0.70, 0.90, 1.00, 1.10])
@export var star_factor_precision: PackedFloat32Array = PackedFloat32Array([0.60, 0.85, 1.00, 1.25])

@export_group("Eingabe (2.7)")
@export var reference_hits_per_s: float = 5.0
@export var max_hits_per_s: float = 8.0
@export var hold_hits_per_s: float = 4.0

@export_group("Auftragsbuch (3.1)")
@export var offers_count: int = 3
@export var reroll_cooldown_s: int = 60
@export var tutorial_standard_only_jobs: int = 4
## Eilaufträge erscheinen in ihrer ersten Epoche erst ab diesem Fortschritt (0..1) der Epoche
@export var rush_from_epoch: int = 2
@export var rush_from_grade: float = 0.5
## Gewichte [Standard, Präzision, Eil] je Epoche 1..6
@export var type_weights: Array = [[80, 20, 0], [60, 20, 20], [60, 20, 20], [45, 35, 20], [60, 20, 20], [60, 20, 20], [55, 25, 20], [60, 20, 20], [60, 20, 20], [55, 25, 20]]
## Wahrscheinlichkeit für Mengenaufträge je Epoche
@export var quantity_chance: PackedFloat32Array = PackedFloat32Array([0.0, 0.35, 0.35, 0.35, 0.35, 0.30, 0.35, 0.40, 0.30, 0.30])
@export var quantity_values: PackedInt32Array = PackedInt32Array([2, 3, 4, 6, 8, 12])
@export var quantity_weights: PackedFloat32Array = PackedFloat32Array([30, 25, 20, 12, 8, 5])
## Anteil Schweiß-/Härte-/Großschmiedeaufträge je Epoche
@export var weld_share: PackedFloat32Array = PackedFloat32Array([0.0, 0.0, 0.40, 0.30, 0.30, 0.25, 0.20, 0.25, 0.20, 0.15])
@export var harden_share: PackedFloat32Array = PackedFloat32Array([0.0, 0.0, 0.0, 0.35, 0.30, 0.20, 0.20, 0.15, 0.15, 0.30])
@export var big_share: PackedFloat32Array = PackedFloat32Array([0.0, 0.0, 0.0, 0.0, 0.0, 0.30, 0.15, 0.25, 0.35, 0.35])

@export_group("Steigende Komplexität")
## Innerhalb einer Epoche wächst der Komplexitätsgrad c = n / (N_e − 1) von 0 auf 1.
## Seltene Merkmale (Präzision, Eile, Spezialaufträge, Mengen) werden mit diesem Faktor gewichtet:
## am Epochenanfang × ramp_min, am Ende × ramp_max (im Mittel × 1).
@export var complexity_ramp_min: float = 0.3
@export var complexity_ramp_max: float = 1.7
## Breite der Gegenstands-Auswahl um den aktuellen Grad (0..1, nach Komplexität sortiert)
@export var item_complexity_spread: float = 0.5
## Qualitätsgewichte [Einfach, Solide, Fein, Meisterlich] am Anfang und am Ende einer Epoche
@export var quality_weights_start: PackedFloat32Array = PackedFloat32Array([55, 40, 5, 0])
@export var quality_weights_end: PackedFloat32Array = PackedFloat32Array([5, 35, 40, 20])

@export_group("Qualitätsstufen (3.2)")
## Jede Stufe: id, fp, wage, weight, min_epoch
@export var quality_tiers: Array = [
	{"id": "simple", "fp": 0.8, "wage": 0.75, "weight": 30.0, "min_epoch": 1},
	{"id": "solid", "fp": 1.0, "wage": 1.0, "weight": 45.0, "min_epoch": 1},
	{"id": "fine", "fp": 1.25, "wage": 1.4, "weight": 20.0, "min_epoch": 1},
	{"id": "masterly", "fp": 1.6, "wage": 2.0, "weight": 5.0, "min_epoch": 2},
]

@export_group("Skalierung (3.3)")
@export var epoch_job_counts: PackedInt32Array = PackedInt32Array([30, 40, 50, 50, 60, 70, 50, 55, 60, 60])
@export var fp_start: PackedFloat32Array = PackedFloat32Array([300, 1800, 6000, 12000, 25000, 40000, 60000, 100000, 180000, 300000])
@export var rate_per_fp: PackedFloat32Array = PackedFloat32Array([0.040, 0.040, 0.035, 0.045, 0.050, 0.065, 0.096, 0.0873, 0.0711, 0.064])
@export var scale_per_epoch: float = 5.0
@export var free_play_exponent_cap: float = 1.5

@export_group("Auftragstypen (3.3/3.4)")
@export var type_factor_standard: float = 1.0
@export var type_factor_precision: float = 1.2
@export var type_factor_rush: float = 1.5
@export var type_factor_rush_late: float = 0.5
@export var type_factor_milestone: float = 2.0
@export var milestone_fp_factor: float = 1.5
@export var rush_min_time_s: float = 45.0
@export var rush_time_factor: float = 1.5

@export_group("Arbeitsgänge & Werkstoffe")
## Zielfenster je Arbeitsgang für Schmiedeeisen [min, max] in °C
@export var step_windows: Dictionary = {
	"draw": [950.0, 1100.0], "upset": [1000.0, 1100.0], "flatten": [850.0, 1050.0],
	"point": [850.0, 1000.0], "punch": [800.0, 950.0], "bend": [750.0, 900.0],
	"twist": [750.0, 900.0], "cut": [900.0, 1050.0], "planish": [700.0, 850.0],
}
## Stahl wird um diesen Betrag kühler geschmiedet; alle Temperaturgrenzen (M(T), Schaden, Verbrennen) verschieben sich mit
@export var steel_temp_offset: float = 50.0
## Präzisionsaufträge nutzen nur den mittleren Teil des Zielfensters
@export var precision_window_keep: float = 0.6

@export_group("Schlagstärke")
## Verlangte Schlagstärke je Arbeitsgang: 0 = leicht, 1 = mittel, 2 = schwer
@export var step_force: Dictionary = {
	"draw": 2, "upset": 2, "punch": 2, "flatten": 1, "point": 1, "cut": 1,
	"bend": 0, "twist": 0, "planish": 0,
}
## Wirkung (Anteil der Form-Punkte) bei falscher Stärke
@export var force_gain_off_one: float = 0.55
@export var force_gain_too_soft: float = 0.25
@export var force_gain_too_hard: float = 0.30
## Gefügeschaden je Schlag, wenn schwer statt leicht geschlagen wird
@export var force_too_hard_damage: float = 0.06
## Bis einschließlich dieser Epoche verlangen „mittlere“ Arbeitsgänge „schwer“ (leichter Einstieg)
@export var force_simple_until_epoch: int = 1
## Geschätzter Anteil schwerer Arbeitsgänge (Gesellen-Leistung mit Schwanzhammer/Zuschläger)
@export var heavy_work_share: float = 0.5
## Heizer: Faktor auf die Aufheizrate der Esse
@export var stoker_heat_factor: float = 1.25

@export_group("Feuerschweißen (4.4.1)")
@export var weld_at_progress: float = 0.5
@export var weld_hits_required: int = 6
@export var weld_min: float = 1200.0
@export var weld_max: float = 1300.0
@export var weld_forge_min_tmax: float = 1250.0
@export var precision_forge_min_tmax: float = 1000.0

@export_group("Härten (4.4.2)")
@export var quench_good_min: float = 760.0
@export var quench_good_max: float = 840.0
@export var quench_ok_min: float = 700.0
@export var quench_ok_max: float = 900.0
@export var quench_uneven_penalty: float = 0.15
@export var quench_bad_penalty: float = 0.35

@export_group("Maschinen (4.4.3/4.4.4)")
@export var water_level_min: float = 0.6
@export var water_level_max: float = 1.0
@export var water_change_min_s: float = 180.0
@export var water_change_max_s: float = 300.0
@export var big_manual_factor: float = 0.25
## Maschinen und Zuschläger schlagen nur auf Eisen ab dieser Temperatur
@export var auto_hit_min_temp: float = 400.0

@export_group("Wirtschaft (5.2/5.6/5.7)")
@export var upgrade_base: PackedInt32Array = PackedInt32Array([30, 120, 400, 1500, 5000, 15000, 30000, 60000, 120000, 240000])
@export var upgrade_growth: float = 1.4
@export var upgrade_step: float = 0.1
@export var upgrade_max_level: int = 10
## Meistergebühr für den Wechsel in Epoche 2..10 (Index 0 = 1→2)
@export var epoch_fees: PackedInt32Array = PackedInt32Array([480, 2400, 9600, 36000, 96000, 240000, 360000, 600000, 960000])
@export var offline_max_s: float = 28800.0
@export var journeyman_payout_interval_s: float = 10.0

@export_group("Referenzspieler (5.8)")
@export var ref_return_temp: float = 700.0
@export var ref_take_temp: float = 1100.0
@export var ref_move_loss_s: float = 1.0

@export_group("Personal (5.5)")
@export var apprentice_to_forge_below: float = 750.0
@export var apprentice_to_anvil_at: float = 1050.0

@export_group("Speichern (7.3)")
@export var autosave_interval_s: float = 60.0
