extends Timer

signal dishes
signal lock
signal burner
signal candle
signal knife
signal pot
signal puddle
signal gas
signal light

signal toggle

export var level = 3
var r

enum {DISHES, LOCK, BURNER, CANDLE, KNIFE, POT, PUDDLE, GAS, LIGHT, NONE}

func _ready():
	connect("timeout", self, "on_timeout")

func on_timeout():
	r = randi()%(level * 3)
	#r = POT
	#print (r)
	match r:
		DISHES:
			emit_signal("dishes")
		LOCK:
			emit_signal("lock")
		BURNER:
			emit_signal("burner")
		CANDLE:
			emit_signal("candle")
		KNIFE:
			emit_signal("knife")
		POT:
			emit_signal("pot")
		PUDDLE:
			emit_signal("puddle")
		GAS:
			emit_signal("gas")
		LIGHT:
			emit_signal("light")
	emit_signal("toggle")