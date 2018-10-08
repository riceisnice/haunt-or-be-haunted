extends Navigation2D

signal navigate (path)

var actor
var path

enum {BASE, MAIN, TOP}

func _ready():
	actor = get_node("Cecile")
	actor.connect("transition", self, "on_transit")
	actor.connect("waited", self, "on_waited")
	connect("navigate", actor, "on_navigate")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func setMesh(mesh):
	match mesh:
		BASE:
			get_node("BasePolygon").enabled = true
			get_node("MainPolygon").enabled = false
			get_node("TopPolygon").enabled = false
			actor.flr = actor.B1
			actor.z_index = 0
			get_parent().timeDark()
		MAIN:
			get_node("BasePolygon").enabled = false
			get_node("MainPolygon").enabled = true
			get_node("TopPolygon").enabled = false
			actor.flr = actor.L1
			actor.z_index = 0
			get_parent().get_node("Basement/Light/Timer").stop() #this is terrible I'm sorry :(
		TOP:
			get_node("BasePolygon").enabled = false
			get_node("MainPolygon").enabled = false
			get_node("TopPolygon").enabled = true
			actor.flr = actor.L2
			actor.z_index = 1
	if actor.flr != get_parent().flr:
		actor.hide()
	else:
		actor.show()

func on_transit(place):
	var dest
	match place:
		actor.MAIN:
			dest = get_node("MainPolygon/Main").position
		actor.UPSTAIRS:
			dest = get_node("MainPolygon/Upstairs").position
		actor.BATH:
			dest = get_node("MainPolygon/Bath").position
		actor.TABLE:
			dest = get_node("MainPolygon/Table").position
		actor.DOWNSTAIRS:
			dest = get_node("MainPolygon/Downstairs").position
		actor.BASE:
			dest = get_node("BasePolygon/Base").position
		actor.BASEUPSTAIRS:
			dest = get_node("BasePolygon/Downstairs").position
		actor.TOPDOWNSTAIRS:
			dest = get_node("TopPolygon/Downstairs").position
		actor.TOP:
			dest = get_node("TopPolygon/Top").position
		actor.BEDROOM:
			dest = get_node("TopPolygon/Bedroom").position
		actor.BED:
			dest = get_node("TopPolygon/Bed").position
	path = get_simple_path(actor.position, dest)
	emit_signal("navigate", path)

func on_waited(place, next):
	match place:
		actor.UPSTAIRS:
			actor.position = get_node("TopPolygon/Downstairs").position
			setMesh(TOP)
		actor.DOWNSTAIRS:
			actor.position = get_node("BasePolygon/Downstairs").position
			setMesh(BASE)
		actor.BASEUPSTAIRS:
			actor.position = get_node("MainPolygon/Downstairs").position
			setMesh(MAIN)
		actor.TOPDOWNSTAIRS:
			actor.position = get_node("MainPolygon/Upstairs").position
			setMesh(MAIN)