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

@export var scene_container:MarginContainer

const ROOM_SCENE_1_NEW = preload("res://room_scenes/new_art/room_scene_1.tscn")
const ROOM_SCENE_2_NEW = preload("res://room_scenes/new_art/room_scene_2.tscn")
const ROOM_SCENE_3_NEW = preload("res://room_scenes/new_art/room_scene_3.tscn")
const ROOM_SCENE_4_NEW = preload("res://room_scenes/new_art/room_scene_4.tscn")

const ROOM_SCENE_1 = preload("res://room_scenes/old_art/room_scene_1.tscn")
const ROOM_SCENE_2 = preload("res://room_scenes/old_art/room_scene_2.tscn")
const ROOM_SCENE_3 = preload("res://room_scenes/old_art/room_scene_3.tscn")
const ROOM_SCENE_4 = preload("res://room_scenes/old_art/room_scene_4.tscn")


# new inventory icons
const INVENTORY_NONE = preload("res://assets/art/inventory_objects/none.png")

const INVENTORY_CORPSE_NEW = preload("res://room_scenes/new_art/Inventory icons/Inventory - corpse.png")
const INVENTORY_KEY_NEW = preload("res://room_scenes/new_art/Inventory icons/Inventory-1.png")
const INVENTORY_MOP_NEW = preload("res://room_scenes/new_art/Inventory icons/Inventory-2.png")
const INVENTORY_GUN_NEW = preload("res://room_scenes/new_art/Inventory icons/Inventory-3.png")
const INVENTORY_NONE_NEW = preload("res://room_scenes/new_art/Inventory icons/Inventory-4.png")




var SCENE_1:TextureRect

var blood_pool_rect:TextureRect
var body_rect:TextureRect
var gun_rect:TextureRect
var webcam_rect:TextureRect

const SCENE_1_WITH_LAYERS__BODY_IN_TRASH = preload("res://assets/art/room_scenes/scene_1_with_layers__body_in_trash.png")
const TRASH_WITH_CORPSE_NEW = preload("res://room_scenes/new_art/Assets - scene 1/Trash_with_corpse.png")

const WEBCAM_ON = preload("res://assets/art/room_scenes/webcam_on.png")
const WEBCAM_OFF = preload("res://assets/art/room_scenes/webcam_off.png")
const WEBCAM_ON_NEW = preload("res://room_scenes/new_art/Assets - scene 1/Webcam-on.png")
const WEBCAM_OFF_NEW = preload("res://room_scenes/new_art/Assets - scene 1/Webcam-off.png")

const CLOSET_CLOSED_NEW = preload("res://room_scenes/new_art/Assets - scene 1/Closet.png")
const CLOSET_OPEN_NEW = preload("res://room_scenes/new_art/Assets - scene 1/Closet-open.png")


var SCENE_2:TextureRect
const SCENE_2__BODY_UNDER_BED = preload("res://assets/art/room_scenes/scene_2__body_under_bed.png")
# const CORPSE_1_NEW = preload("res://room_scenes/new_art/Assets - scene 1/Corpse-1.png")
const CORPSE_BED_2 = preload("res://room_scenes/new_art/Assets - scene 2/Corpse-bed.png")
const CORPSE_BED_4 = preload("res://room_scenes/new_art/Assets - scene 4/Corpse-bed (1).png")


var SCENE_3:TextureRect
@onready var wash_count = 0
const SINK_OFF_NEW = preload("res://room_scenes/new_art/Assets - scene 3/Sink-off.png")
const SINK_ON_NEW = preload("res://room_scenes/new_art/Assets - scene 3/Sink-on.png")



var SCENE_4:TextureRect
var window_rect:TextureRect

const CURTAINS_OPEN = preload("res://assets/art/room_scenes/curtains_open.png")
const CURTAINS_CLOSED = preload("res://assets/art/room_scenes/curtains_closed.png")
const CURTAINS_OPEN_EVENT = preload("res://assets/art/room_scenes/curtains_open_event.png")

const CURTAINS_OPEN_NEW = preload("res://room_scenes/new_art/Assets - scene 4/Curtain-open-window-shut.png")
const CURTAINS_CLOSED_NEW = preload("res://room_scenes/new_art/Assets - scene 4/Curtains-closed.png")
const CURTAINS_OPEN_EVENT_NEW = preload("res://room_scenes/new_art/Assets - scene 4/Witness-in-window.png")



