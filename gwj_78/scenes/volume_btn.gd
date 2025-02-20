class_name VolumeButton
extends Button


@export var default_state:VolumeState


enum VolumeState {
	THREE, TWO, ONE, NONE,
}
var current_state:VolumeState
var last_state:VolumeState


const SPEAKER_MUTED = preload("res://assets/art/UI/speaker_muted.png")
const SPEAKER_1 = preload("res://assets/art/UI/speaker_1.png")
const SPEAKER_2 = preload("res://assets/art/UI/speaker_2.png")
const SPEAKER_3 = preload("res://assets/art/UI/speaker_3.png")

var master_bus_index = AudioServer.get_bus_index("Master")  # Change to your target audio bus


func _ready() -> void:
	self.pressed.connect(_on_volume_pressed)
	# Load and apply saved volume
	self.set_state(get_stored_volume_state(), false)
	

func _on_volume_pressed() -> void:
	var new_state = (self.current_state + 1) % self.VolumeState.size()
	self.set_state(new_state, true)
	




func set_state(new_state:VolumeState, should_tween:bool) -> void:
	if not current_state or new_state != current_state:
		last_state = current_state
		current_state = new_state
		print("updated volume state to: %s" % current_state)
		
		var new_volume_db := 0.0
		
		match current_state:
			VolumeState.NONE:
				self.icon = SPEAKER_MUTED
				new_volume_db = -80.0
				
			VolumeState.ONE:
				self.icon = SPEAKER_1
				new_volume_db = -12.0
				
			VolumeState.TWO:
				self.icon = SPEAKER_2
				new_volume_db = -6.0
				
			VolumeState.THREE:
				self.icon = SPEAKER_3
				new_volume_db = 0.0
		
		if should_tween:
			tween_audio_bus_volume("Master", new_volume_db, 0.2)  # Fades volume to -10 dB over X seconds
		else:
			AudioServer.set_bus_volume_db(master_bus_index, new_volume_db)
		
		# update saved volume
		store_volume_state(current_state)
		


func tween_audio_bus_volume(bus_name: String, target_db: float, duration: float = 1.0):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var tween = create_tween()
	var start_db = AudioServer.get_bus_volume_db(bus_index)
	
	tween.tween_method(
		func(value): AudioServer.set_bus_volume_db(bus_index, value),
		start_db, target_db, duration
	)
	
	
func store_volume_state(_state:VolumeState):
	var config = ConfigFile.new()
	config.set_value("audio", "volume_state", _state)
	config.save("user://volume_state.cfg")


func get_stored_volume_state():
	var config = ConfigFile.new()
	if config.load("user://volume_state.cfg") == OK:
		return config.get_value("audio", "volume_state", VolumeState.THREE)
	return VolumeState.THREE
