extends Node2D

class_name EnemyShip

signal death(points)
var hp : int = 2
var points : int = 10
var ship_name : String = ""

var item_list = {
	"SmallGem" : load("res://src/SmallGem.tscn"),
	"Bomb" : load("res://src/Bomb.tscn")
}

func take_damage(dmg_source):
	if dmg_source.is_in_group("player") or dmg_source.is_in_group("player_bullet"):
		hp -= 1
		if hp <= 0:
			die()
			
		$AnimatedSprite.modulate = Color(255,255,255)
		yield(get_tree().create_timer(0.05), "timeout")
		$AnimatedSprite.modulate = Color(1,1,1)

func die():
	explode()
	emit_signal("death", points)
	spawn_item()

func explode():
	var explode = load("res://src/Explosion.tscn").instance()
	explode.global_position = global_position
	get_parent().add_child(explode)
	queue_free()

func spawn_item():
	var item = roll_item().instance()
	item.global_position = global_position
	get_parent().add_child(item)

func roll_item():
	var roll : String
	match ship_name:
		"EnemySmall":
			roll = "SmallGem"
		"EnemyMedium":
			roll = "SmallGem" if rand_range(0,10) < 8 else "Bomb"
		"EnemyBig":
			roll = "SmallGem" if rand_range(0,10) < 7 else "Bomb"
	return item_list[roll]

func _ready():
	connect("area_entered", self, "take_damage")
	add_to_group("enemy")

