class_name Mouse
extends Sprite2D


const eraser_sprite = preload("res://assets/art/mouse/eraser.png")
const pencil_sprite = preload("res://assets/art/mouse/pencil.png")
const moving_sprite = preload("res://assets/art/mouse/moving.png")
const none_sprite = preload("res://assets/art/mouse/none.png")

var player_tile_id = 4  # Player tile ID
@export var player_start_pos := Vector2i(4, 4)
var player_current_pos:Vector2i = player_start_pos  # Track player tile position

var player_tile_atlas = Vector2i(0, 0)  # Player tile's atlas position (top-left)

signal finished

enum State {
	NONE, ERASER, PENCIL, MOVING
}
var current_state = State.NONE
var last_state = current_state
var last_erased = false

@export var game:Game
@export var tilemap: TileMapLayer


func set_state(new_state:State) -> void:
	last_state = current_state
	current_state = new_state
	match current_state:
		State.NONE:
			self.texture = none_sprite
		State.ERASER:
			self.texture = eraser_sprite
		State.PENCIL:
			self.texture = pencil_sprite
		State.MOVING:
			self.texture = moving_sprite
			
	
	
func _ready() -> void:
	set_state(State.NONE)
	player_current_pos = get_player_pos()
	print("player_current_pos = %s" % player_current_pos)
	

	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if current_state == State.ERASER:
				if game.erases_left > 0:
					if erase_tile():
						last_erased = true
						game.erases_left -= 1
						game.update_labels()
						change_state()
						# change_state()
			elif current_state == State.PENCIL:
				if draw_tile():
					last_erased = false
					change_state()
			elif current_state == State.MOVING:
				if game.moves_left > 0:
					var tile_pos = get_parent().tilemap.local_to_map(get_global_mouse_position())  # Get the tile under the mouse
					if move_player_tile(tile_pos):
						game.moves_left -= 1
						game.update_labels()
						change_state()
			else:
				pass
			
		
		
func _process(_delta) -> void:
	self.global_position = get_global_mouse_position()
	if last_erased == false:
		update_state_based_on_hover()



func update_state_based_on_hover():
	var mouse_pos = get_global_mouse_position()
	var tile_pos = tilemap.local_to_map(tilemap.to_local(mouse_pos))  # Convert world to tile coords
	var tile_id = tilemap.get_cell_source_id(tile_pos)  # Get tile ID

	# var player_pos = get_player_pos()
	var is_adjacent_to_player = is_adjacent(tile_pos, player_current_pos)

	if tile_id == 2:  # Wall tile
		set_state(State.ERASER)
	elif (tile_id == -1 or tile_id == 3) and is_adjacent_to_player:  # Empty tile adjacent to player
		set_state(State.MOVING)
	elif last_erased:  # If the last action was erasing, switch to pencil
		set_state(State.PENCIL)
		last_erased = false
	else:
		set_state(State.NONE)
		
		
		
	
func get_player_pos() -> Vector2i:
	
	# Loop through each tile in the tilemap
	for x in range(10):
		for y in range(6):
			var tile_pos = Vector2i(x, y)
			var tile_id = tilemap.get_cell_source_id(tile_pos)  # Get the tile's source ID
			# print(tile_id)
			
			# Check if the tile is a player tile (ID = 4)
			if tile_id == player_tile_id:
				return tile_pos  # Return the position of the first player tile

	return Vector2i(-1, -1)  # Return an invalid position if no player tile is found
	
	
func move_player_tile(new_tile_pos: Vector2i) -> bool:
	
	# Check if the new tile is empty
	var target_tile_id = tilemap.get_cell_source_id(new_tile_pos)
	if target_tile_id == -1 or target_tile_id == 3:  # Tile is empty or finish
		# Check if the new tile is adjacent to the player tile
		if is_adjacent(player_current_pos, new_tile_pos):
			# Erase the current player tile
			tilemap.set_cell(player_current_pos, -1)  # Erase current player position

			# Set the player tile at the new position
			tilemap.set_cell(new_tile_pos, player_tile_id, Vector2i(0,0))  # Place player tile at new position

			# Update player position
			player_current_pos = new_tile_pos
			print("Player moved to ", player_current_pos)
			
			# check if finished
			if target_tile_id == 3:
				print("finished")
				finished.emit()
				
			return true  # Move was successful
		else:
			print("Target tile is not adjacent!")
			return false  # Target tile is not adjacent, move unsuccessful
	else:
		print("Target tile is not empty!")
		return false  # Target tile is not empty, move unsuccessful
	

func is_adjacent(pos1: Vector2i, pos2: Vector2i) -> bool:
	# Check if the positions are adjacent horizontally or vertically, not diagonally
	return (abs(pos1.x - pos2.x) == 1 and pos1.y == pos2.y) or (abs(pos1.y - pos2.y) == 1 and pos1.x == pos2.x)
	
	
func erase_tile() -> bool:

	var tile_pos = tilemap.local_to_map(get_global_mouse_position())  # Convert mouse position to tile coordinates
	var tile_id = tilemap.get_cell_source_id(tile_pos)  # Get the tile ID at the position

	if tile_id != -1:  # Check if a tile exists
		if tile_id == 2:  # remove wall_tile.png
			tilemap.erase_cell(tile_pos)  # Remove the tile
			return true  # Tile was erased successfully

	return false  # No tile was erased


func draw_tile() -> bool:

	var tile_pos = tilemap.local_to_map(get_global_mouse_position())  # Convert mouse position to tile coordinates
	var tile_id = tilemap.get_cell_source_id(tile_pos)  # Get the current tile ID
	
	if tile_id == -1:  # Only draw if the position is empty
		tilemap.set_cell(tile_pos, 2, Vector2i(0, 0))  # Place tile with Source ID = 2 (wall tile)
		return true  # Tile was drawn successfully

	return false  # A tile already exists, do nothing
	
	
func change_state() -> void:
	var new_state = (current_state + 1) % State.size()
	set_state(new_state)
