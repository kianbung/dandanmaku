extends Area2D

signal player_death

var screen_size : Vector2
export var default_speed = 200
export var slow_speed = 80
onready var speed = default_speed
var direction : Vector2
export var bullet : PackedScene

var control_lock : bool = true

func get_input():
	if control_lock:
		return
	direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		)
	direction = direction.normalized()
	
	if Input.is_action_pressed("ui_select"):
		shoot()
	if Input.is_action_pressed("slow"):
		speed = slow_speed
	else:
		speed = default_speed
	if Input.is_action_just_pressed("bomb"):
		use_bomb()

func use_bomb():
	if get_node("/root/Main/HUD").use_bomb():
		get_tree().call_group("enemy", "explode")
		get_tree().call_group("enemy_bullet", "explode")
		get_node("/root/Main/Camera/AnimationPlayer").play("screen_flash")

func shoot():
	if $ShotCooldown.is_stopped():
		var shot = bullet.instance()
		shot.global_position = $Muzzle.global_position
		get_parent().add_child(shot)
		$ShotCooldown.start()

func clamp_player():
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func die():
	control_lock = true
	visible = false
	$CollisionShape2D.disabled = true
	var explode = load("res://src/PlayerExplosion.tscn").instance()
	explode.global_position = global_position
	get_parent().add_child(explode)
	explode.get_node("AnimationPlayer").play("explosion")
	yield(explode.get_node("AnimationPlayer"), "animation_finished")
	emit_signal("player_death")

func take_damage():
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("damaged")
		get_parent().get_node("HUD").take_damage()
	
func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	get_input()
	position += direction * delta * speed
	clamp_player()


func _on_Player_area_entered(area):
	if area.is_in_group("enemy") or area.is_in_group("enemy_bullet"):
		take_damage()
