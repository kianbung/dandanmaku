extends EnemyShip

onready var speed = rand_range(45,55)
var direction = Vector2.DOWN
export var bullet : PackedScene

func shoot():
	var shot = bullet.instance()
	get_parent().add_child(shot)
	shot.global_position = $Muzzle.global_position
	$ShotTimer.wait_time = rand_range(0.3, 5)
	print("Shot timer: " + str($ShotTimer.wait_time))

func _ready():
	ship_name = "EnemySmall"

func _process(delta):
	position += direction * speed * delta


func _on_ShotTimer_timeout():
	shoot()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
