extends Sprite2D


const ERASER = preload("res://assets/art/mouse/eraser.png")
const PENCIL = preload("res://assets/art/mouse/pencil.png")


func _ready() -> void:
	self.texture = ERASER
	
func _process(_delta) -> void:
	self.global_position = get_global_mouse_position()
