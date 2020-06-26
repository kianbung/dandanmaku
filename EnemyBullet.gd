extends Area2D

var speed : int = 100
var direction = Vector2.DOWN

func change_direction(dir : Vector2):
	direction = dir.normalized()

func change_speed(spd : int):
	speed = spd

func _process(delta):
	position += direction * speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_EnemyBullet_area_entered(area):
	if area.is_in_group("player"):
		queue_free()
