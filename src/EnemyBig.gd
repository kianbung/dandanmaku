extends EnemyShip

var speed = 200
onready var cruise_speed = rand_range(20,30)
var screen_size : Vector2
var direction = Vector2.DOWN
var jump_distance : float
var jumping : bool = true
var rotate_radius = rand_range(1,4)

var burst_count : int = 0
var burst_size : int = 0
var burst_density : int = 0

func set_burst(density : int, size : int):
	burst_count = 0
	burst_density = density
	burst_size = size

func shoot():
	set_burst(rand_range(8, 16), rand_range(20, 40))
	burst()
	$ShotTimer.wait_time = rand_range(3,8)
	$ShotTimer.stop()

func burst():
	var new_rotation : float = float(burst_count) / float(burst_density) * PI * 2
	var current_direction = Vector2.DOWN.rotated(new_rotation)
	single_shot(current_direction, 50)
	if burst_count < burst_size:
		burst_count += 1
		$BurstTimer.wait_time = 0.05
		$BurstTimer.start()
	else:
		$BurstTimer.stop()
		$ShotTimer.start()

func single_shot(dir : Vector2, spd : int):
	var shot = load("res://src/EnemyBullet.tscn").instance()
	shot.global_position = $Muzzle.global_position
	shot.change_direction(dir)
	shot.change_speed(spd)
	get_parent().add_child(shot)

func _ready():
	hp = 5
	points = 50
	screen_size = get_viewport_rect().size
	jump_distance = rand_range(screen_size.y * 0.05, screen_size.y * 0.25)

func _process(delta):
	position += direction * speed * delta
	
	if jumping and position.y >= jump_distance:
		speed = cruise_speed
		jumping = false
		$ShotTimer.wait_time = rand_range(0.3, 1)
		$ShotTimer.start()
		if position.x >= screen_size.x / 2:
			direction = Vector2(-1, 0)
			rotate_radius = -rotate_radius
		else:
			direction = Vector2(1, 0)
	
	if !jumping:
		direction = direction.rotated(delta / rotate_radius)
		if position.x <= -10 or position.x >= screen_size.x + 10:
			direction.x = -direction.x
			rotate_radius = -rotate_radius


func _on_ShotTimer_timeout():
	if $BurstTimer.is_stopped():
		shoot()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_BurstTimer_timeout():
	burst()
