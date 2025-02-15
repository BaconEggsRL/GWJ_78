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




var grid_size = 4
var cells = {}
	
@export var grid:TileMapLayer
@export var tilemap:TileMapLayer

@export var select_sprite:Sprite2D

@export var mouse:Mouse

func _ready() -> void:
	main_btn.pressed.connect(_on_main_pressed)

func _process(_delta):
	update_selection_position()
	
	
func update_selection_position():
	var mouse_pos = get_global_mouse_position()
	var tile_pos = grid.local_to_map(grid.to_local(mouse_pos))  # Get tile coordinates
	var world_pos = grid.to_global(grid.map_to_local(tile_pos))  # Convert to world position

	select_sprite.position = world_pos  # Snap sprite to tile position
	
	
func _on_main_pressed() -> void:
	var _target_scene = MAIN.instantiate()
	var _type = "pixelated_noise"
	SceneManager.goto("main")
	# Transitions.change_scene_to_instance(_target_scene, Transitions.FadeType.CrossFade, 1)
	# Transitions.change_scene_to_instance(_target_scene, Transitions.FadeType.Instant)
	# FancyFade.new().blurry_noise(_target_scene)
	# FancyFade.new().circle_in(_target_scene, anim_speed)
	# FancyFade.new().tile_reveal(_target_scene)
	# FancyFade.new().wipe_conical(_target_scene, anim_speed)
	# FancyFade.new().wipe_right(_target_scene, anim_speed)
	# fade[type].call(_target_scene, anim_speed)
	
	pass
