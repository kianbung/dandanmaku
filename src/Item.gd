extends Area2D

class_name Item
signal item_pickup
var item_name
var speed = rand_range(10,20)
var direction = Vector2.DOWN.rotated(rand_range(-0.25,0.25) * PI)

func _ready():
	connect("area_entered", self, "item_pickup")
	$VisibilityNotifier2D.connect("screen_exited", self, "screen_exited")
	connect("item_pickup", get_node("/root/Main/HUD"), "item_pickup")
	self.scale *= 0.5
	add_to_group("item")
	set_despawn(1)

func set_despawn(time):
	var despawn_timer = Timer.new()
	add_child(despawn_timer)
	despawn_timer.connect("timeout", self, "start_despawn")
	despawn_timer.start(time)

# !TODO: NEEDS BETTER WAY TO BLINK, seems like it's being janked up by not syncing with frame draw
func start_despawn():
	var times_to_blink = 5
	for i in range(0, times_to_blink):
		self.visible = false
		print("blink on")
		yield(get_tree().create_timer(0.1), "timeout")
		self.visible = true
		print("blink off")
	print("free")
	queue_free()

func _process(delta):
	position += direction * speed * delta

func item_pickup(_area):
	emit_signal("item_pickup", item_name)
	queue_free()

func screen_exited():
	queue_free()
	
