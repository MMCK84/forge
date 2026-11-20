extends Node
## Test-Runner. Aufruf (nach einmaligem Öffnen des Projekts im Editor):
##   godot --headless --path . res://tests/run_tests.tscn
## Beendet sich mit Exit-Code 0 (alles grün) bzw. 1.

const SUITES := [
	"res://tests/test_economy.gd",
	"res://tests/test_heat_model.gd",
	"res://tests/test_workshop_sim.gd",
	"res://tests/test_generator.gd",
	"res://tests/test_save.gd",
	"res://tests/test_furnishings.gd",
]


func _ready() -> void:
	# Tests dürfen den echten Spielstand nie überschreiben.
	SaveManager.save_blocked = true
	var total_checks := 0
	var all_failures: Array = []
	for path in SUITES:
		var suite = load(path).new()
		var methods: Array = []
		for m in suite.get_method_list():
			if str(m["name"]).begins_with("test_"):
				methods.append(str(m["name"]))
		for method_name in methods:
			suite.current = path.get_file() + "::" + method_name
			suite.call(method_name)
		total_checks += suite.checks
		all_failures.append_array(suite.failures)
		print("%-28s %3d Tests, %4d Prüfungen, %d Fehler" % [path.get_file(), methods.size(), suite.checks, suite.failures.size()])
	for f in all_failures:
		printerr("FEHLER  " + str(f))
	print("Gesamt: %d Prüfungen, %d Fehler" % [total_checks, all_failures.size()])
	GameManager.end_session()
	get_tree().quit(1 if all_failures.size() > 0 else 0)
