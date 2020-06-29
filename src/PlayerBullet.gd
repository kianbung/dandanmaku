extends Area2D

export var speed = 400
var direction = Vector2.UP

func update_direction(dir : Vector2):
	direction = dir.normalized()

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


func _on_PlayerBullet_area_entered(area):
	queue_free()
