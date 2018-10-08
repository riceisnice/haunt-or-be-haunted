extends Node2D

var clock_start

var time_start = 0
var time_now = 0

func _ready():
	clock_start = int(get_node("Timer").wait_time)
	time_start = OS.get_unix_time()
	set_process(true)

func _process(delta):
	time_now = OS.get_unix_time()
	var elapsed = time_now - time_start
	#var minutes = (clock_start / 60) - (elapsed / 60)
	#var seconds = (clock_start % 60) - (elapsed % 60)
	var minutes = (clock_start - elapsed) / 60
	var seconds = (clock_start - elapsed) % 60
	var str_elapsed = "%01d : %02d" % [minutes, seconds]
	get_node("Label").text = str_elapsed