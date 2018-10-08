extends Sprite

signal moved(pos)
signal waited(place, next)
signal transition(dest)
signal inBath

enum {MAIN, TABLE, BATH, UPSTAIRS, DOWNSTAIRS, BASE, TOP, BEDROOM, BED, BASEUPSTAIRS, TOPDOWNSTAIRS}
enum {B1, L1, L2}

var flr
var loc
var transit = false
var r

var path
var ready = false
var start

var speed = 50

func _ready():
	loc = MAIN
	flr = L1
	get_node("Timer").connect("timeout", self, "on_timeout")

func _process(delta):
	var dir
	var t
	if transit and ready:
		move(path[0], delta)
		emit_signal("moved", position)
		if (position - start).length() >= (path[0] - start).length():
			start = position
			path.remove(0)
		if !path.size():
			ready = false
			transit = false
			match loc:
				MAIN: t = 3
				TABLE: t = 2
				BATH: 
					t = 5
					hide()
					emit_signal("inBath")
				UPSTAIRS: t = 2
				DOWNSTAIRS: t = 1
				BASE: t = 4
				TOP: t = 3
				BEDROOM: t = 3
				BED: t = 5
				BASEUPSTAIRS: t = 1
				TOPDOWNSTAIRS: t = 1
			startTimer(t)

func move(point, delta):
	translate((point - position).normalized() * delta * speed)

func on_navigate(p):
	path = p
	ready = true
	start = position

func startTimer(time):
	var t = get_node("Timer")
	t.wait_time = time
	t.start()

func on_timeout():
	match loc:
		MAIN:
			transit = true
			r = randi()%5
			match r:
				0: loc = UPSTAIRS
				1: loc = TABLE
				2: loc = DOWNSTAIRS
				3: loc = BATH
				_:
					transit = false
					startTimer(3)
			emit_signal("waited", MAIN, loc)
		TABLE:
			transit = true
			r = randi()%3
			match r:
				0: loc = UPSTAIRS
				1: loc = MAIN
				_:
					transit = false
					startTimer(1)
			emit_signal("waited", TABLE, loc)
		BATH:
			show()
			transit = true
			loc = MAIN
			emit_signal("waited", BATH, loc)
		UPSTAIRS:
			transit = true
			loc = TOP
			emit_signal("waited", UPSTAIRS, loc)
		DOWNSTAIRS:
			transit = true
			loc = BASE
			emit_signal("waited", DOWNSTAIRS, loc)
		BASE:
			transit = true
			r = randi()%2
			match r:
				0: loc = BASEUPSTAIRS
				1:
					transit = false
					startTimer(4)
			emit_signal("waited", BASE, loc)
		TOP:
			transit = true
			r = randi()%2
			match r:
				0: loc = TOPDOWNSTAIRS
				1: loc = BEDROOM
			emit_signal("waited", TOP, loc)
		BEDROOM:
			transit = true
			r = randi()%3
			match r:
				0: loc = BED
				1: loc = TOP
				2:
					transit = false
					startTimer(3)
			emit_signal("waited", BEDROOM, loc)
		BED:
			transit = true
			loc = BEDROOM
			emit_signal("waited", BED, loc)
		BASEUPSTAIRS:
			transit = true
			loc = MAIN
			emit_signal("waited", BASEUPSTAIRS, loc)
		TOPDOWNSTAIRS:
			transit = true
			loc = MAIN
			emit_signal("waited", TOPDOWNSTAIRS, loc)
	if transit:
		emit_signal("transition", loc)