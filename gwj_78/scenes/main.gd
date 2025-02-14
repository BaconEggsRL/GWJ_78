extends Node

@export var play_btn:Button

func _ready() -> void:
	play_btn.pressed.connect(_on_play_pressed)


func _on_play_pressed() -> void:
	SceneManager.goto("game")
