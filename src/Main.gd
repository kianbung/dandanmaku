extends Node2D

func start_game():
	randomize()
	var screen_size = get_viewport_rect().size
	$Player.global_position = Vector2(screen_size.x / 2, screen_size.y * 0.9)
	$Player.visible = true
	$Player/CollisionShape2D.disabled = false
	$HUD.score = 0
	$HUD.hp = 3
	$EnemySpawner/EnemySpawnTimer.start()
	
	$GUI/Title.visible = false
	$GUI/StartButton.visible = false

func game_over():
	$EnemySpawner/EnemySpawnTimer.stop()
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("enemy_bullet", "queue_free")
	get_tree().call_group("player_bullet", "queue_free")
	$GUI/Title.visible = true
	$GUI/StartButton.visible = true

func _on_StartButton_pressed():
	start_game()


func _on_Player_player_death():
	game_over()
