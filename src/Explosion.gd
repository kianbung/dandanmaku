extends Node2D



func _on_AnimatedSprite_animation_finished():
	visible = false
	queue_free()
