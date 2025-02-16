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

###########################################################


@export var SCENE_1:TextureRect
@export var SCENE_2:TextureRect
@export var SCENE_3:TextureRect
@export var SCENE_4:TextureRect
@onready var room_scenes = [SCENE_1, SCENE_2, SCENE_3, SCENE_4]

@export var starting_scene_index = 0
@onready var current_scene_index = starting_scene_index

# @export var room_scene:TextureRect
var current_room_scene:TextureRect

###########################################################

const BALLOON = preload("res://dialogue/balloon.tscn")
var MAIN_DIALOGUE = preload("res://dialogue/main.dialogue")

var inventory := {}



		
		
func _ready() -> void:
	# GameProgress.reset_progress()
	self.reset_progress()
	init_scene_data()
	change_scene_to(starting_scene_index)
	
	

func _process(_delta):
	pass


# call this func every time the game starts
func reset_progress() -> void:
	inventory = {
		"mop": false
	}
	
	
func init_scene_data() -> void:
		
	# initialize scene data
	var i = 0
	for scene:TextureRect in room_scenes:
		# show/hide scenes
		if i == current_scene_index:
			scene.show()
			current_room_scene = scene
		else:
			scene.hide()
		i += 1
		
		# bind item data for each scene
		var children = scene.get_children()
		for child:Button in children:
			var item_name = child.name
			print(item_name)
			
			var regex := RegEx.new()
			regex.compile("\\d+$")  # Ensure regex is compiled before use
			var cleaned_item_name = regex.sub(item_name, "", true)  # Correct usage
			print(cleaned_item_name)

			child.pressed.connect(_on_item_pressed.bind(cleaned_item_name))
			child.text = ""
			child.flat = true
		
		
func change_scene_to(new_scene_index:int) -> void:
	
	# hide current scene
	current_room_scene.hide()
	
	# update current scene
	print("index = %s" % new_scene_index)
	current_scene_index = new_scene_index % room_scenes.size()
	print("current_scene_index = %s" % current_scene_index)
	current_room_scene = room_scenes[current_scene_index]
	
	# show next scene
	current_room_scene.show()



func look_left() -> void:
	change_scene_to(current_scene_index - 1)
	
func look_right() -> void:
	change_scene_to(current_scene_index + 1)
	
	
	
	
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


# show dialogue
func show_dialogue(resource:DialogueResource, title:String="", extra_game_states:Array=[]) -> Node:
	var balloon:Node = BALLOON.instantiate()
	add_child(balloon)
	balloon.start(resource, title, extra_game_states)
	DialogueManager.dialogue_started.emit(resource)
	return balloon

# show dialogue when item pressed
func _on_item_pressed(item:String) -> void:
	# DialogueManager.show_example_dialogue_balloon(MAIN_DIALOGUE, item)  # shows example balloon
	# DialogueManager.show_dialogue_balloon(MAIN_DIALOGUE, item)  # shows balloon configured in Project Settings
	show_dialogue(MAIN_DIALOGUE, item)  # custom function
