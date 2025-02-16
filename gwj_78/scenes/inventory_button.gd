class_name InventoryButton
extends Button

var base_modulate = 1.0
var hover_modulate = 0.5

@onready var label: Label = $Label

@export var shader_max_amplitude = 2.0

var hover_tween:Tween
var hover_tween_duration:float = 0.25

signal inventory_item_pressed



func _ready() -> void:
	label.text = ""
	self.self_modulate.a = base_modulate
	
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	self.pressed.connect(_on_pressed)
	
	if material is ShaderMaterial:
		material.set_shader_parameter("amplitude", 0.0)
		material.set_shader_parameter("enabled", true)
	


	
	
func enable_hover_shader():
	if material is ShaderMaterial:
		# material.set_shader_parameter("amplitude", shader_max_amplitude)
		# material.set_shader_parameter("enabled", true)
		if hover_tween:
			hover_tween.kill()
		hover_tween = create_tween()
		hover_tween.tween_property(material, "shader_parameter/amplitude", shader_max_amplitude, hover_tween_duration)
		material.set_shader_parameter("start_time", Time.get_ticks_msec() / 1000.0) # Convert to seconds
		material.set_shader_parameter("enabled", true)
	

func disable_hover_shader():
	if material is ShaderMaterial:
		# material.set_shader_parameter("amplitude", 0.0)
		# material.set_shader_parameter("enabled", false)
		if hover_tween:
			hover_tween.kill()
		hover_tween = create_tween()
		hover_tween.tween_property(material, "shader_parameter/amplitude", 0.0, hover_tween_duration)
		hover_tween.finished.connect(func(): 
			material.set_shader_parameter("enabled", false)
		)
	

func _on_pressed() -> void:
	inventory_item_pressed.emit(self.name)


func _on_mouse_entered() -> void:
	# self.self_modulate.a = hover_modulate
	# print("hi")
	enable_hover_shader()
	pass

func _on_mouse_exited() -> void:
	# self.self_modulate.a = base_modulate
	# print("bye")
	disable_hover_shader()
	pass
