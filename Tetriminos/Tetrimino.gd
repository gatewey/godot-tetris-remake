extends Position2D

const step_size = 16 # Represents the length of a mino in pixels

# Represents Tetrimino's ability to move.
#     If a single Mino is affected by any movement restriction the respective
# direction is blocked for the Tetrimino
var can_move_left = true
var can_move_right = true
var can_move_down = true
# ==============================================================================

onready var mino_root_nodes = self.get_children()


func _ready():
	rotation_degrees = 0


func _process(delta):
	pass


func _physics_process(delta):
	#update_transform_ability()
	input_check()


#func update_transform_ability():
#	can_move_left = !is_colliding_left()
#	can_move_right = !is_colliding_right()
#	can_move_down = !is_colliding_down()





func input_check():
	if Input.is_action_just_pressed("ui_left"):
		if !is_colliding_left():
			position.x += -1 * step_size
		
	if Input.is_action_just_pressed("ui_right"):
		if !is_colliding_right():
			position.x += step_size
		
	if Input.is_action_just_pressed("hard_drop"):
		pass
		
	if Input.is_action_just_pressed("soft_drop"):
		if !is_colliding_down():
			position.y += step_size
		
	if Input.is_action_just_pressed("rotate_clockwise"):
		rotate_clockwise()
		
	if Input.is_action_just_pressed("rotate_counter_clockwise"):
		rotate_counter_clockwise()


func is_colliding_left():
	for current_mino in mino_root_nodes:
		if current_mino.colliding_left:
			return true
	
	return false


func is_colliding_right():
	for current_mino in mino_root_nodes:
		if current_mino.colliding_right:
			return true
	
	return false


func is_colliding_down():
	for current_mino in mino_root_nodes:
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
