extends ParallaxBackground

export var speed = 50
var screen_size : Vector2

func _ready():
	screen_size = get_node("/root/Main/Player").screen_size
	print(screen_size)

func _process(delta):
	$Ground.motion_offset.y += 1 * speed * delta
	$Ground.motion_offset.x = -(get_node("/root/Main/Player").global_position.x / screen_size.x * 16 - 8)
