extends Node2D

@export var main_menu_btn:Button
@export var grid_container:GridContainer



func _ready() -> void:
	main_menu_btn.pressed.connect(_to_main)
	display_achievements()
	


func display_achievements() -> void:
	var achievements = SaveData.get_all_achievements()
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
