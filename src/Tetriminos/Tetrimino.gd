extends Position2D

signal has_transformed
signal start_lockdown
signal force_lockdown

enum {
	SPAWN,
	LEFT,
	RIGHT,
	DOUBLE
}

const step_size = 16 # Represents the length of a mino in pixels

var current_rotation_state = null
var has_collided_down = false

onready var type = get_parent().active_tetrimino_type
onready var minos = self.get_children()
onready var playfield = get_parent().playfield


func _ready():
	rotation_degrees = 0
	current_rotation_state = SPAWN
	has_collided_down = false


func _physics_process(_delta):
	input_check()
	lock_check()


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
		do_hard_drop()
		emit_signal("has_transformed")
		emit_signal("force_lockdown")
		
	if Input.is_action_just_pressed("soft_drop"):
		if !is_colliding_down():
			if has_collided_down:
				emit_signal("start_lockdown")
			
			position.y += step_size
			emit_signal("has_transformed")
		
	if Input.is_action_just_pressed("rotate_clockwise"):
		rotate("clockwise")
		emit_signal("has_transformed")
		
	if Input.is_action_just_pressed("rotate_counter_clockwise"):
		rotate("counter_clockwise")
		emit_signal("has_transformed")


func lock_check():
	if is_colliding_down() and !has_collided_down:
		has_collided_down = true
		emit_signal("start_lockdown")


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


func do_hard_drop():
	var ghost_tetrimino = get_parent().ghost_tetrimino
	
	global_position = ghost_tetrimino.global_position


func rotate(direction): # If type is o then dont run tests
	match direction:
		"clockwise":
			var next_rotation_state = get_next_rotation_state(direction)
			var test_rotation = rotation_degrees + 90
			
			if rotation_degrees == 360:
				test_rotation = 0 + 90
			
			
			if playfield.is_valid_rotation(current_rotation_state, next_rotation_state, test_rotation):
				global_position += (playfield.safe_translation * step_size)
				
				rotation_degrees = test_rotation
				
				current_rotation_state = next_rotation_state
		
		"counter_clockwise":
			var next_rotation_state = get_next_rotation_state(direction)
			var test_rotation = rotation_degrees - 90
			
			if rotation_degrees == -360:
				test_rotation = 0 - 90
			
			if playfield.is_valid_rotation(current_rotation_state, next_rotation_state, test_rotation):
				global_position += (playfield.safe_translation * step_size)
				
				rotation_degrees = test_rotation
				
				current_rotation_state = next_rotation_state


func get_next_rotation_state(rotation):
	match current_rotation_state:
		SPAWN:
			match rotation:
				"clockwise":
					return RIGHT
				"counter_clockwise":
					return LEFT
		LEFT:
			match rotation:
				"clockwise":
					return SPAWN
				"counter_clockwise":
					return DOUBLE
		RIGHT:
			match rotation:
				"clockwise":
					return DOUBLE
				"counter_clockwise":
					return SPAWN
		DOUBLE:
			match rotation:
				"clockwise":
					return LEFT
				"counter_clockwise":
					return RIGHT
