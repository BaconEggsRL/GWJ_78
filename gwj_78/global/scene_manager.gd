extends Node


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var overlay: ColorRect = $CanvasLayer/Overlay

# transitions
const _TRANSITIONS = {
	# Circles
	"circle_in": preload("res://global/transitions/circle.tres"),
}

# scenes
const MAIN = preload("res://scenes/main.tscn")
const GAME = preload("res://scenes/game.tscn")
const OPENING = preload("res://scenes/opening.tscn")
const ENDING = preload("res://scenes/ending.tscn")
const ACHIEVEMENTS = preload("res://scenes/achievements.tscn")

var next_scene:Resource




## Circle
#func circle_in(scene, fade_seconds:float = 1.0) -> void:
	#_fade("circle_in", scene, fade_seconds)
#
## Core method
#func _fade(type:String, scene, fade_seconds:float = 1.0) -> void:
	#Transitions.change_scene_to_instance(scene, Transitions.FadeType.Blend, fade_seconds, _TRANSITIONS[type])
	
	
#func change_scene_to_instance(new_scene, fade_type, fade_time_seconds:float = 1.0, shader_image:CompressedTexture2D = null) -> void:
	#if new_scene == null:
		#push_error("Can't change scene to null scene!")
	#elif not is_instance_valid(new_scene):
		#push_error("Can't change to scene that's freed!")
	#
	##if fade_type == FadeType.Blend and shader_image == null:
		##push_error("You need to specify a shader image for blending!")
	#
	#var data = _common_pre_fade(fade_type, fade_time_seconds, shader_image)
	#_set_scene(new_scene)
	#emit_signal("pre_transition")
	#
	#await _common_wait_for_fade(data, fade_type, fade_time_seconds)
	#
	#_common_post_fade(data, new_scene)
	#emit_signal("post_transition")
	
	
	
func _ready() -> void:
	# save_data = SaveData.load_or_create()
	# set bus volume
	# set_bus_volume()
	animation_player.speed_scale = 1.5
	pass
	
	
# set volume of each bus from save data
#func set_bus_volume() -> void:
	#for bus_name in save_data.bus_volume:
		#var bus_index = AudioServer.get_bus_index(bus_name)
		#var value = save_data.bus_volume[bus_name]
		#AudioServer.set_bus_volume_db(
			#bus_index,
			#linear_to_db(value)
		#)
		
		
		
		
		

func _play_animation(anim_name: String) -> void:
	if !animation_player.has_animation(anim_name):
		push_warning("'%s' animation does not exist in SceneManager" % anim_name)
	else:
		animation_player.play(anim_name)


func _load_next_scene(scene:Resource, custom_data:Dictionary={}) -> void:
	var tree: SceneTree = get_tree()
	tree.change_scene_to_packed(scene)
	tree.root.child_entered_tree.connect(_on_child_entered_tree.bind(custom_data), CONNECT_ONE_SHOT)


func _on_child_entered_tree(scene:Node, custom_data:Dictionary={}) -> void:
	assert(scene == get_tree().current_scene) # at this point it's set
	if custom_data != {}:
		for property in scene.get_property_list():
			if property.name == "custom_data":
				print("custom data!")
				scene.custom_data = custom_data # pass custom data or whatever
				return
		print("no custom data!")
	

func _goto(scene:Resource, custom_data:Dictionary={}, fade_out:String="fade_out", fade_in:String="fade_in") -> void:
	# disable mouse clicks during transition
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	# play transition
	# AudioManager.play_fx("scene_transition")
	_play_animation(fade_out)
	await animation_player.animation_finished
	_load_next_scene(scene, custom_data)
	_play_animation(fade_in)
	await animation_player.animation_finished
	# enable mouse clicks after new scene is loaded in
	# could do this before animation finshes, but it might break aniamtion continuity
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	
	
func goto(scene_name:String, custom_data:Dictionary={}, fade_out:String="fade_out", fade_in:String="fade_in") -> void:
	var scene:Resource
	match scene_name:
		"main":
			scene = MAIN
		"game":
			scene = GAME
		"opening":
			scene = OPENING
		"ending":
			scene = ENDING
		"achievements":
			scene = ACHIEVEMENTS
		_:
			push_warning("'%s' has no resource listed in SceneManager" % scene_name)
	
	if scene:
		_goto(scene, custom_data, fade_out, fade_in)
