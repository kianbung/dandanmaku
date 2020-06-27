extends CanvasLayer

var hp : int = 3
var bomb : int = 1
var score : int = 0
var combo_points : int
var combo_counter : int
var combo_level : int

var best_combo : int
var killstreak : int

var combo_multiplier = [
	1,
	1.5,
	2,
	3,
	4.5,
	8
]

func reset_all():
	score = 0
	hp = 3
	bomb = 1
	best_combo = 0
	killstreak = 0
	
	#TODO: add methods later
	$PlayerHP.text = str(hp)
	$BombCounter.text = str(bomb)
	update_score(0)

func take_damage():
	hp -= 1
	$PlayerHP.text = str(hp)
	get_node("/root/Main/Camera/AnimationPlayer").play("screen_shake")
	if hp <= 0:
		get_parent().get_node("Player").die()
	combo_reset()

func combo_reset():
	var combo_total = combo_points * combo_multiplier[combo_level]
	best_combo = combo_total if combo_total > best_combo else best_combo
	killstreak = combo_counter if combo_counter > killstreak else killstreak
	update_score(combo_total)
	combo_points = 0
	combo_counter = 0
	combo_level = 0
	$ComboTimer.stop()
	$ComboTimer.wait_time = 5
	update_combo()

func combo_continue(pts : int):
	combo_points += pts
	if $ComboTimer.is_stopped():
		$ComboTimer.start()
	else:
		var bonus_time
		match combo_level:
			0: bonus_time = 3
			1: bonus_time = 2.5
			2: bonus_time = 2
			3: bonus_time = 1.5
			4: bonus_time = 1
			5: bonus_time = 0.5
		$ComboTimer.start($ComboTimer.time_left + bonus_time)
	update_combo()

func update_combo():
	var combo_text = [
		"",
		str(combo_counter) + "x combo",
		str(combo_counter) + "x combo!",
		str(combo_counter) + "x COMBO!",
		str(combo_counter) + "x COMBO!!",
		str(combo_counter) + "X COMBO!!!"
	]
	get_combo_level()
	$ComboCounter.text = combo_text[combo_level]

func get_combo_level():
	if combo_counter <= 1:
		combo_level = 0
	elif combo_counter <= 5:
		combo_level = 1
	elif combo_counter <= 12:
		combo_level = 2
	elif combo_counter <= 25:
		combo_level = 3
	elif combo_counter <= 50:
		combo_level = 4
	else:
		combo_level = 5

func update_score(pts):
	score += pts
	$Score.text = str(score)

func enemy_death(pts):
	combo_counter +=1
	combo_continue(pts)
	

func grazed(collider):
	combo_continue(10)

func item_pickup(name):
	if name == "SmallGem":
		combo_continue(5)
	if name == "Bomb":
		combo_continue(5)
		bomb += 1
		$BombCounter.text = str(bomb)

func use_bomb():
	if bomb <= 0:
		return false
	else:
		bomb -= 1
		$BombCounter.text = str(bomb)
		combo_reset()
		return true

func _ready():
	reset_all()
	get_parent().get_node("Player/GrazeZone").connect("area_entered", self, "grazed")
	update_combo()

func _process(delta):
	$ComboGauge.value = $ComboTimer.time_left / $ComboTimer.wait_time * 100

func _on_ComboTimer_timeout():
	combo_reset()
