class_name VolumeSlider
extends HSlider


@export var target_bus_name:String


func _ready():
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	
	value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(target_bus_name)))
	value_changed.connect(_on_slider_value_changed)

func _on_slider_value_changed(new_linear_value: float):
	var db_value = linear_to_db(new_linear_value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(target_bus_name), db_value)
