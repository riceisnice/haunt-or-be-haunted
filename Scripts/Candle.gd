extends "res://Scripts/SwipeArea.gd"

signal off_candle

var limit = 4
var count = 0

var num
var clock = false

func _ready():
	num = get_tree().get_nodes_in_group("Candle").size()

func _process(delta):
	if clock:
		var string = "%.0f" % [get_node("Timer").time_left]
		get_node("Clock/Label").text = string
	else:
		get_node("Clock/Label").text = ""

func on_loop(pos):
	if rect.has_point(pos):
		count += 1
	if count > limit:
		emit_signal("off_candle")
		#print ("off_candle")
		count = 0
		clock = false
		get_node("Timer").stop()
		hide()

func on_activate():
	if !(randi()%num):
		#print ("on_candle")
		show()
		if !clock:
			get_node("Timer").start()
			clock = true