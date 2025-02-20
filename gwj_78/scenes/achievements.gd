extends Node2D

@export var main_menu_btn:Button
@export var grid_container:GridContainer

@export var fireworks:ColorRect

# save data
var save_data:SaveData



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
		var hbox = HBoxContainer.new()
		
		var icon = TextureRect.new()
		icon.texture = ach.icon
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(64, 64)
		icon.tooltip_text = ach.hover_text
		
		var label = Label.new()
		label.text = ach.ach_name.replace("_", " ").capitalize()
		label.tooltip_text = ach.hover_text
		
		hbox.add_child(icon)
		hbox.add_child(label)
		grid_container.add_child(hbox)
		
			
func _to_main() -> void:
	SceneManager.goto("main")
