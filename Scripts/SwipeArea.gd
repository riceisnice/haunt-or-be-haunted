extends Sprite

var rect

func _ready():
	var scX = get_node("CollisionShape2D").shape.extents.x * 4
	var scY = get_node("CollisionShape2D").shape.extents.y * 4
	rect = Rect2(global_position.x - scX, global_position.y - scY, scX * 2, scY * 2)
	get_node("CollisionShape2D").queue_free()
	#print (String(rect.position) + ", " + String(rect.end))
