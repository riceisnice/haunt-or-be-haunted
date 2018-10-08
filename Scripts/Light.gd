extends "res://Scripts/SwipeArea.gd"

signal on_light
signal toggle

var light_on = true
var active = false

var limit = 4
var count = 0

var num

func _ready():
	num = get_tree().get_nodes_in_group("Light").size()

func on_tap (pos):
	if rect.has_point(pos) and active:
		count += 1
		light_on = true
		get_node("Timer").stop()
		get_node("Basement_dark").hide()
		hide()
	if count > limit:
		emit_signal("on_light")
		#print ("on_light")
		active = false
		count = 0
		get_node("Basement_dark").hide()
		hide()

func on_toggle():
	emit_signal("toggle")
	if active:
		get_node("Basement_dark").show()
		show()

func on_activate():
	if !(randi()%num):
		#print ("off_light")
		active = true
		get_node("Basement_dark").show()
		show()