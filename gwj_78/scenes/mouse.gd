class_name Mouse
extends Sprite2D


const eraser_sprite = preload("res://assets/art/mouse/eraser.png")
const pencil_sprite = preload("res://assets/art/mouse/pencil.png")
const moving_sprite = preload("res://assets/art/mouse/moving.png")
const none_sprite = preload("res://assets/art/mouse/none.png")


enum State {
	NONE, ERASER, PENCIL, MOVING
}
var current_state = State.NONE


func _process(_delta) -> void:
	self.global_position = get_global_mouse_position()
