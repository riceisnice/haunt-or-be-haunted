extends "res://Scripts/SwipeArea.gd"

signal mop_floor

var limit = 3
var count = 0

var num

func _ready():
	num = get_tree().get_nodes_in_group("Puddle").size()

func on_swipe (pos):
	if rect.has_point(pos):
		count += 1
	if count > limit:
		emit_signal("mop_floor")
		#print ("mop_floor")
		count = 0
		hide()

func on_activate():
	if !(randi()%num):
		#print ("wet_floor")
		show()