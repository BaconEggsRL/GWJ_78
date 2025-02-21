class_name VolumeSlider
extends HSlider


@export var target_bus_name:String

# save data
var save_data:SaveData


func _ready():
	# load save data
	save_data = SaveData.load_or_create()
	
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	
	# load
	# value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(target_bus_name)))
	value_changed.connect(_on_slider_value_changed)
	value = save_data.bus_volume.get(target_bus_name, 1.0)
	
	# Ensure the bus volume is set on load
	var db_value = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(target_bus_name), db_value)



func _on_slider_value_changed(new_linear_value: float):
	var db_value = linear_to_db(new_linear_value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(target_bus_name), db_value)
	
	# save
	save_data.bus_volume[target_bus_name] = new_linear_value
	save_data.save()
