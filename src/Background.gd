extends ParallaxBackground

export var speed = 50

func _process(delta):
	$Ground.motion_offset.y += 1 * speed * delta
