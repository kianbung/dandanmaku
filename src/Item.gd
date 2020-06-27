extends Area2D

class_name Item
signal item_pickup
var item_name
var speed = 10

func _ready():
	connect("area_entered", self, "item_pickup")
	$VisibilityNotifier2D.connect("screen_exited", self, "screen_exited")
	connect("item_pickup", get_node("/root/Main/HUD"), "item_pickup")
	self.scale *= 0.5
	add_to_group("item")

func _process(delta):
	position += Vector2.DOWN * speed * delta

func item_pickup(_area):
	emit_signal("item_pickup", item_name)
	queue_free()

func screen_exited():
	queue_free()
	
