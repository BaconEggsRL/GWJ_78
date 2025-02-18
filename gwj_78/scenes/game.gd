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

@export var blur:Sprite2D
const BLUR = preload("res://shaders/blur.gdshader")

@export var mouse:Mouse
@export var none:InventoryButton

###########################################################
# Scenes

const BULLET_HOLE_RECT = preload("res://bullet_hole_rect.tscn")

@export var SCENE_1:TextureRect

@export var blood_pool_rect:TextureRect
@export var body_rect:TextureRect
@export var gun_rect:TextureRect
const SCENE_1_WITH_LAYERS__BODY_IN_TRASH = preload("res://assets/art/room_scenes/scene_1_with_layers__body_in_trash.png")
const WEBCAM_ON = preload("res://assets/art/room_scenes/webcam_on.png")
const WEBCAM_OFF = preload("res://assets/art/room_scenes/webcam_off.png")
@export var webcam_rect:TextureRect


@export var SCENE_2:TextureRect
const SCENE_2__BODY_UNDER_BED = preload("res://assets/art/room_scenes/scene_2__body_under_bed.png")

@export var SCENE_3:TextureRect
@onready var wash_count = 0

@export var SCENE_4:TextureRect
@export var window_rect:TextureRect
const CURTAINS_OPEN = preload("res://assets/art/room_scenes/curtains_open.png")
const CURTAINS_CLOSED = preload("res://assets/art/room_scenes/curtains_closed.png")
const CURTAINS_OPEN_EVENT = preload("res://assets/art/room_scenes/curtains_open_event.png")



@onready var room_scenes = [SCENE_1, SCENE_2, SCENE_3, SCENE_4]

@export var starting_scene_index = 0
@onready var current_scene_index = starting_scene_index

# @export var room_scene:TextureRect
var current_room_scene:TextureRect

###########################################################

# dialogue
const BALLOON = preload("res://dialogue/balloon.tscn")
var MAIN_DIALOGUE = preload("res://dialogue/main.dialogue")
var current_dialogue:Node  # reference to current dialogue
var response:String = ""

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
@export var max_seconds:float = 60 * 5.0
@onready var time_left:float = max_seconds
var time_elapsed := 0.0
@onready var window_event_time:float = max_seconds-1 # max_seconds / 2.0  # time for window check to occur
@onready var plays:Dictionary = {
	"Death of a Salesman": "Arthur Miller", 
	"To Kill a Mockingbird": "Harper Lee", 
	"Les Miserables": "Victor Hugo",
}
@onready var correct_play:String = ""
@onready var correct_author:String = ""
@onready var club_name:String = "Theatre Club"

signal out_of_time

###########################################################

# Endings

# called when the player tries to leave through the fron door
func exit_through_front_door() -> void:
	self.set_process(false)
	print("exit")
	AudioManager.play_fx("door_open")
	var ending:String = "ending_normal"
	
	# hide the body
	if state.hid_body == false:
		if inventory.body == true:
			ending = "ending_body"
		else:
			ending = "ending_normal"
	
	# hide the gun
	elif state.hid_gun == false:
		if inventory.gun == true:
			ending = "ending_gun"
		else:
			ending = "ending_normal"
			
	# clean the blood
	elif state.blood_cleaned == false:
		ending = "ending_normal"
	
	# Special endings
	elif state.webcam_off == false:
		ending = "ending_webcam"
		
	elif state.drank_blood == true:
		ending = "ending_vampire"
	
	# Good ending
	else:
		ending = "ending_good"
		
	# hid body
	# cleaned blood with mop
	# picked up the gun
	# webcam is off

	#inventory = {
		#"mop": false,
		#"gun": false,
		#"storage_closet_key": false,
		#"body": false,
	#}
	#state = {
		#"webcam_off": false,
		#
		#"hid_body": false,
		#"hid_body_in_trash": false,
		#"hid_body_under_bed": false,
		#"hid_body_in_storage_closet": false,
		#
		#"curtains_closed": false,
		#"window_event": false,
		#
		#"storage_closet_unlocked": false,
		#
		#"blood_cleaned": false,
		#"drank_blood": false,
	#}
	
	var custom_data = {"ending": ending}
	SceneManager.goto("ending", custom_data)



