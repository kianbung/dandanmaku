extends Node2D

func _ready():
	var sound = AudioStreamPlayer.new()
	sound.stream = load("res://sounds/explosion.ogg")
	sound.volume_db = -10
	add_child(sound)
	sound.play()

func _on_AnimatedSprite_animation_finished():
	visible = false
	queue_free()
