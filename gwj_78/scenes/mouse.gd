class_name Mouse
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
		if event.button_index == MOUSE_BUTTON_LEFT:
			if current_state == State.ERASER:
				erase_tile()
			elif current_state == State.PENCIL:
				draw_tile()
			else:
				pass
			change_state()
		
		
func _process(_delta) -> void:
	self.global_position = get_global_mouse_position()


func erase_tile() -> bool:

	if not get_parent().tilemap:
		return false  # Safety check

	var tilemap = get_parent().tilemap  # Get the wall tile layer
	var tile_pos = tilemap.local_to_map(get_global_mouse_position())  # Convert mouse position to tile coordinates
	var tile_id = tilemap.get_cell_source_id(tile_pos)  # Get the tile ID at the position

	if tile_id != -1:  # Check if a tile exists
		if tile_id == 2:  # remove wall_tile.png
			tilemap.erase_cell(tile_pos)  # Remove the tile
			return true  # Tile was erased successfully

	return false  # No tile was erased


func draw_tile() -> bool:
	print("draw")
	if not get_parent().tilemap:
		return false  # Safety check

	var tilemap = get_parent().tilemap  # Get the main tile layer
	var tile_pos = tilemap.local_to_map(get_global_mouse_position())  # Convert mouse position to tile coordinates
	var existing_tile_id = tilemap.get_cell_source_id(tile_pos)  # Get the current tile ID
	
	print("existing_tile_id = %s" % existing_tile_id)
	if existing_tile_id == -1:  # Only draw if the position is empty
		tilemap.set_cell(tile_pos, 2, Vector2i(0, 0))  # Place tile with Source ID = 2 (wall tile)
		print("hello")
		return true  # Tile was drawn successfully
	#if existing_tile_id != -1:  # Only draw if the position is empty
		#tilemap.set_cell(tile_pos, -1)  # Place tile with ID = 2
		#return true  # Tile was drawn successfully

	return false  # A tile already exists, do nothing
	
	
func change_state() -> void:
	var new_state = (current_state + 1) % State.size()
	set_state(new_state)