func sleep_in_bed() -> void:
	self.set_process(false)
	print("you got caught sleeping")
	var ending:String = "ending_sleep"
	var custom_data = {"ending": ending}
	SceneManager.goto("ending", custom_data)

func _on_out_of_time() -> void:
	self.set_process(false)
	print("you ran out of time")
	var ending:String = "ending_time"
	var custom_data = {"ending": ending}
	SceneManager.goto("ending", custom_data)
	
func _on_window_failed() -> void:
	self.set_process(false)
	print("you got caught")
	var ending:String = "ending_window"
	var custom_data = {"ending": ending}
	SceneManager.goto("ending", custom_data)
	


###########################################################



func update_time_label() -> void:
	if time_left >= -1:  # 1 second buffer before losing
		var display_time = ceil(time_left)
		var minutes = floor(display_time/60.0)
		var seconds = display_time - minutes * 60.0
		var pad = "0" if seconds < 10 else ""
		time_left_label.text = "Time left = %d:%s%d" % [minutes, pad, seconds]
	else:
		out_of_time.emit()




func drink_blood() -> void:
	var _fx = AudioManager.play_fx("drink_blood")
	# update state
	set_state("blood_cleaned", true)
	set_state("drank_blood", true)
	# tween out the blood texture
	var blood_tween = create_tween()
	blood_tween.tween_property(blood_pool_rect, "self_modulate:a", 0.0, 1.0)
	blood_tween.finished.connect(func():
		blood_pool_rect.visible = false
	)
	# await fx finished here
	await _fx.finished
	await get_tree().create_timer(0.5).timeout

	
	
	
	
func turn_webcam_off() -> void:
	AudioManager.play_fx("webcam_off")
	set_state("webcam_off", true)
	webcam_rect.texture = WEBCAM_OFF
	
	
	
	
func hide_body(location:String) -> void:
	match location:
		"sink":
			AudioManager.play_fx("garbage_disposal")
			# current_room_scene.texture = SCENE_1_WITH_LAYERS__BODY_IN_TRASH
			set_state("hid_body_sink", true)
		"trash":
			AudioManager.play_fx("trash")
			current_room_scene.texture = SCENE_1_WITH_LAYERS__BODY_IN_TRASH
			set_state("hid_body_in_trash", true)
		"bed_bottom":
			AudioManager.play_fx("body_drag")
			current_room_scene.texture = SCENE_2__BODY_UNDER_BED
			set_state("hid_body_under_bed", true)
		"storage_closet":
			AudioManager.play_fx("door_unlock")
			set_state("hid_body_in_storage_closet", true)
			
	# remove body from inventory
	set_inventory_item("body", false)
	# update game state
	set_state("hid_body", true)
	# mouse.set_state(mouse.State.NONE)


func hide_gun(location:String) -> void:
	match location:
		"sink":
			AudioManager.play_fx("garbage_disposal")
			# current_room_scene.texture = SCENE_1_WITH_LAYERS__BODY_IN_TRASH
			set_state("hid_gun_sink", true)
		"nightstand":
			AudioManager.play_fx("nightstand")
			# current_room_scene.texture = SCENE_1_WITH_LAYERS__BODY_IN_TRASH
			set_state("hid_gun_nightstand", true)
			
			
	# remove body from inventory
	set_inventory_item("gun", false)
	# update game state
	set_state("hid_gun", true)
	# mouse.set_state(mouse.State.NONE)
	
	
