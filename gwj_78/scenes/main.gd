extends Node

@export var play_btn:Button
const MANUAL_TEST = preload("res://ManualTest.tscn")
const GAME = preload("res://scenes/game.tscn")


func _ready() -> void:
	play_btn.pressed.connect(_on_play_pressed)


func _on_play_pressed() -> void:
	# SceneManager.goto("game")
	# Transitions.change_scene_to_instance(GAME.instantiate(), Transitions.FadeType.Instant)
	Transitions.change_scene_to_instance(GAME.instantiate(), Transitions.FadeType.CrossFade, 1)
