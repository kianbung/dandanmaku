extends CanvasLayer

var hp : int = 3
var score : int = 0
var combo_multiplier : float = 1
var combo_points : int

func take_damage():
	hp -= 1
	$PlayerHP.text = str(hp)
	combo_reset()
	if hp <= 0:
		get_parent().get_node("Player").die()

func combo_reset():
	update_score(combo_points)
	combo_points = 0
	$ComboTimer.stop()
	$ComboTimer.wait_time = 5

func update_score(pts):
	score += pts
	$Score.text = str(score)

func enemy_death(pts):
	combo_points += pts
	if $ComboTimer.is_stopped():
		$ComboTimer.start()
	else:
		$ComboTimer.start($ComboTimer.time_left + 2)

func grazed(collider):
	combo_points += 10
	if $ComboTimer.is_stopped():
		$ComboTimer.start()
	else:
		$ComboTimer.start($ComboTimer.time_left + 2)
	print("grazed")
func _ready():
	$PlayerHP.text = str(hp)
	get_parent().get_node("Player/GrazeZone").connect("area_entered", self, "grazed")

func _process(delta):
	$ComboGauge.value = $ComboTimer.time_left / $ComboTimer.wait_time * 100

func _on_ComboTimer_timeout():
	combo_reset()