func _ready() -> void:
	# pick play
	var play_index:int = randi_range(0, plays.size()-1)
	print("play_index = %s" % play_index)
	correct_play = plays.keys()[play_index]
	correct_author = plays.values()[play_index]
	print("correct_play = %s" % correct_play)
	print("correct_author = %s" % correct_author)
	
	
	
	# play music
	AudioManager.play_music("music_funk", -6.0)
	
	
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
	mouse.fire_gun.connect(_on_fire_gun)
	
	# start game
	if not debug:
		# delete active dialogue
		if current_dialogue:
			current_dialogue.queue_free.call_deferred()
		# show dialogue
		current_dialogue = show_dialogue(MAIN_DIALOGUE, "opening_game")
	
	
	
func _process(_delta):
	time_left -= _delta
	time_elapsed += _delta
	# avoid updating every frame
	if time_elapsed >= 1.0:
		update_time_label()
		time_elapsed = 0.0
		# check windown event
		if ceil(time_left) == ceil(window_event_time):
			start_window_event()


func _create_shader_tween(node: Node, shader_property: String, value_start: float, value_end: float, duration: float) -> Tween:
	var tween = get_tree().create_tween()
	tween.tween_method(
		func(value): node.material.set_shader_parameter(shader_property, value),  
		value_start,
		value_end,
		duration
	);
	return tween


# eat the magic mushrooms
func eat_mushrooms() -> void:
	print("eat the mushrooms")
	var mat = ShaderMaterial.new()
	mat.shader = BLUR
	# apply material
	blur.material = mat
	
	# tween shader
	var tween_time = 3.0
	# set shader params
	_create_shader_tween(blur, "wave_amplitude", 0.0, 0.02, tween_time)
	_create_shader_tween(blur, "blob_strength", 0.0, 0.5, tween_time)
	# _create_shader_tween(blur, "lod", 0.0, 1.0, tween_time)
	# trippy dialogue
	var timer = get_tree().create_timer(tween_time + 1.0)
	timer.timeout.connect(func():
		# delete active dialogue
		if current_dialogue:
			current_dialogue.queue_free.call_deferred()
		# show dialogue
		show_dialogue(MAIN_DIALOGUE, "mushroom")
	)
	


# window event
func start_window_event() -> void:
	print("window time")
	# skip if curtains closed
	if state.curtains_closed == true:
		return
		
	# start window event
	AudioManager.play_fx("window_knock")
	
	# delete active dialogue
	if current_dialogue:
		current_dialogue.queue_free.call_deferred()
	# show window event
	current_dialogue = show_dialogue(MAIN_DIALOGUE, "window_event")
	
	# update texture
	window_rect.texture = CURTAINS_OPEN_EVENT
	# update game state
	set_state("window_event", true)
	


func stop_window_event(success:bool) -> void:
	window_rect.texture = CURTAINS_OPEN
	set_state("window_event", false)
	if success == false:
		_on_window_failed()




# called when closing the curtains
func close_curtains() -> void:
	AudioManager.play_fx("curtains")
	set_state("curtains_closed", true)
	# set new icon
	window_rect.texture = CURTAINS_CLOSED

# called when closing the curtains
func open_curtains() -> void:
	AudioManager.play_fx("curtains")
	set_state("curtains_closed", false)
	# set new icon
	window_rect.texture = CURTAINS_OPEN
	
	
	
# called when mopping the blood up
func mop_blood() -> void:
	AudioManager.play_fx("mopping_sound")
	set_state("blood_cleaned", true)
	set_inventory_item("mop", false)
	# tween out the blood texture
	var blood_tween = create_tween()
	blood_tween.tween_property(blood_pool_rect, "self_modulate:a", 0.0, 1.0)
	blood_tween.finished.connect(func():
		blood_pool_rect.visible = false
	)


# called when picking up the body
func pickup_body() -> void:
	set_inventory_item("body", true)
	# tween out the body texture
	var body_tween = create_tween()
	body_tween.tween_property(body_rect, "self_modulate:a", 0.0, 1.0)
	body_tween.finished.connect(func():
		body_rect.visible = false
	)
	
