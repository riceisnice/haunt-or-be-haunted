extends "res://Scripts/SwipeArea.gd"

signal remove_knife
signal uncover_bed
signal cover_bed

var covered = true
var active = false

var num

var blade
var hide

func _ready():
	num = get_tree().get_nodes_in_group("Knife").size()
	blade = load ("res://Sprites/Blade.png")
	hide = load("res://Sprites/Knife.png")

func on_swipe (pos):
	if rect.has_point(pos) and covered:
		covered = false
		emit_signal("uncover_bed")
		texture = blade
		#print("bed_uncovered")

func on_tap (pos):
	if rect.has_point(pos) and !covered:
		emit_signal("remove_knife")
		#print ("off_knife")
		covered = true
		active = false
		hide()

func on_activate():
	if !(randi()%num):
		if !active:
			active = true
			emit_signal ("cover_bed")
			texture = hide
		#print ("on_knife")
		show()
