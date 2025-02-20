extends Node2D

var MAIN = load("res://scenes/main.tscn")
@export var ending_text:Label

var MAIN_DIALOGUE = preload("res://dialogue/main.dialogue")
const BALLOON = preload("res://dialogue/balloon.tscn")

var custom_data = {"ending": "ending_normal"}

func _ready() -> void:
	if custom_data.ending != "ending_good":
		AudioManager.play_fx("fbi")
	else:
		AudioManager.play_fx("yay")
		
		
	show_dialogue(MAIN_DIALOGUE, custom_data.ending)  # custom function
	
	# unlock achievement
	unlock_achievement(custom_data.ending)

	match custom_data.ending:
		"ending_body":
			ending_text.text = "(why are you holding a dead body???)"
		"ending_normal":
			ending_text.text = "(you didn't hide enough evidence.)"
		"ending_time":
			ending_text.text = "(you ran out of time and the police showed up.)"
		"ending_window":
			ending_text.text = "(you got caught by the window guy.)"
		"ending_sleep":
			ending_text.text = "(you got caught sleeping on the job.)"
		"ending_webcam":
			ending_text.text = "(you got caught from webcam footage.)"
		"ending_gun":
			ending_text.text = "(you got caught with the murder weapon.)"
		"ending_vampire":
			ending_text.text = "(they found the victim's blood in your stomach.)"
		"ending_clean_hands":
			ending_text.text = "(you had suspiciously clean hands.)"
		"ending_good":
			ending_text.text = "(you got away.)"




func show_achievement_popup(achievement_name:String) -> void:
	# show achievement popup
	var popup = Panel.new()
	popup.size = Vector2(256, 84)
	var y_offset = 16
	popup.set_position(Vector2((get_viewport_rect().size.x - popup.size.x) / 2, y_offset))  # Center top
	popup.modulate.a = 0.0
	
	var label = Label.new()
	var ach_name = SaveData.achievement_names.get(achievement_name)
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
	if SaveData.has_unlocked(achievement_name):
		print("Player has reached '%s' before!" % achievement_name)
		return
	# update save data
	SaveData.unlock_achievement(achievement_name)
	# show popup
	show_achievement_popup(achievement_name)
	
	
	
	
func _on_main_menu_pressed() -> void:
	var _target_scene = MAIN.instantiate()
	var _type = "pixelated_noise"
	SceneManager.goto("main")

func _on_restart_level_pressed() -> void:
	SceneManager.goto("game")


# show dialogue
func show_dialogue(resource:DialogueResource, title:String="", extra_game_states:Array=[]) -> Node:
	var balloon:Node = BALLOON.instantiate()
	add_child(balloon)
	balloon.start(resource, title, extra_game_states)
	DialogueManager.dialogue_started.emit(resource)
	return balloon