# called when picking up the gun
func pickup_gun() -> void:
	set_inventory_item("gun", true)
	# tween out the gun texture
	var gun_tween = create_tween()
	gun_tween.tween_property(gun_rect, "self_modulate:a", 0.0, 1.0)
	gun_tween.finished.connect(func():
		gun_rect.visible = false
	)

# wash your hands then ya flithy animal
func wash_hands() -> void:
	AudioManager.play_fx("sink_running")
	set_state("washed_hands", true)
	wash_count += 1
	
	
	

# fire gun
func _on_fire_gun(pos:Vector2 = get_global_mouse_position()) -> void:
	print("_on_fire_gun")
	add_bullet_hole(pos)
# add bullet hole at pos
func add_bullet_hole(pos:Vector2 = get_global_mouse_position()) -> void:
	print("add_bullet_hole")
	AudioManager.play_fx("gun_shot", -6.0)
	var bullet_hole = BULLET_HOLE_RECT.instantiate()
	bullet_hole.position = pos
	current_room_scene.add_child(bullet_hole)
	var bullet_hole_tween:Tween = create_tween()
	bullet_hole_tween.tween_property(bullet_hole, "self_modulate:a", 0.0, 1.0)
	bullet_hole_tween.finished.connect(func():
		bullet_hole.queue_free.call_deferred()
	)
	
	
# call this func every time the game starts
func reset_progress() -> void:
	inventory = {
		"mop": false,
		"gun": false,
		"storage_closet_key": false,
		"body": false,
	}
	state = {
		"webcam_off": false,
		"washed_hands": false,
		
		"hid_gun": false,
		"hid_gun_sink": false,
		"hid_gun_nightstand": false,
		
		"hid_body": false,
		"hid_body_sink": false,
		"hid_body_in_trash": false,
		"hid_body_under_bed": false,
		"hid_body_in_storage_closet": false,
		
		"curtains_closed": false,
		"window_event": false,
		
		"storage_closet_unlocked": false,
		
		"blood_cleaned": false,
		"drank_blood": false,
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
		print("hi")
		add_inventory_button(item_name)
	else:
		print("bye")
		remove_inventory_button(item_name)
		
		
func remove_inventory_button(item_name: String) -> void:
	var visible_count = 0
	var success = false
	for button:InventoryButton in inventory_container.get_children():
		if button.visible == true:
			visible_count += 1
			if button.item_name == item_name:
				print("removing button: %s" % item_name)
				inventory_container.remove_child(button)
				
				# change state if needed
				if mouse.current_state == mouse.get_state_from_string(item_name):
					mouse.set_state(mouse.State.NONE)
				
				# whether item was successfully removed
				success = true
			
	# make sure none is not visible, if there are no items left to show
	print(visible_count)
	if visible_count == 2:
		none.hide()
					
	if not success:
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
		"gun":
			button.icon = mouse.gun_sprite
		"body":
			button.icon = mouse.body_sprite
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
		for child in children:
			if child is TextureRect:
				if child.get_child_count() > 0:
					for btn in child.get_children():
						if btn is Button:
							init_button(btn)
			elif child is Button:
				init_button(child)
		

func init_button(child:Button) -> void:
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

# show dialogue when item pressed (button in scene)
func _on_item_pressed(item:String) -> void:
	# DialogueManager.show_example_dialogue_balloon(MAIN_DIALOGUE, item)  # shows example balloon
	# DialogueManager.show_dialogue_balloon(MAIN_DIALOGUE, item)  # shows balloon configured in Project Settings
	
	# delete active dialogue
	if current_dialogue:
		current_dialogue.queue_free.call_deferred()
	# show dialogue
	current_dialogue = show_dialogue(MAIN_DIALOGUE, item)

# pressed item in inventory
func _on_inventory_item_pressed(item:String) -> void:
	print(item)
	mouse.set_state(mouse.get_state_from_string(item))
