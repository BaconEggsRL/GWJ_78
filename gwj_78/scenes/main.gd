extends Node2D

@export var play_btn:Button
@export var achievements_btn:Button

const MANUAL_TEST = preload("res://ManualTest.tscn")
const GAME = preload("res://scenes/game.tscn")
const OPENING = preload("res://scenes/opening.tscn")

const FancyFade = preload("res://addons/transitions/FancyFade.gd")

var anim_speed = 0.5


@export var volume_btn:VolumeButton



func _ready() -> void:
	# play music
	AudioManager.play_music("music_funk", -6.0)
	
	
	play_btn.pressed.connect(_on_play_pressed)
	play_btn.mouse_entered.connect(_on_mouse_entered)
	
	achievements_btn.pressed.connect(_on_achievements_pressed)
	achievements_btn.mouse_entered.connect(_on_mouse_entered)




func _on_mouse_entered() -> void:
	AudioManager.play_fx("btn_hover", -12.0)
	
func _on_play_pressed() -> void:
	SceneManager.goto("opening")

func _on_achievements_pressed() -> void:
	SceneManager.goto("achievements")

#func _on_play_pressed() -> void:
	#var _target_scene = GAME.instantiate()
	#var _type = "pixelated_noise"
	#
	#var custom_data = {
		#"override_level": 1,
	#}
	#SceneManager.goto("game", custom_data)
	## Transitions.change_scene_to_instance(target_scene, Transitions.FadeType.Instant)
	## Transitions.change_scene_to_instance(target_scene, Transitions.FadeType.CrossFade, 1)
	## FancyFade.new().blurry_noise(target_scene)
	## FancyFade.new().circle_out(target_scene, anim_speed)
	## FancyFade.new().tile_reveal(target_scene)
	## FancyFade.new().wipe_conical(target_scene, anim_speed)
	#pass
