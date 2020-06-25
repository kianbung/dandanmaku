extends Area2D

var screen_size : Vector2
var speed = 400
var direction : Vector2
export var bullet : PackedScene

func get_input():
	direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		)
	direction = direction.normalized()
	
	if Input.is_action_pressed("ui_select"):
		shoot()

func shoot():
	if $ShotCooldown.is_stopped():
		var shot = bullet.instance()
		shot.global_position = $Muzzle.global_position
		get_parent().add_child(shot)
		$ShotCooldown.start()

func clamp_player():
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	get_input()
	position += direction * delta * speed
	clamp_player()
