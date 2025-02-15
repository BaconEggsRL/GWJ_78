extends Sprite2D


const eraser_sprite = preload("res://assets/art/mouse/eraser.png")
const pencil_sprite = preload("res://assets/art/mouse/pencil.png")


enum State {
	ERASER, PENCIL
}
var current_state = State.ERASER


func set_state(new_state:State) -> void:
	self.current_state = new_state
	match current_state:
		State.ERASER:
			self.texture = eraser_sprite
		State.PENCIL:
			self.texture = pencil_sprite
			
	
	
func _ready() -> void:
	set_state(State.ERASER)
	


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var new_state = (current_state + 1) % State.size()
		set_state(new_state)
		
		
func _process(_delta) -> void:
	self.global_position = get_global_mouse_position()
