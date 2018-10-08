extends Node2D

signal tap (pos)
signal loop (pos)
signal swipe (pos)

var click = false
var particles

var tapRadius = 10
var loopRadius = 20
var swipeRadius = 60
var circlePos

var loopOut = false
var swipeOut = false

func _ready():
	particles = get_node("Particles2D")
	particles.emitting = false
	set_process_input(true)
	clearCircle()

func _process(delta):
		if click:
			checkRound(get_local_mouse_position())
			checkSwipe(get_local_mouse_position())

func _input(ev):
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT:
		click = ev.pressed
		particles.emitting = click
		if click:
			particles.position = ev.position
			checkTap(ev.position)
			swipeOut = false
			circlePos = ev.position
			update()
		else:
			#clearCircle()
			pass
	if ev is InputEventMouseMotion:
		particles.translate(ev.relative)

func checkTap(pos):
	if (pos - circlePos).length() < tapRadius:
		emit_signal("tap", circlePos)
		#print ("tap")

func checkRound(pos):
	if (pos - circlePos).length() > loopRadius:
		loopOut = true
	if (pos - circlePos).length() < loopRadius and loopOut:
		loopOut = false
		emit_signal("loop", circlePos)
		#print (circlePos)
		#print ("loop")

func checkSwipe(pos):
	if (pos - circlePos).length() > swipeRadius and !swipeOut:
		swipeOut = true
		emit_signal("swipe", circlePos)
		#print ("swipe")

func clearCircle():
	circlePos = Vector2 (-60, -60)
	update()

func _draw():
	#debug guides
	#draw_circle(circlePos, swipeRadius, Color ("14aaff"))
	#draw_circle(circlePos, loopRadius, Color ("14cc14"))
	#draw_circle(circlePos, tapRadius, Color ("c43a17"))
	pass

