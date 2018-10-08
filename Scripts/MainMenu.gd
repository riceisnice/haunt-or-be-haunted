extends Node2D

var splash

func _ready():
	splash = get_node("Splash")
	get_node("Go").connect("button_down", self, "on_go")

func on_go():
	get_tree().change_scene("res://TestRoom.tscn")