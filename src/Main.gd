extends Node2D


func _ready():
	$Player.global_position = $PlayerStartPosition.global_position
	randomize()
