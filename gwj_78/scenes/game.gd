extends Node

@export var main_btn:Button

func _ready() -> void:
	main_btn.pressed.connect(_on_main_pressed)


func _on_main_pressed() -> void:
	SceneManager.goto("main")
