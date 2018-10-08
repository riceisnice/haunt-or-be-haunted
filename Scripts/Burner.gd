extends "res://Scripts/SwipeArea.gd"

signal off_burner

var num

var clock = false

func _ready():
	num = get_tree().get_nodes_in_group("Burner").size()

func _process(delta):
	if clock:
		var string = "%.0f" % [get_node("Timer").time_left]
		get_node("Clock/Label").text = string
	else:
		get_node("Clock/Label").text = ""

func on_loop(pos):
	if rect.has_point(pos):
		emit_signal("off_burner")
		#print ("off_burner")
		clock = false
		get_node("Timer").stop()
		hide()

func on_activate():
	if !(randi()%num):
		#print ("on_burner")
		show()
		if !clock:
			get_node("Timer").start()
			clock = true