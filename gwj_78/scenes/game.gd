extends Node

@export var main_btn:Button
var MAIN = load("res://scenes/main.tscn")


func _ready() -> void:
	main_btn.pressed.connect(_on_main_pressed)


func _on_main_pressed() -> void:
	# SceneManager.goto("main")
	# Transitions.change_scene_to_instance(MAIN.instantiate(), Transitions.FadeType.CrossFade, 1)
	Transitions.change_scene_to_instance(MAIN.instantiate(), Transitions.FadeType.Instant)
	pass
