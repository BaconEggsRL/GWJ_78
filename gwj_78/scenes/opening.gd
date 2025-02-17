extends Node2D

var MAIN = load("res://scenes/main.tscn")

var MAIN_DIALOGUE = preload("res://dialogue/main.dialogue")
const BALLOON = preload("res://dialogue/balloon.tscn")



func _ready() -> void:
	# play music
	AudioManager.play_music("music_funk", -6.0)
	# show dialogue
	show_dialogue(MAIN_DIALOGUE, "opening")  # custom function


#func _on_main_menu_pressed() -> void:
	#var _target_scene = MAIN.instantiate()
	#var _type = "pixelated_noise"
	#SceneManager.goto("main")
#
#func _on_restart_level_pressed() -> void:
	#SceneManager.goto("game")


# show dialogue
func show_dialogue(resource:DialogueResource, title:String="", extra_game_states:Array=[]) -> Node:
	var balloon:Node = BALLOON.instantiate()
	add_child(balloon)
	balloon.start(resource, title, extra_game_states)
	DialogueManager.dialogue_started.emit(resource)
	return balloon


func start_game() -> void:
	SceneManager.goto("game")
	
func _on_skip_pressed() -> void:
	start_game()
