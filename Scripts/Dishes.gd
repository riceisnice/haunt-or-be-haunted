extends "res://Scripts/SwipeArea.gd"

signal break_dish

var num

func _ready():
	num = get_tree().get_nodes_in_group("Dishes").size()

func on_tap (pos):
	if rect.has_point(pos):
		emit_signal("break_dish")
		#print ("off_dish")
		hide()

func on_activate():
	if !(randi()%num):
		#print ("on_dish")
		show()