var room_scenes:Array

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


###########################################################

# time
@export var time_left_label:Label
# evidence
@export var evidence_left_label:Label
@onready var evidence_left:int = 3

@export var max_seconds:float = 60 * 5.0
@onready var time_left:float = max_seconds
var time_elapsed := 0.0
@onready var window_event_time:float = max_seconds * 0.8  # time for window check to occur
@onready var plays:Dictionary = {
	"Death of a Salesman": "Arthur Miller", 
	"To Kill a Mockingbird": "Harper Lee", 
	"Les Miserables": "Victor Hugo",
}
@onready var correct_play:String = ""
@onready var correct_author:String = ""
@onready var club_name:String = "Theatre Club"

signal out_of_time


# debugging
@export var debug = false


# save data
var save_data:SaveData


###########################################################



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		print("You pressed left!")
		change_scene_to(current_scene_index - 1)
		
	if event.is_action_pressed("right"):
		print("You pressed right!")
		change_scene_to(current_scene_index + 1)
	
	


# Endings

# called when the player tries to leave through the fron door
func exit_through_front_door() -> void:
	self.set_process(false)
	print("exit")
	AudioManager.play_fx("door_open")
	var ending:String = "ending_normal"
	
	# hide the gun
	if state.hid_gun == false:
		if inventory.gun == true:
			if mouse.current_state != mouse.State.GUN:
				ending = "ending_gun"
			else:
				ending = "ending_shootout"
		else:
			ending = "ending_normal"
	
	# hide the body
	elif state.hid_body == false:
		if inventory.body == true:
			ending = "ending_body"
		else:
			ending = "ending_normal"
			
	# clean the blood
	elif state.blood_cleaned == false:
		ending = "ending_normal"
	
	# Event endings
	elif state.window_event == true:
		ending = "ending_window"
	
	# Special endings
	elif state.webcam_off == false:
		ending = "ending_webcam"
		
	elif state.blood_cleaned_drank == true:
		ending = "ending_vampire"
		
	elif state.washed_hands == true:
		ending = "ending_clean_hands"
	
	
	
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
		#"blood_cleaned_drank": false,
		#"blood_cleaned_mopped": false,
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


func update_evidence_label() -> void:
	evidence_left_label.text = "Evidence left: %d" % evidence_left



func drink_blood() -> void:
	var _fx = AudioManager.play_fx("drink_blood", -6.0)
	# update state
	set_state("blood_cleaned", true)
	set_state("blood_cleaned_drank", true)
	# tween out the blood texture
	var blood_tween = create_tween()
	blood_tween.tween_property(blood_pool_rect, "self_modulate:a", 0.0, 1.0)
	blood_tween.finished.connect(func():
		blood_pool_rect.visible = false
	)
	# await fx finished here
	await _fx.finished
	await get_tree().create_timer(0.5).timeout
	
	# update evidence label
	evidence_left -= 1
	update_evidence_label()

	
	
	
	
func turn_webcam_off() -> void:
	AudioManager.play_fx("webcam_off")
	set_state("webcam_off", true)
	webcam_rect.texture = WEBCAM_OFF if save_data.use_old_art else WEBCAM_OFF_NEW
	
	# removed -- webcam doesn't really count as "evidence", although it's required to win
	# update evidence label
	# evidence_left -= 1
	# update_evidence_label()
	
	
	
	
