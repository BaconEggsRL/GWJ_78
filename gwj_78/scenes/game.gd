class_name Game
extends Node2D

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



@export var select_sprite:Sprite2D

@export var mouse:Mouse
@onready var room_scenes: Node2D = $room_scenes




		
		
func _ready() -> void:
	# other stuff
	main_btn.pressed.connect(_on_main_pressed)
	
	

func _process(_delta):
	pass




	
	
func restart_level() -> void:
	SceneManager.goto("game")


func goto_main() -> void:
	var _target_scene = MAIN.instantiate()
	var _type = "pixelated_noise"
	SceneManager.goto("main")

	
func _on_restart_level_pressed() -> void:
	self.restart_level()

func _on_main_pressed() -> void:
	self.goto_main()
