extends Sprite

var fire
var dish
var bath
var pot
var knife
var puddle
var gas
var light
var dead = false

func _ready():
	fire = load("res://Sprites/deathFire.png")
	dish = load("res://Sprites/deathDish.png")
	bath = load("res://Sprites/deathBath.png")
	pot = load("res://Sprites/deathPot.png")
	knife = load("res://Sprites/deathKnife.png")
	puddle = load("res://Sprites/deathPuddle.png")
	gas = load("res://Sprites/deathGas.png")
	light = load("res://Sprites/deathDark.png")
	hide()

func on_death(death):
	if !dead:
		match death:
			"fire": texture = fire
			"dish": texture = dish
			"bath": texture = bath
			"pot": texture = pot
			"knife": texture = knife
			"puddle": texture = puddle
			"gas": texture = gas
			"light": texture = light
		dead = true
		show()
