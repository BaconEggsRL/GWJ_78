class_name GameTiles
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




@export var grid:TileMapLayer

@export var select_sprite:Sprite2D

@export var mouse:MouseTiles

var player_tile_id = 4  # Player tile ID
@export var player_start_pos := Vector2i(4, 4)


@export var erase_label:Label
@export var moves_label:Label

@onready var levels: Node2D = $levels




var custom_data = {}

@export var override_level:int = 1  # override level from inspector

var current_level:int = 1
var tilemap:TileMapLayer

# data for levels
var level_data = [
	# level 1
	{
		"num_erases": 1,
		"num_moves": 4,
	},
	# level 2
	{
		"num_erases": 2,
		"num_moves": 4,
	}
]

var num_erases:int
var num_moves:int
@onready var erases_left:int = num_erases
@onready var moves_left:int = num_moves


func set_tilemap_for_level():
	# Hide all levels first
	for child in levels.get_children():
		child.hide()

	# Ensure the level index is valid
	if current_level > 0 and current_level <= levels.get_child_count():
		tilemap = levels.get_child(current_level - 1)  # Get the child corresponding to the level index
		tilemap.show()  # Make the selected level visible
		print("Tilemap set to level:", current_level, " -> ", tilemap.name)
	else:
		tilemap = null
		print("Invalid level:", current_level)
		
		
func _ready() -> void:
	
	# constructor
	if custom_data.has("override_level"):
		print("hi")
		self.override_level = custom_data.override_level

	current_level = override_level
	num_erases = level_data[current_level-1].num_erases
	num_moves = level_data[current_level-1].num_moves
	erases_left = num_erases
	moves_left = num_moves
	
	# other stuff
	main_btn.pressed.connect(_on_main_pressed)
	mouse.finished.connect(_on_finished_level)
	
	set_tilemap_for_level()
	tilemap.set_cell(player_start_pos, player_tile_id, Vector2i(0,0))
	
	update_labels()
	
	

func _process(_delta):
	update_selection_position()
	
	
func update_selection_position():
	var mouse_pos = get_global_mouse_position()
	var tile_pos = grid.local_to_map(grid.to_local(mouse_pos))  # Get tile coordinates
	var world_pos = grid.to_global(grid.map_to_local(tile_pos))  # Convert to world position

	select_sprite.position = world_pos  # Snap sprite to tile position
	

func update_labels() -> void:
	erase_label.text = "Erases left: %d" % erases_left
	moves_label.text = "Moves left: %d" % moves_left



	
	





	

func next_level() -> void:
	# go to next level if valid, otherwise go to main
	var target_level = current_level + 1
	if target_level <= levels.get_child_count():
		var _custom_data = {
			"override_level": current_level + 1,
		}
		SceneManager.goto("game", _custom_data)
		
	else:
		self.goto_main()
	
	
func restart_level() -> void:
	var _custom_data = {
		"override_level": current_level,
	}
	SceneManager.goto("game", _custom_data)


func goto_main() -> void:
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



func _on_finished_level() -> void:
	self.next_level()
	
func _on_restart_level_pressed() -> void:
	self.restart_level()

func _on_main_pressed() -> void:
	self.goto_main()
