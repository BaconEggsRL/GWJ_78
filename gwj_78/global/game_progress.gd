extends Node

var inventory := {}


func _ready() -> void:
	reset_progress()

# call this func every time the game starts
func reset_progress() -> void:
	inventory = {
		"mop": false
	}
