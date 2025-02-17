extends Node2D

var MAIN = load("res://scenes/main.tscn")
@export var ending_text:Label

var MAIN_DIALOGUE = preload("res://dialogue/main.dialogue")
const BALLOON = preload("res://dialogue/balloon.tscn")

var custom_data = {"ending": "ending_normal"}

func _ready() -> void:
	show_dialogue(MAIN_DIALOGUE, custom_data.ending)  # custom function
	if custom_data.ending == "ending_body":
		ending_text.text = "(why are you holding a dead body???)"
	if custom_data.ending == "ending_normal":
		ending_text.text = "(you didn't hide enough evidence.)"

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
