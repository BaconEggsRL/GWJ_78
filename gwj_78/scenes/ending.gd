extends Node2D

var MAIN = load("res://scenes/main.tscn")


func _on_main_menu_pressed() -> void:
	var _target_scene = MAIN.instantiate()
	var _type = "pixelated_noise"
	SceneManager.goto("main")



func _on_restart_level_pressed() -> void:
	SceneManager.goto("game")
