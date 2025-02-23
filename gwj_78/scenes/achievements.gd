extends Node2D

@export var main_menu_btn:Button
@export var grid_container:GridContainer

@export var fireworks:ColorRect

# save data
var save_data:SaveData

# box
const ACHIEVEMENT_BOX_CONTAINER = preload("res://achievement_box_container.tscn")



func _ready() -> void:
	# load save data
	save_data = SaveData.load_or_create()
	
	# get target volume
	var target_volume = save_data.volume_dict[save_data.load_volume_state()]
	AudioServer.set_bus_volume_db(0, target_volume)
	
	
	var unlocked_all = save_data.has_unlocked_all()
	if unlocked_all:
		fireworks.show()
	else:
		fireworks.hide()
	main_menu_btn.pressed.connect(_to_main)
	display_achievements()
	


func display_achievements() -> void:
	var achievements = save_data.get_all_achievements()
	for ach in achievements:
		var _box = add_achievement_box(ach.icon, ach.ach_name.replace("_", " ").capitalize(), ach.hover_text)
		print(ach.name)
		if save_data.has_unlocked(ach.name):
			# print("hit")
			# _box.shadow_btn.modulate = Color.YELLOW
			# _box.frame_btn.self_modulate = Color.YELLOW
			pass
		else:
			# print("miss")
			# _box.shadow_btn.modulate = Color.WHITE
			_box.modulate.a = 0.5
			pass
		


func add_achievement_box(icon:Texture2D, label_text:String, hover_text:String) -> AchievementBoxContainer:
	var box:AchievementBoxContainer = ACHIEVEMENT_BOX_CONTAINER.instantiate()
	grid_container.add_child(box)
	box.icon_rect.texture = icon
	box.name_label.text = label_text
	box.tooltip_text = hover_text
	return box
	
	#var box = VBoxContainer.new()
	#
	#var icon = TextureRect.new()
	#icon.texture = ach.icon
	#icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	#icon.custom_minimum_size = Vector2(64, 64)
	#icon.tooltip_text = ach.hover_text
	#
	#var label = Label.new()
	#label.text = ach.ach_name.replace("_", " ").capitalize()
	#label.tooltip_text = ach.hover_text
	#label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#
	#box.add_child(icon)
	#box.add_child(label)


func _to_main() -> void:
	SceneManager.goto("main")
