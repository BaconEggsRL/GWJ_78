class_name SoapParticles
extends GPUParticles2D

@export var bounding_box:Button
# @onready var enabled:bool = false


func _ready() -> void:
	self.emitting = false
	#bounding_box.mouse_entered.connect(_on_mouse_entered)
	#bounding_box.mouse_exited.connect(_on_mouse_exited)
	
	
func _process(_delta) -> void:
	self.global_position = get_global_mouse_position()


#func _on_mouse_entered() -> void:
	#if enabled:
		#self.emitting = true
#
#
#func _on_mouse_exited() -> void:
	#self.emitting = false