func hide_body(location:String) -> void:
	match location:
		"sink":
			AudioManager.play_fx("garbage_disposal")
			set_state("hid_body_sink", true)
		"trash":
			AudioManager.play_fx("trash")
			if save_data.use_old_art:
				current_room_scene.texture = SCENE_1_WITH_LAYERS__BODY_IN_TRASH
			else:
				var trash_rect:TextureRect = current_room_scene.get_node("trash_rect")
				trash_rect.texture = TRASH_WITH_CORPSE_NEW
			set_state("hid_body_in_trash", true)
		"bed_bottom":
			AudioManager.play_fx("body_drag")
			if save_data.use_old_art:
				current_room_scene.texture = SCENE_2__BODY_UNDER_BED
			else:
				var body_under_bed_rect_2 = SCENE_2.get_node("body_under_bed_rect")
				body_under_bed_rect_2.texture = CORPSE_BED_2
				body_under_bed_rect_2.show()
				var body_under_bed_rect_4 = SCENE_4.get_node("body_under_bed_rect")
				body_under_bed_rect_4.texture = CORPSE_BED_4
				body_under_bed_rect_4.show()
				
			set_state("hid_body_under_bed", true)
		"storage_closet":
			AudioManager.play_fx("door_unlock")
			set_state("hid_body_in_storage_closet", true)
			
	# remove body from inventory
	set_inventory_item("body", false)
	# update game state
	set_state("hid_body", true)
	# mouse.set_state(mouse.State.NONE)
	
	# update evidence label
	evidence_left -= 1
	update_evidence_label()


func hide_gun(location:String) -> void:
	match location:
		"sink":
			AudioManager.play_fx("garbage_disposal")
			set_state("hid_gun_sink", true)
		"nightstand":
			AudioManager.play_fx("nightstand")
			set_state("hid_gun_nightstand", true)
			
			
	# remove body from inventory
	set_inventory_item("gun", false)
	# update game state
	set_state("hid_gun", true)
	# mouse.set_state(mouse.State.NONE)
	
	# update evidence label
	evidence_left -= 1
	update_evidence_label()
	

###########################################################



func _ready() -> void:
	# load save data
	save_data = SaveData.load_or_create()
	
	# get target volume
	var target_volume = save_data.volume_dict[save_data.load_volume_state()]
	AudioServer.set_bus_volume_db(0, target_volume)
	
	# play music
	AudioManager.play_music("music_funk", -6.0)
	
	# turn off timer shader
	time_left_label.material.set_shader_parameter("enable_flash", false)
	
	
	
	# old art
	if save_data.use_old_art:
		SCENE_1 = ROOM_SCENE_1.instantiate()
		SCENE_2 = ROOM_SCENE_2.instantiate()
		SCENE_3 = ROOM_SCENE_3.instantiate()
		SCENE_4 = ROOM_SCENE_4.instantiate()

		room_scenes = [SCENE_1, SCENE_2, SCENE_3, SCENE_4]
		
		scene_container.add_theme_constant_override("margin_left", 16)
		scene_container.add_theme_constant_override("margin_top", 16)
		scene_container.add_theme_constant_override("margin_right", 16)
		scene_container.add_theme_constant_override("margin_bottom", 16)
		
	else:
		SCENE_1 = ROOM_SCENE_1_NEW.instantiate()
		SCENE_2 = ROOM_SCENE_2_NEW.instantiate()
		SCENE_3 = ROOM_SCENE_3_NEW.instantiate()
		SCENE_4 = ROOM_SCENE_4_NEW.instantiate()
		
		room_scenes = [SCENE_1, SCENE_2, SCENE_4, SCENE_3]
		
		scene_container.add_theme_constant_override("margin_left", 0)
		scene_container.add_theme_constant_override("margin_top", 0)
		scene_container.add_theme_constant_override("margin_right", 0)
		scene_container.add_theme_constant_override("margin_bottom", 0)
	
	# add childs
	scene_container.add_child(SCENE_1)
	scene_container.add_child(SCENE_2)
	scene_container.add_child(SCENE_3)
	scene_container.add_child(SCENE_4)
	
	# update vars
	blood_pool_rect = SCENE_1.get_node("blood_pool_rect")
	body_rect = SCENE_1.get_node("body_rect")
	gun_rect = SCENE_1.get_node("gun_rect")
	webcam_rect = SCENE_1.get_node("webcam_rect")
	window_rect = SCENE_4.get_node("window_rect")


	
	# pick play
	var play_index:int = randi_range(0, plays.size()-1)
	print("play_index = %s" % play_index)
	correct_play = plays.keys()[play_index]
	correct_author = plays.values()[play_index]
	print("correct_play = %s" % correct_play)
	print("correct_author = %s" % correct_author)

	
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
	
	# evidence label
	update_evidence_label()
	
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
	
	var update_time := 1.0
	
	# double time during window event
	if state.window_event == true:
		update_time = 0.5
		time_left -= _delta
		
	# avoid updating every frame
	if time_elapsed >= update_time:
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
	# unlock achievement
	unlock_achievement("shrooms")
	
	
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
	
	
	

