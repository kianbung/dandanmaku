extends Node2D

func spawn_enemy():
	var enemy = load("res://src/EnemyMedium.tscn").instance()
	enemy.global_position = Vector2(rand_range(0, get_viewport_rect().size.x ), 0)
	add_child(enemy)
	$EnemySpawnTimer.wait_time = rand_range(1, 5)

func _on_EnemySpawnTimer_timeout():
	spawn_enemy()
