extends Node2D

@export var play_btn:Button
@export var achievements_btn:Button

const MANUAL_TEST = preload("res://ManualTest.tscn")
const GAME = preload("res://scenes/game.tscn")
const OPENING = preload("res://scenes/opening.tscn")

const FancyFade = preload("res://addons/transitions/FancyFade.gd")

var anim_speed = 0.5


@export var volume_btn:VolumeButton
@export var music_slider:VolumeSlider
@export var sfx_slider:VolumeSlider

@export var old_art_btn:CheckButton

@export var mouse:Mouse
@export var fingerprint_btn:Button
@onready var fingerprint_visible:bool = false
@export var footstep_timer:Timer

@export var footstep_container:Control
const FOOTPRINT_RECT = preload("res://footprint_rect.tscn")
var walk_angle:float = 0.0


var MAIN_DIALOGUE = preload("res://dialogue/main.dialogue")
const BALLOON = preload("res://dialogue/balloon.tscn")

# save data
var save_data:SaveData



func _ready() -> void:
	# load save data
	save_data = SaveData.load_or_create()
	
	# init scene
	init_scene()
	
	# play music
	AudioManager.play_music("music_funk", -6.0)
	
	
	play_btn.pressed.connect(_on_play_pressed)
	play_btn.mouse_entered.connect(_on_mouse_entered)
	
	achievements_btn.pressed.connect(_on_achievements_pressed)
	achievements_btn.mouse_entered.connect(_on_mouse_entered)
	
	# fingerprint shananigans
	randomize_fingerprint(true)




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


func _on_old_art_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		save_data.use_old_art = true
	else:
		save_data.use_old_art = false
	save_data.save()


func erase_data() -> void:
	save_data.clear()
	init_scene()
	
	
func init_scene() -> void:
	# volume button
	volume_btn.set_state(save_data.load_volume_state(), false)
	
	# volume sliders
	music_slider.value = save_data.bus_volume.get("music", 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear_to_db(music_slider.value))
	
	sfx_slider.value = save_data.bus_volume.get("sfx", 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), linear_to_db(sfx_slider.value))
	
	# old art optino
	old_art_btn.button_pressed = save_data.use_old_art
	
	
	

func _on_erase_data_mouse_entered() -> void:
	# mouse.set_state(mouse.State.ERASER)
	pass

func _on_erase_data_mouse_exited() -> void:
	# mouse.set_state(mouse.State.NONE)
	pass


func _on_erase_data_pressed() -> void:
	# show dialogue
	var _dialogue = show_dialogue(MAIN_DIALOGUE, "erase_data")  # custom function


# show dialogue
func show_dialogue(resource:DialogueResource, title:String="", extra_game_states:Array=[]) -> Node:
	var balloon:Node = BALLOON.instantiate()
	add_child(balloon)
	balloon.start(resource, title, extra_game_states)
	DialogueManager.dialogue_started.emit(resource)
	return balloon




func _create_shader_tween(node: Node, shader_property: String, value_start: float, value_end: float, duration: float) -> Tween:
	var tween = get_tree().create_tween()
	tween.tween_method(
		func(value): node.material.set_shader_parameter(shader_property, value),  
		value_start,
		value_end,
		duration
	);
	return tween
	

func fade_fingerprint(make_visible:bool, fade_time:float=0.5, max_alpha:float=0.5) -> Tween:
	if fingerprint_btn.material and fingerprint_btn.material is ShaderMaterial:
		var current_alpha = fingerprint_btn.material.get_shader_parameter("alpha_control")
		var start_val: float = current_alpha as float if current_alpha != null else (0.0 if make_visible else max_alpha)
		var end_val: float = max_alpha if make_visible else 0.0
		
		fingerprint_visible = !fingerprint_visible
		return _create_shader_tween(fingerprint_btn, "alpha_control", start_val, end_val, fade_time)
	else:
		return null


func randomize_fingerprint(instant:bool = false) -> void:
	# Generate a random rotation
	var rot = randf_range(-PI, PI)
	
	var min_distance = 200.0  # Minimum movement distance
	var max_distance = 400.0 # Maximum movement distance
	var walk_speed = 150.0
	
	# Generate a random direction
	walk_angle = randf_range(0, TAU)  # TAU = 2 * PI (full circle)
	var distance = randf_range(min_distance, max_distance)  # Ensure distance is at least min_distance

	# Calculate new position within the valid range
	var offset = Vector2(cos(walk_angle), sin(walk_angle)) * distance
	var target_pos = fingerprint_btn.position + offset

	# Ensure the position stays within screen bounds
	var margin: float = 128.0 / 2.0
	target_pos.x = clamp(target_pos.x, margin, 1280 - margin)
	target_pos.y = clamp(target_pos.y, margin, 720 - margin)

	# Recalculate actual moved distance (after clamping)
	var actual_distance = (fingerprint_btn.position - target_pos).length()
	
	# If the clamped position made the movement too small, re-roll the position
	if actual_distance < min_distance:
		return randomize_fingerprint()

	# Calculate movement duration
	var walk_time = actual_distance / walk_speed

	# Apply rotation
	fingerprint_btn.rotation = rot
	
	# Tween movement
	if instant == false:
		
		footstep_timer.start()
		
		var pos_tween: Tween = create_tween()
		pos_tween.tween_property(fingerprint_btn, "position", target_pos, walk_time)
		# fade in btn after moved
		pos_tween.finished.connect(func():
			print("reset")
			# stop footsteps
			footstep_timer.stop()
			# fade in texture
			fade_fingerprint(true)
			# reset mouse filter to clickable
			fingerprint_btn.mouse_filter = Control.MOUSE_FILTER_STOP
		)

	else:
		print("reset")
		fingerprint_btn.position = target_pos
		fade_fingerprint(true)
		fingerprint_btn.mouse_filter = Control.MOUSE_FILTER_STOP
		
		


	
	
	
				
				
func _on_fingerprint_btn_pressed() -> void:
	print("pressed")
	if fingerprint_visible:
		fingerprint_btn.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		# fade out tween
		var tween:Tween = fade_fingerprint(false)
		if tween:
			tween.finished.connect(func():
				print("move")
				# move position randomly
				randomize_fingerprint()
			)
	else:
		fade_fingerprint(true)


func _on_footstep_timer_timeout() -> void:
	print("step")
	var footprint = FOOTPRINT_RECT.instantiate()
	var offset:float = 20.0
	var offset_vector = Vector2(randf_range(-offset, offset), randf_range(-offset, offset))
	footprint.position = fingerprint_btn.position + offset_vector
	footprint.rotation = walk_angle + PI/2
	footstep_container.add_child(footprint)
	
