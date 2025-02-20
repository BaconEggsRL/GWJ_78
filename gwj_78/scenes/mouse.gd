class_name Mouse
extends Sprite2D


@export var default_state:State

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
	self.set_state(default_state)

func _process(_delta) -> void:
	self.global_position = get_global_mouse_position()
	
func _unhandled_input(event: InputEvent) -> void:
	# print("unhandled_unput")
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		do_state_action()

func do_state_action() -> void:
	# print("do_state_action")
	match current_state:
		State.GUN:
			# print("emit fire_gun")
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
				# Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			State.ERASER:
				self.texture = eraser_sprite
				# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			State.MOP:
				self.texture = mop_sprite
				# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			State.KEY:
				self.texture = key_sprite
				# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			State.GUN:
				self.texture = gun_sprite
				# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			State.BODY:
				self.texture = body_sprite
				# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				
