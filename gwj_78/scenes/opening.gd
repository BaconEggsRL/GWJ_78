extends Node2D

var MAIN = load("res://scenes/main.tscn")

var MAIN_DIALOGUE = preload("res://dialogue/main.dialogue")
const BALLOON = preload("res://dialogue/balloon.tscn")

const SKIP_CONTAINER = preload("res://skip_container.tscn")

# old art
# const OPENING_1 = preload("res://assets/art/room_scenes/opening_1.png")
@export var opening_scene:TextureRect
# new art
@export var background:AnimatedSprite2D


# save data
var save_data:SaveData



func _ready() -> void:
	# load save data
	save_data = SaveData.load_or_create()
	
	# set visible and animation
	if save_data.use_old_art == true:
		background.stop()
		background.hide()
		opening_scene.show()
	else:
		background.play()
		background.show()
		opening_scene.hide()
	
	# get target volume
	var target_volume = save_data.volume_dict[save_data.load_volume_state()]
	AudioServer.set_bus_volume_db(0, target_volume)

	# play music
	# AudioManager.play_music("music_funk", -6.0, false)
	# AudioManager.play_music("music_alex")

	
	# show dialogue
	var dialogue = show_dialogue(MAIN_DIALOGUE, "opening")  # custom function
	
	# add skip
	var skip = SKIP_CONTAINER.instantiate()
	dialogue.add_child(skip)
	skip.get_node("skip").pressed.connect(_on_skip_pressed)


#func _on_main_menu_pressed() -> void:
	#var _target_scene = MAIN.instantiate()
	#var _type = "pixelated_noise"
	#SceneManager.goto("main")
#
#func _on_restart_level_pressed() -> void:
	#SceneManager.goto("game")


# show dialogue
func show_dialogue(resource:DialogueResource, title:String="", extra_game_states:Array=[]) -> Node:
	var balloon:Node = BALLOON.instantiate()
	add_child(balloon)
	balloon.start(resource, title, extra_game_states)
	DialogueManager.dialogue_started.emit(resource)
	return balloon


func start_game() -> void:
	SceneManager.goto("game")
	
func _on_skip_pressed() -> void:
	start_game()



func phone_ring() -> void:
	AudioManager.play_fx("phone_ring", -12.0)

#func pick_up_phone() -> void:
	#AudioManager.play_fx("pick_up_phone", -12.0)
	#background.stop()
	
func slam_down_phone() -> void:
	AudioManager.play_fx("slam_down_phone", -12.0)
	background.stop()
	
