extends "res://Scripts/SwipeArea.gd"

signal break_pot

var num
var ready = false
var active = false

func _ready():
	num = get_tree().get_nodes_in_group("Pot").size()
	get_node("Timer").connect("timeout", self, "on_timeout")

func on_swipe (pos):
	if rect.has_point(pos):
		emit_signal("break_pot")
		ready = false
		active = false
		#print ("break_pot")
		hide()

func on_activate():
	if !(randi()%num):
		if !active:
			#print ("drop_pot")
			get_node("Timer").start()
			active = true
			show()

func on_timeout():
	ready = true
	print("ready")