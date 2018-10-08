extends Node2D

var timer
var sprite
var frame = 1
var count = 0

var ready = false

func _ready():
	timer = get_node("Timer")
	sprite = get_node("Sprite")
	get_node("Run").connect("button_down", self, "on_run")
	timer.connect("timeout", self, "on_timeout")
	get_node("Button").connect("button_down", self, "on_button")
	get_node("Button").hide()
	get_node("angry/AnimationPlayer").connect("animation_finished", self, "on_finished")
	get_node("Credits").hide()

func on_run():
	sprite.frame = frame
	frame += 1
	count += 1
	if count == 30:
		on_death()
	if frame >= sprite.hframes:
		frame = 1
	timer.start()

func on_timeout():
	sprite.frame = 0

func on_death():
	sprite.hide()
	get_node("Run").hide()
	get_node("Button").show()
	get_node("Credits").show()

func on_button():
	get_tree().change_scene("res://MainMenu.tscn")

func on_finished(name):
	get_node("angry").hide()