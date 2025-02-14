extends Node

@export var main_btn:Button
var MAIN = load("res://scenes/main.tscn")

const FancyFade = preload("res://addons/transitions/FancyFade.gd")
var ff = FancyFade.new()

var anim_speed = 0.5

var fade:Dictionary = {
	"noise": Callable(ff.noise),
	"pixelated_noise": Callable(ff.noise),
	"blurry_noise": Callable(ff.noise),
	"cell_noise": Callable(ff.noise)
}


func _ready() -> void:
	main_btn.pressed.connect(_on_main_pressed)


func _on_main_pressed() -> void:
	var target_scene = MAIN.instantiate()
	var type = "pixelated_noise"
	# SceneManager.goto("main")
	# Transitions.change_scene_to_instance(target_scene, Transitions.FadeType.CrossFade, 1)
	# Transitions.change_scene_to_instance(target_scene, Transitions.FadeType.Instant)
	# FancyFade.new().blurry_noise(target_scene)
	# FancyFade.new().circle_in(target_scene, anim_speed)
	# FancyFade.new().tile_reveal(target_scene)
	# FancyFade.new().wipe_conical(target_scene, anim_speed)
	# FancyFade.new().wipe_right(target_scene, anim_speed)
	fade[type].call(target_scene, anim_speed)
	
	pass
