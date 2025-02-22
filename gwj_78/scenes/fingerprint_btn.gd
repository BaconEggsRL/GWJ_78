class_name MovingFingerprint
extends Button

@onready var footstep_timer: Timer = $footstep_timer
@onready var fingerprint_btn: Button = $"."
@onready var footstep_container: Control = $footstep_container


@onready var fingerprint_visible:bool = false

const FOOTPRINT_RECT = preload("res://footprint_rect.tscn")
var walk_angle:float = 0.0
var margin: float = 136.0 / 2.0



func _ready() -> void:
	fingerprint_btn.pressed.connect(_on_fingerprint_btn_pressed)
	footstep_timer.timeout.connect(_on_footstep_timer_timeout)
	self._update_shader_param(0.0, self, "alpha_control")
	self.global_position = Vector2(randf_range(-margin, 1280-margin), randf_range(-margin, 720-margin))
	randomize_fingerprint()
	


func _update_shader_param(value, node: Node, shader_property: String):
	if is_instance_valid(node) and node.material:
		node.material.set_shader_parameter(shader_property, value)
		
func _create_shader_tween(node: Node, shader_property: String, value_start: float, value_end: float, duration: float) -> Tween:
	var tween = get_tree().create_tween()
	tween.tween_method(
		func(value): _update_shader_param(value, node, shader_property),
		value_start,
		value_end,
		duration
	);
	return tween
	

func fade_fingerprint(make_visible:bool, fade_time:float=0.5, max_alpha:float=0.5) -> Tween:
	if fingerprint_btn.material and fingerprint_btn.material is ShaderMaterial:
		var current_alpha = fingerprint_btn.material.get_shader_parameter("alpha_control")
		var start_val: float = current_alpha as float if current_alpha != null else (0.0 if make_visible else max_alpha)
		var end_val: float = max_alpha if make_visible else 0.0
		
		fingerprint_visible = !fingerprint_visible
		return _create_shader_tween(fingerprint_btn, "alpha_control", start_val, end_val, fade_time)
	else:
		return null


func randomize_fingerprint(instant:bool = false) -> void:
	# Generate a random rotation
	var rot = randf_range(-PI, PI)
	
	var min_distance = 200.0  # Minimum movement distance
	var max_distance = 400.0 # Maximum movement distance
	var walk_speed = 150.0
	
	# Generate a random direction
	walk_angle = randf_range(0, TAU)  # TAU = 2 * PI (full circle)
	var distance = randf_range(min_distance, max_distance)  # Ensure distance is at least min_distance

	# Calculate new position within the valid range
	var offset = Vector2(cos(walk_angle), sin(walk_angle)) * distance
	var target_pos = fingerprint_btn.position + offset

	# Ensure the position stays within screen bounds
	target_pos.x = clamp(target_pos.x, margin, 1280 - margin)
	target_pos.y = clamp(target_pos.y, margin, 720 - margin)

	# Recalculate actual moved distance (after clamping)
	var actual_distance = (fingerprint_btn.position - target_pos).length()
	
	# If the clamped position made the movement too small, re-roll the position
	if actual_distance < min_distance:
		return randomize_fingerprint()

	# Calculate movement duration
	var walk_time = actual_distance / walk_speed

	# Apply rotation
	fingerprint_btn.rotation = rot
	
	# Tween movement
	if instant == false:
		
		footstep_timer.start()
		
		var pos_tween: Tween = create_tween()
		pos_tween.tween_property(fingerprint_btn, "position", target_pos, walk_time)
		# fade in btn after moved
		pos_tween.finished.connect(func():
			# print("reset")
			# stop footsteps
			footstep_timer.stop()
			# fade in texture
			fade_fingerprint(true)
			# reset mouse filter to clickable
			fingerprint_btn.mouse_filter = Control.MOUSE_FILTER_STOP
		)

	else:
		# print("reset")
		fingerprint_btn.position = target_pos
		fade_fingerprint(true)
		fingerprint_btn.mouse_filter = Control.MOUSE_FILTER_STOP
		
		
		
func _on_fingerprint_btn_pressed() -> void:
	# print("pressed")
	if fingerprint_visible:
		fingerprint_btn.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		# fade out tween
		var tween:Tween = fade_fingerprint(false)
		if tween:
			tween.finished.connect(func():
				# print("move")
				# move position randomly
				randomize_fingerprint()
			)
	else:
		fade_fingerprint(true)


func _on_footstep_timer_timeout() -> void:
	# print("step")
	var footprint = FOOTPRINT_RECT.instantiate()
	var offset:float = 20.0
	var offset_vector = Vector2(randf_range(-offset, offset), randf_range(-offset, offset))
	footprint.global_position = fingerprint_btn.global_position + offset_vector
	footprint.rotation = walk_angle + PI/2
	footstep_container.add_child(footprint)
