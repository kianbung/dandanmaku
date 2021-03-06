extends Area2D

var speed : int = 60
var direction = Vector2.DOWN

func change_direction(dir : Vector2):
	direction = dir.normalized()

func change_speed(spd : int):
	speed = spd

func explode():
	var item = load("res://src/SmallGem.tscn").instance()
	item.global_position = global_position
	get_parent().add_child(item)
	queue_free()

func _ready():
	var sound = AudioStreamPlayer.new()
	sound.stream = load("res://sounds/enemy_shot.ogg")
	sound.volume_db = -10
	add_child(sound)
	sound.play()

func _process(delta):
	position += direction * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_EnemyBullet_area_entered(area):
	if area.is_in_group("player"):
		queue_free()
