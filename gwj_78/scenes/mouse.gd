class_name Mouse
extends Sprite2D


const eraser_sprite = preload("res://assets/art/mouse/eraser.png")
const pencil_sprite = preload("res://assets/art/mouse/pencil.png")
const moving_sprite = preload("res://assets/art/mouse/moving.png")

const none_sprite = preload("res://assets/art/mouse/none.png")
const mop_sprite = preload("res://assets/art/inventory_objects/mop.png")
const key_sprite = preload("res://assets/art/inventory_objects/key.png")
const gun_sprite = preload("res://assets/art/inventory_objects/gun.png")
const body_sprite = preload("res://assets/art/inventory_objects/body.png")



enum State {
	NONE, ERASER, MOP, KEY, GUN, BODY
}
var current_state:State
var last_state:State

signal fire_gun


func _ready() -> void:
	self.set_state(State.NONE)

func _process(_delta) -> void:
	self.global_position = get_global_mouse_position()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		do_state_action()

func do_state_action() -> void:
	match current_state:
		State.GUN:
			fire_gun.emit(self.global_position)
	

func get_state_from_string(item:String) -> State:
	match item:
		"none":
			return State.NONE
		"mop":
			return State.MOP
		"storage_closet_key":
			return State.KEY
		"gun":
			return State.GUN
		"body":
			return State.BODY
		
		_:
			return State.NONE
	
	
func set_state(new_state:State) -> void:
	if not current_state or new_state != current_state:
		last_state = current_state
		current_state = new_state
		print("updated mouse state to: %s" % current_state)
		match current_state:
			State.NONE:
				self.texture = none_sprite
			State.ERASER:
				self.texture = eraser_sprite
			State.MOP:
				self.texture = mop_sprite
			State.KEY:
				self.texture = key_sprite
			State.GUN:
				self.texture = gun_sprite
			State.BODY:
				self.texture = body_sprite
				