func show_achievement_popup(achievement_name:String) -> void:
	# show achievement popup
	var popup = Panel.new()
	popup.size = Vector2(256, 84)
	
	# var y_offset = 16  # 16 px from the top
	var y_offset = get_viewport_rect().size.y - popup.size.y - 16  # 16px from the bottom
	popup.set_position(Vector2((get_viewport_rect().size.x - popup.size.x) / 2, y_offset))  # Center top
	popup.modulate.a = 0.0
	
	var label = Label.new()
	var ach_name = save_data.achievement_names.get(achievement_name)
	label.text = "Achievement Unlocked: \n" + ach_name.replace("_", " ").capitalize()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	# label.set_anchors_preset(Control.PRESET_CENTER)
	
	# Set the label's size to match the panel's size
	label.size = popup.size
	# Center the label within the panel
	label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	
	# add label
	popup.add_child(label)
	
	# add poppup
	self.add_child(popup)
	
	# Animate popup with proper tween management
	var tween_in = create_tween()
	tween_in.tween_property(popup, "modulate:a", 1.0, 1.0)  # Fade in
	
	# remove popup
	get_tree().create_timer(3.0).timeout.connect(func():
		var tween_out = create_tween()
		tween_out.tween_property(popup, "modulate:a", 0.0, 1.0)  # Fade out
		await tween_out.finished
		popup.queue_free.call_deferred()  # Remove popup after animation
	)
	
	

func unlock_achievement(achievement_name:String) -> void:
	# unlock achievement
	# check if this ending has been reached before
	if save_data.has_unlocked(achievement_name):
		print("Player has reached '%s' before!" % achievement_name)
		return
	# update save data
	save_data.unlock_achievement(achievement_name)
	# show popup
	show_achievement_popup(achievement_name)


# window event
func start_window_event() -> void:
	print("window time")
	# skip if curtains closed
	if state.curtains_closed == true:
		return
		
	# start window event
	AudioManager.play_fx("window_knock")
	
	# change to window scene
	var window_index:int
	if save_data.use_old_art:
		window_index = 3
	else:
		window_index = 2
	change_scene_to(window_index)
	
	# delete active dialogue
	if current_dialogue:
		current_dialogue.queue_free.call_deferred()
	# show window event
	current_dialogue = show_dialogue(MAIN_DIALOGUE, "window_event")
	
	# update texture
	var new_texture:CompressedTexture2D
	if save_data.use_old_art:
		new_texture = CURTAINS_OPEN_EVENT
	else:
		new_texture = CURTAINS_OPEN_EVENT_NEW
	window_rect.texture = new_texture
	# update game state
	set_state("window_event", true)
	
	# start timer shader
	time_left_label.material.set_shader_parameter("enable_flash", true)
	
	


func stop_window_event(success:bool) -> void:
	var new_texture:CompressedTexture2D
	if save_data.use_old_art:
		new_texture = CURTAINS_OPEN
	else:
		new_texture = CURTAINS_OPEN_NEW
	window_rect.texture = new_texture
	set_state("window_event", false)
	if success == false:
		_on_window_failed()
		
	# stop timer shader
	time_left_label.material.set_shader_parameter("enable_flash", false)



# called when opening the storage closet with the key
func unlock_storage_closet() -> void:
	set_state("storage_closet_unlocked", true)
	set_inventory_item("storage_closet_key", false)
	AudioManager.play_fx("door_unlock")
	# update texture
	var new_texture:CompressedTexture2D
	if save_data.use_old_art:
		pass
	else:
		new_texture = CLOSET_OPEN_NEW
		var storage_closet_rect = SCENE_1.get_node("storage_closet_rect")
		storage_closet_rect.texture = new_texture
		var mop_rect = SCENE_1.get_node("mop_rect")
		mop_rect.show()
	

# called when closing the curtains
func close_curtains() -> void:
	AudioManager.play_fx("curtains")
	set_state("curtains_closed", true)
	# set new icon
	var new_texture:CompressedTexture2D
	if save_data.use_old_art:
		new_texture = CURTAINS_CLOSED
	else:
		new_texture = CURTAINS_CLOSED_NEW
	window_rect.texture = new_texture

