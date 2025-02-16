extends Button

var base_modulate = 1.0
var hover_modulate = 0.5

@onready var label: Label = $Label


func _ready() -> void:
	label.text = ""
	self.self_modulate.a = base_modulate
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
	
func _on_mouse_entered() -> void:
	self.self_modulate.a = hover_modulate
	pass

func _on_mouse_exited() -> void:
	self.self_modulate.a = base_modulate
	pass
