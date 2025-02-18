extends Node2D

var MAIN = load("res://scenes/main.tscn")
@export var ending_text:Label

var MAIN_DIALOGUE = preload("res://dialogue/main.dialogue")
const BALLOON = preload("res://dialogue/balloon.tscn")

var custom_data = {"ending": "ending_normal"}

func _ready() -> void:
	if custom_data.ending != "ending_good":
		AudioManager.play_fx("fbi")
	else:
		AudioManager.play_fx("yay")
		
		
	show_dialogue(MAIN_DIALOGUE, custom_data.ending)  # custom function

	match custom_data.ending:
		"ending_body":
			ending_text.text = "(why are you holding a dead body???)"
		"ending_normal":
			ending_text.text = "(you didn't hide enough evidence.)"
		"ending_time":
			ending_text.text = "(you ran out of time and the police showed up.)"
		"ending_window":
			ending_text.text = "(you got caught by the window guy.)"
		"ending_sleep":
			ending_text.text = "(you got caught sleeping.)"
		"ending_webcam":
			ending_text.text = "(you got caught from webcam footage.)"
		"ending_gun":
			ending_text.text = "(you got caught with the murder weapon.)"
		"ending_vampire":
			ending_text.text = "(they found the victim's blood in your stomach.)"
		"ending_good":
			ending_text.text = "(you got away.)"



func _on_main_menu_pressed() -> void:
	var _target_scene = MAIN.instantiate()
	var _type = "pixelated_noise"
	SceneManager.goto("main")

func _on_restart_level_pressed() -> void:
	SceneManager.goto("game")


# show dialogue
func show_dialogue(resource:DialogueResource, title:String="", extra_game_states:Array=[]) -> Node:
	var balloon:Node = BALLOON.instantiate()
	add_child(balloon)
	balloon.start(resource, title, extra_game_states)
	DialogueManager.dialogue_started.emit(resource)
	return balloon
