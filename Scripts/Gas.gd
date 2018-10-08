extends "res://Scripts/SwipeArea.gd"

signal block_gas

var covered = true

var limit = 4
var count = 0

var num

func _ready():
	num = get_tree().get_nodes_in_group("Gas").size()

func on_tap (pos):
	if rect.has_point(pos):
		count += 1
	if count > limit:
		covered = false
		#print("Gas_time")

func on_swipe (pos):
	if rect.has_point(pos) and !covered:
		emit_signal("block_gas")
		#print ("off_gas")
		count = 0
		hide()

func on_activate():
	if !(randi()%num):
		#print ("on_gas")
		show()