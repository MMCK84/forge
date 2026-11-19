extends RefCounted
## Minimales Test-Gerüst (ohne externe Abhängigkeit). Testmethoden beginnen mit "test_".

var failures: Array = []
var checks: int = 0
var current: String = ""


func assert_true(cond: bool, msg: String = "") -> void:
	checks += 1
	if not cond:
		failures.append("%s: %s" % [current, msg])


func assert_eq(actual, expected, msg: String = "") -> void:
	checks += 1
	if typeof(actual) != typeof(expected) and not (typeof(actual) in [TYPE_INT, TYPE_FLOAT] and typeof(expected) in [TYPE_INT, TYPE_FLOAT]):
		failures.append("%s: %s – erwartet %s (%s), erhalten %s (%s)" % [current, msg, str(expected), type_string(typeof(expected)), str(actual), type_string(typeof(actual))])
	elif actual != expected:
		failures.append("%s: %s – erwartet %s, erhalten %s" % [current, msg, str(expected), str(actual)])


func assert_near(actual: float, expected: float, eps: float, msg: String = "") -> void:
	checks += 1
	if absf(actual - expected) > eps:
		failures.append("%s: %s – erwartet %.4f ± %.4f, erhalten %.4f" % [current, msg, expected, eps, actual])
