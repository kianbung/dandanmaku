extends Area2D

var speed : int = 200
var direction = Vector2.DOWN

func change_direction(dir : Vector2):
	direction = dir.normalized()

func _process(delta):
	position += direction * speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
