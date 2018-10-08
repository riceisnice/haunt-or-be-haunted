extends Node2D

signal death(type)

var controller
var tappers
var loopers
var swipers

var enemy
var dishes
var lock
var burner
var candle
var knife
var pot
var puddle
var gas
var light

var light_on = true

var cc

enum {B1, L1, L2}
var flr

var dead = false

func _ready():
	randomize()
	flr = L1
	controller = get_node("Controller")
	cc = get_node("Navigation/Cecile")
	cc.connect("waited", self, "on_waited")
	cc.connect("moved", self, "on_moved")
	tappers = get_tree().get_nodes_in_group("Tappers")
	loopers = get_tree().get_nodes_in_group("Loopers")
	swipers = get_tree().get_nodes_in_group("Swipers")
	for t in tappers:
		controller.connect("tap", t, "on_tap")
	for l in loopers:
		controller.connect("loop", l, "on_loop")
	for s in swipers:
		controller.connect("swipe", s, "on_swipe")
	
	enemy = get_node("Kieran")
	dishes = get_tree().get_nodes_in_group("Dishes")
	lock = get_tree().get_nodes_in_group("Lock")
	burner = get_tree().get_nodes_in_group("Burner")
	candle = get_tree().get_nodes_in_group("Candle")
	knife = get_tree().get_nodes_in_group("Knife")
	pot = get_tree().get_nodes_in_group("Pot")
	puddle = get_tree().get_nodes_in_group("Puddle")
	gas = get_tree().get_nodes_in_group("Gas")
	light = get_tree().get_nodes_in_group("Light")
	for d in dishes:
		enemy.connect("dishes", d, "on_activate")
		d.hide()
	for d in lock:
		enemy.connect("lock", d, "on_activate")
		cc.connect("inBath", d, "on_enter")
		d.hide()
	for d in burner:
		enemy.connect("burner", d, "on_activate")
		d.get_node("Timer").connect("timeout", self, "on_BurnerTimeout")
		d.hide()
	for d in candle:
		enemy.connect("candle", d, "on_activate")
		d.get_node("Timer").connect("timeout", self, "on_CandleTimeout")
		d.hide()
	for d in knife:
		enemy.connect("knife", d, "on_activate")
		d.connect("uncover_bed", self, "on_uncover")
		d.connect("cover_bed", self, "on_cover")
		d.hide()
	for d in pot:
		enemy.connect("pot", d, "on_activate")
		d.hide()
	for d in puddle:
		enemy.connect("pot", d, "on_activate")
		d.hide()
	for d in gas:
		enemy.connect("gas", d, "on_activate")
		d.hide()
	for d in light:
		enemy.connect("light", d, "on_activate")
		enemy.connect("toggle", d, "on_toggle")
		d.connect("toggle", self, "light_toggle")
		d.get_node("Timer").connect("timeout", self, "on_dark")
		d.hide()
	
	get_node("B1").connect("button_down", self, "on_B1")
	get_node("L1").connect("button_down", self, "on_L1")
	get_node("L2").connect("button_down", self, "on_L2")
	get_node("HomeButton").connect("button_down", self, "on_home")
	
	get_node("Clock/Timer").connect("timeout", self, "on_timeout")
	connect("death", get_node("Death"), "on_death")
	connect("death", self, "on_death")

func on_B1():
	get_node("MainFloor").hide()
	get_node("TopFloor").hide()
	get_node("Basement").show()
	flr = B1
	if cc.flr == cc.B1:
		cc.show()
		cc.z_index = 0
	else:
		cc.hide()

func on_L1():
	get_node("MainFloor").show()
	get_node("TopFloor").hide()
	get_node("Basement").show()
	flr = L1
	if cc.flr == cc.L1:
		cc.show()
		cc.z_index = 0
	else:
		cc.hide()

func on_L2():
	get_node("MainFloor").show()
	get_node("TopFloor").show()
	get_node("Basement").hide()
	flr = L2
	if cc.flr == cc.L2:
		cc.show()
		cc.z_index = 1
	elif cc.flr == cc.L1:
		cc.show()
		cc.z_index = 0
	else:
		cc.hide()

func on_home():
	get_tree().change_scene("res://MainMenu.tscn")

func on_cover():
	get_node("TopFloor/Unmade").hide()

func on_uncover():
	get_node("TopFloor/Unmade").show()

func on_timeout():
	print ("you win!")
	get_tree().change_scene("res://ChaseScene.tscn")

func on_moved(pos):
	for p in puddle:
		if p.rect.has_point(pos) and p.is_visible_in_tree():
			print("slipped down stairs")
			emit_signal("death", "puddle")

func on_waited(place, next):
	match place:
		cc.TABLE:
			for d in dishes:
				if d.is_visible_in_tree():
					print("death by poison")
					emit_signal("death", "dish")
		cc.BASE:
			for g in gas:
				if g.is_visible_in_tree():
					print("suffocated in gas")
					emit_signal("death", "gas")
		cc.BED:
			for k in knife:
				if k.is_visible_in_tree():
					print("stabbed in bed")
					emit_signal("death", "knife")
		cc.BATH:
			for l in lock:
				if l.is_visible_in_tree():
					print("drowned in bath")
					emit_signal("death", "bath")
		cc.MAIN:
			for p in pot:
				if p.is_visible_in_tree() and p.ready:
					print("brained with falling pot")
					emit_signal("death", "pot")

func on_BurnerTimeout():
	print("house aflame")
	emit_signal("death", "fire")

func on_CandleTimeout():
	print("burned to death")
	emit_signal("death", "fire")

func on_dark():
	print("killed in darkness")
	emit_signal("death", "light")

func light_toggle():
	light_on = false
	timeDark()

func timeDark():
	if !light_on and cc.flr == cc.B1:
		get_node("Basement/Light").get_node("Timer").start()

func on_death(type):
	if !dead:
		dead = true
		cc.z_index = 0
		get_node("MusicPlayer").stop()
		get_node("SFXPlayer").play()
		get_node("HomeButton").show()