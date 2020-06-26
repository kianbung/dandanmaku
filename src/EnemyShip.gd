extends Node2D

class_name EnemyShip

signal death(points)
var hp : int = 1
var points : int = 10

func take_damage(dmg_source):
	if dmg_source.is_in_group("player") or dmg_source.is_in_group("player_bullet"):
		hp -= 1
		if hp <= 0:
			die()
			
		$AnimatedSprite.modulate = Color(255,255,255)
		yield(get_tree().create_timer(0.05), "timeout")
		$AnimatedSprite.modulate = Color(1,1,1)

func die():
	var explode = load("res://src/Explosion.tscn").instance()
	explode.global_position = global_position
	get_parent().add_child(explode)
	emit_signal("death", points)
	queue_free()

func _ready():
	connect("area_entered", self, "take_damage")

