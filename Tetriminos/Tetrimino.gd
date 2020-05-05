extends Position2D

signal has_transformed

const step_size = 16 # Represents the length of a mino in pixels

# Represents Tetrimino's ability to move.
#     If a single Mino is affected by any movement restriction the respective
# direction is blocked for the Tetrimino
var can_move_left = true
var can_move_right = true
var can_move_down = true
# ==============================================================================

onready var minos = self.get_children()


func _ready():
	rotation_degrees = 0


func _physics_process(delta):
	input_check()


func input_check():
	if Input.is_action_just_pressed("ui_left"):
		if !is_colliding_left():
			position.x += -1 * step_size
			emit_signal("has_transformed")
		
	if Input.is_action_just_pressed("ui_right"):
		if !is_colliding_right():
			position.x += step_size
			emit_signal("has_transformed")
		
	if Input.is_action_just_pressed("hard_drop"):
		pass
		
	if Input.is_action_just_pressed("soft_drop"):
		if !is_colliding_down():
			position.y += step_size
			emit_signal("has_transformed")
		
	if Input.is_action_just_pressed("rotate_clockwise"):
		rotate_clockwise()
		emit_signal("has_transformed")
		
	if Input.is_action_just_pressed("rotate_counter_clockwise"):
		rotate_counter_clockwise()
		emit_signal("has_transformed")


func is_colliding_left():
	for current_mino in minos:
		if current_mino.colliding_left:
			return true
	
	return false


func is_colliding_right():
	for current_mino in minos:
		if current_mino.colliding_right:
			return true
	
	return false


func is_colliding_down():
	for current_mino in minos:
		if current_mino.colliding_down:
			return true
	
	return false


func rotate_clockwise():
	if rotation_degrees == 360:
		rotation_degrees = 0
	
	rotation_degrees += 90


func rotate_counter_clockwise():
	if rotation_degrees == -360:
		rotation_degrees = 0
		
	rotation_degrees += -90
