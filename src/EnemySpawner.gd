extends Node2D
var enemy_list = [
	load("res://src/EnemySmall.tscn"),
	load("res://src/EnemyMedium.tscn"),
	load("res://src/EnemyBig.tscn")
]
func spawn_enemy():
	var enemy_selected : int = rand_range(0,2.9)
	var enemy = enemy_list[enemy_selected].instance()
	enemy.global_position = Vector2(rand_range(0, get_viewport_rect().size.x ), 0)
	enemy.connect("death", get_parent().get_node("HUD"), "enemy_death")
	add_child(enemy)
	match enemy_selected:
		0:
			$EnemySpawnTimer.wait_time = rand_range(1, 3)
		1:
			$EnemySpawnTimer.wait_time = rand_range(3, 6)
		2:
			$EnemySpawnTimer.wait_time = rand_range(6, 10)

func _on_EnemySpawnTimer_timeout():
	spawn_enemy()
