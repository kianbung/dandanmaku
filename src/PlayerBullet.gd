extends Area2D

export var speed = 400
var direction = Vector2.UP

func update_direction(dir : Vector2):
	direction = dir.normalized()

func _process(delta):
	position += direction * speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_PlayerBullet_area_entered(area):
	queue_free()
