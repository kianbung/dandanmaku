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
	set_despawn(5)

func set_despawn(time):
	var despawn_timer = Timer.new()
	add_child(despawn_timer)
	despawn_timer.connect("timeout", self, "start_despawn")
	despawn_timer.start(time)

func start_despawn():
	$AnimationPlayer.play("despawn")

func _play_sound():
	var sound = AudioStreamPlayer.new()
	sound.stream = load("res://sounds/gem_pickup.ogg")
	sound.volume_db = -10
	add_child(sound)
	sound.play()
	return sound

func _process(delta):
	position += direction * speed * delta

func item_pickup(_area):
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("item_pickup", item_name)
	yield(_play_sound(), "finished")
	queue_free()

func screen_exited():
	queue_free()
	
