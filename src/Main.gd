extends Node2D

func start_game():
	randomize()
	var screen_size = get_viewport_rect().size
	$Player.global_position = Vector2(screen_size.x / 2, screen_size.y * 0.9)
	$Player.visible = true
	$Player.control_lock = false
	$Player/CollisionShape2D.disabled = false
	$HUD.reset_all()
	$EnemySpawner/EnemySpawnTimer.start()
	$GUI/ScoreReport.visible = false
	$GUI/Title.visible = false
	$GUI/StartButton.visible = false
	$GUI/Controls.visible = false

func game_over():
	$EnemySpawner/EnemySpawnTimer.stop()
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("enemy_bullet", "queue_free")
	get_tree().call_group("player_bullet", "queue_free")
	get_tree().call_group("item", "queue_free")
	$GUI/ScoreReport.text = "Best Combo: " + str($HUD.best_combo) + "\nKillstreak: " + str($HUD.killstreak) + "x"
	$GUI/ScoreReport.visible = true
	$GUI/StartButton.visible = true

func _on_StartButton_pressed():
	start_game()


func _on_Player_player_death():
	game_over()
