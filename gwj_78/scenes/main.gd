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

@export var old_art_btn:CheckBox
@export var music_options:OptionButton

@export var mouse:Mouse


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
	# AudioManager.play_music("music_funk", -6.0)
	# AudioManager.play_music("music_funk_menu", -6.0, false)
	AudioManager.play_music("music_alex_menu")
	
	play_btn.pressed.connect(_on_play_pressed)
	play_btn.mouse_entered.connect(_on_mouse_entered)
	
	achievements_btn.pressed.connect(_on_achievements_pressed)
	achievements_btn.mouse_entered.connect(_on_mouse_entered)
	
	music_options.item_selected.connect(_on_music_option_selected)




func _on_mouse_entered() -> void:
	AudioManager.play_fx("btn_hover", -12.0)
	
func _on_play_pressed() -> void:
	# AudioManager.stop_music(0.50)
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
	
	# music option
	music_options.select(save_data.music_option)
	
	
	

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


func _on_gyat_btn_pressed() -> void:
	AudioManager.play_fx("gyat")


func _on_music_option_selected(_index: int) -> void:
	var text = music_options.get_item_text(_index)
	print("selected: %s" % text)
