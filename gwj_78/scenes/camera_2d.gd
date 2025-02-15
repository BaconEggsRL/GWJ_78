extends Camera2D

@export var player: Node2D
@export var fixed_x_position: float = 0.0
@export var y_offset: float = 720.0 / 4.0


func _process(_delta):
	if player:
		global_position.x = fixed_x_position
		global_position.y = player.global_position.y - y_offset
