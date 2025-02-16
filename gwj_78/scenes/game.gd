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

###########################################################
# exports

@export var mouse:Mouse
@export var none:InventoryButton

###########################################################
# Scenes

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

# dialogue
const BALLOON = preload("res://dialogue/balloon.tscn")
var MAIN_DIALOGUE = preload("res://dialogue/main.dialogue")

# inventory
var inventory := {}
@export var inventory_container:Control
signal inventory_updated(item_name, value)
const FLOATY_SHADER = preload("res://shaders/floaty.gdshader")

# world state
var state := {}

# debugging
@export var debug = false

###########################################################

# time
@export var time_left_label:Label
@export var max_seconds:float = 10# 60 * 5.0
@onready var time_left:float = max_seconds
var time_elapsed := 0.0

signal out_of_time



func _on_out_of_time() -> void:
	self.set_process(false)
	print("you ran out of time")
	
	
func update_time_label() -> void:
	if time_left >= -1:
		var display_time = ceil(time_left)
		var minutes = floor(display_time/60.0)
		var seconds = display_time - minutes * 60.0
		var pad = "0" if seconds < 10 else ""
		time_left_label.text = "Time left = %d:%s%d" % [minutes, pad, seconds]
	else:
		out_of_time.emit()



func _ready() -> void:
	# GameProgress.reset_progress()
	self.reset_progress()
	init_scene_data()
	change_scene_to(starting_scene_index)
	update_time_label()
	
	# connect item buttons
	var visible_count = 0
	for child:InventoryButton in inventory_container.get_children():
		child.inventory_item_pressed.connect(_on_inventory_item_pressed)
		if debug:
			child.show()
		if child.visible and child.name != "none":
			visible_count += 1
			
	# inventory
	if visible_count == 0:
		none.hide()
	else:
		none.show()
		
	# signals
	inventory_updated.connect(_on_inventory_updated)
	out_of_time.connect(_on_out_of_time)
	
	
	
func _process(_delta):
	time_left -= _delta
	time_elapsed += _delta
	if time_elapsed >= 1.0:
		update_time_label()
		time_elapsed = 0.0


# call this func every time the game starts
func reset_progress() -> void:
	inventory = {
		"mop": false,
		"storage_closet_key": false,
	}
	state = {
		"curtains_closed": false,
		"storage_closet_unlocked": false,
	}


func set_state(state_name: String, value) -> void:
	if state.has(state_name): # and state[state_name] != value:
		state[state_name] = value
		match state_name:
			"curtains_closed":
				print("curtains_closed changed to %s" % value)
			"storage_closet_unlocked":
				print("storage_closet_unlocked changed to %s" % value)



func set_inventory_item(item_name: String, value: bool) -> void:
	if inventory.has(item_name): # and inventory[item_name] != value:
		inventory[item_name] = value
		inventory_updated.emit(item_name, value)  # Emit signal when changed

func _on_inventory_updated(item_name: String, value: bool) -> void:
	print("%s set to %s. Updating UI..." % [item_name, value])
	# Call function to add mop button to inventory UI
	if value == true:
		add_inventory_button(item_name)
	else:
		print("bye")
		remove_inventory_button(item_name)
		
		
func remove_inventory_button(item_name: String) -> void:
	print("ajksdnjaskdnkj")
	for button:InventoryButton in inventory_container.get_children():
		if button.item_name == item_name and button.visible == true:
			print("removing button: %s" % item_name)
			inventory_container.remove_child(button)
			# change state if needed
			if mouse.current_state == mouse.get_state_from_string(item_name):
				mouse.set_state(mouse.State.NONE)
			return
	print("button not found with name: %s" % item_name)
	
	
func add_inventory_button(item_name: String) -> void:
	# play pickup sound
	AudioManager.play_fx("item_pickup")
	
	var button := InventoryButton.new()
	match item_name:
		"mop":
			button.icon = mouse.mop_sprite
		"storage_closet_key":
			button.icon = mouse.key_sprite
	var mat := ShaderMaterial.new()
	mat.shader = FLOATY_SHADER
	button.material = mat
	
	# add child and set item name
	inventory_container.add_child(button)
	button.item_name = item_name
	
	# connect pressed signal
	button.inventory_item_pressed.connect(_on_inventory_item_pressed)
	
	# make sure none is visible
	none.show()
	



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

# pressed item in inventory
func _on_inventory_item_pressed(item:String) -> void:
	print(item)
	mouse.set_state(mouse.get_state_from_string(item))