# called when closing the curtains
func open_curtains() -> void:
	AudioManager.play_fx("curtains")
	set_state("curtains_closed", false)
	# set new icon
	var new_texture:CompressedTexture2D
	if save_data.use_old_art:
		new_texture = CURTAINS_OPEN
	else:
		new_texture = CURTAINS_OPEN_NEW
	window_rect.texture = new_texture
	
	
	
# called when mopping the blood up
func mop_blood() -> void:
	AudioManager.play_fx("mopping_sound")
	set_state("blood_cleaned", true)
	set_state("blood_cleaned_mopped", true)
	set_inventory_item("mop", false)
	# tween out the blood texture
	var blood_tween = create_tween()
	blood_tween.tween_property(blood_pool_rect, "self_modulate:a", 0.0, 1.0)
	blood_tween.finished.connect(func():
		blood_pool_rect.visible = false
	)
	
	# update evidence label
	evidence_left -= 1
	update_evidence_label()


# called when picking up the mop
func pickup_mop() -> void:
	set_inventory_item("mop", true)
	# tween out mop texture, if it exists
	if save_data.use_old_art:
		pass
	else:
		var mop_rect = SCENE_1.get_node("mop_rect")
		var mop_tween = create_tween()
		mop_tween.tween_property(mop_rect, "self_modulate:a", 0.0, 1.0)
		mop_tween.finished.connect(func():
			mop_rect.visible = false
		)
	
	
# called when picking up the body
func pickup_body() -> void:
	set_inventory_item("body", true)
	# tween out the body texture
	var bodies:Array = []
	if save_data.use_old_art == false:
		bodies = [body_rect, SCENE_2.get_node("body_rect")]
	else:
		bodies = [body_rect]
	for body in bodies:
		var body_tween = create_tween()
		body_tween.tween_property(body, "self_modulate:a", 0.0, 1.0)
		body_tween.finished.connect(func():
			body.visible = false
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
	# update sink sprite
	toggle_sink(true)


func _on_sink_timer_timeout() -> void:
	var SINK_SCENE = SCENE_3
	var sink_rect:TextureRect = SINK_SCENE.get_node("sink_rect")
	var soap_particles:SoapParticles = sink_rect.get_node("soap_particles")
	# soap_particles.enabled = false
	soap_particles.emitting = false
	sink_rect.texture = SINK_OFF_NEW


func toggle_sink(_toggled_on:bool) -> void:
	var SINK_SCENE = SCENE_3

	if save_data.use_old_art == true:
		return
		
	var sink_rect:TextureRect = SINK_SCENE.get_node("sink_rect")
	var sink_timer:Timer = sink_rect.get_node("sink_timer")
	var soap_particles:SoapParticles = sink_rect.get_node("soap_particles")
	
	if not sink_timer.timeout.is_connected(_on_sink_timer_timeout):
		sink_timer.timeout.connect(_on_sink_timer_timeout)
			
	if _toggled_on:
		sink_rect.texture = SINK_ON_NEW
		# soap_particles.enabled = true
		soap_particles.emitting = true
		sink_timer.start()
	else:
		# soap_particles.enabled = false
		soap_particles.emitting = false
		sink_rect.texture = SINK_OFF_NEW
	
	
	

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
		"blood_cleaned_drank": false,
		"blood_cleaned_mopped": false,
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
	if save_data.use_old_art == true:
		none.icon = INVENTORY_NONE
		match item_name:
			"mop":
				button.icon = mouse.mop_sprite
			"storage_closet_key":
				button.icon = mouse.key_sprite
			"gun":
				button.icon = mouse.gun_sprite
			"body":
				button.icon = mouse.body_sprite
	else:
		none.icon = INVENTORY_NONE_NEW
		match item_name:
			"mop":
				button.icon = INVENTORY_MOP_NEW
			"storage_closet_key":
				button.icon = INVENTORY_KEY_NEW
			"gun":
				button.icon = INVENTORY_GUN_NEW
			"body":
				button.icon = INVENTORY_CORPSE_NEW
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
