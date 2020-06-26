extends EnemyShip

var speed : int = 250
onready var cruise_speed = rand_range(20,30)
var target_distance : float
var direction = Vector2.DOWN
var screen_size : Vector2

var burst_count : int
var burst_size : int

func side_movement():
	if position.x < (screen_size.x / 2):
		if rand_range(0,10) < 5:
			direction.x = 1
	elif position. x > (screen_size.x / 2):
		if rand_range(0,10) < 5:
			direction.x = -1
	else:
		if rand_range(0,10) <= 5:
			direction.x = 1
		else:
			direction.x = -1

func side_check():
	if position.x <= 0:
		direction.x = 1
	elif position.x >= screen_size.x:
		direction.x = -1

func shoot():
	var shot = load("res://src/EnemyBullet.tscn").instance()
	var aim = get_node("/root/Main/Player").global_position - $Muzzle.global_position
	shot.global_position = $Muzzle.global_position
	shot.change_direction(aim.rotated(rand_range(-PI / 8, PI / 8)))
	shot.change_speed(60)
	get_parent().add_child(shot)

func _ready():
	hp = 3
	points = 25
	screen_size = get_viewport_rect().size
	target_distance = rand_range(screen_size.y * 0.01, screen_size.y * 0.15)
	$ShotTimer.wait_time = rand_range(1, 5)
	
	if position.x < (screen_size.x/2):
		direction.x = 1
	else:
		direction.x = -1

func _process(delta):
	side_check()
	position += direction * speed * delta
	if position.y >= target_distance:
		speed = cruise_speed


func _on_SideTimer_timeout():
	side_movement()
	$SideTimer.wait_time = rand_range(1, 5)


func _on_ShotTimer_timeout():
	burst_count = 0
	burst_size = int(rand_range(3, 10))
	$BurstTimer.wait_time = 0.01
	$BurstTimer.start()
	$ShotTimer.wait_time = rand_range(0.3, 5)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_BurstTimer_timeout():
	shoot()
	burst_count += 1
	if burst_count < burst_size:
		$BurstTimer.wait_time = rand_range(0.05,0.2)
		$BurstTimer.start()
	else:
		$BurstTimer.stop()
