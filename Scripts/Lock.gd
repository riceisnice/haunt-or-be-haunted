extends "res://Scripts/SwipeArea.gd"

signal unlock_door

var limit = 8
var count = 0

var num
var active = false

func _ready():
	num = get_tree().get_nodes_in_group("Lock").size()

func on_tap (pos):
	if rect.has_point(pos):
		count += 1
		if count > limit:
			emit_signal("unlock_door")
			#print ("unlock_door")
			count = 0
			hide()

func on_activate():
	if !(randi()%num):
		#print ("lock_door")
		active = true

func on_enter():
	if active:
		show()