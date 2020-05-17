extends Area2D

class RotationTests:
	enum {
		SPAWN,
		LEFT,
		RIGHT,
		DOUBLE
	}

	var current_tests = []
	var rotation_state = ""
	
	# This data is taken from the official guideline.
	# All Y values are * -1 due to the nature of Godot's coordinate system
	var all_but_i_data = {"0toR": [[0, 0], [-1, 0], [-1, -1], [0, 2],  [-1, 2]],
						  "Rto0": [[0, 0], [1, 0],  [1, 1],   [0, -2], [1, -2]],
						  "Rto2": [[0, 0], [1, 0],  [1, 1],   [0, -2], [1, -2]],
						  "2toR": [[0, 0], [-1, 0], [-1, -1], [0, 2],  [-1, 2]],
						  "2toL": [[0, 0], [1, 0],  [1, -1],  [0, 2],  [1, 2]],
						  "Lto2": [[0, 0], [-1, 0], [-1, 1],  [0, -2], [-1, -2]],
						  "Lto0": [[0, 0], [-1, 0], [-1, 1],  [0, -2], [-1, -2]],
						  "0toL": [[0, 0], [1, 0],  [1, -1],  [0, 2],  [1, 2]]
						 }
	
	var i_data = {"0toR": [[0, 0], [-2, 0], [1, 0],  [-2, 1],  [1, -2]],
				  "Rto0": [[0, 0], [2, 0],  [-1, 0], [2, -1],  [-1, 2]],
				  "Rto2": [[0, 0], [-1, 0], [2, 0],  [-1, -2], [2, 1]],
				  "2toR": [[0, 0], [1, 0],  [-2, 0], [1, 2],   [-2, -1]],
				  "2toL": [[0, 0], [2, 0],  [-1, 0], [2, -1],  [-1, 2]],
				  "Lto2": [[0, 0], [-2, 0], [1, 0],  [-2, 1],  [1, -2]],
				  "Lto0": [[0, 0], [1, 0],  [-2, 0], [1, 2],   [-2, -1]],
				  "0toL": [[0, 0], [-1, 0], [2, 0],  [-1, -2], [2, 1]]
				 }
	
	func construct(tetrimino_type: String, current_state, test_state):
		rotation_state = translate_state(current_state, test_state)
		read_current_tests_from_table(tetrimino_type, rotation_state)
	
	func translate_state(current_state, test_state):
		var temp = "to"
		
		match current_state:
			SPAWN:
				temp = "0" + temp
			LEFT:
				temp = "L" + temp
			RIGHT:
				temp = "R" + temp
			DOUBLE:
				temp = "2" + temp
		
		match test_state:
			SPAWN:
				temp += "0"
			LEFT:
				temp += "L"
			RIGHT:
				temp += "R"
			DOUBLE:
				temp += "2"
		
		return temp
	
	func read_current_tests_from_table(tetrimino_type, rotation_case):
		if tetrimino_type == "i":
			current_tests = i_data.get(rotation_case)
		else:
			current_tests = all_but_i_data.get(rotation_case)
	
	func get_test(test_number):
		return Vector2(current_tests[test_number][0], current_tests[test_number][1])
	
	func get_test_x(test_number):
		return get_test(test_number).x
	
	func get_test_y(test_number):
		return get_test(test_number).y


# 2D-Array representing the playfield. Dimensions: 10X23
# Because of how I put the array together, the axis and array indexes are inversely related
#
# Position (x,y) == state_array[y][x]
# Global position of state_array[y = 0][x = 0] is (x = 8, y = -40)
#
# " " is an empty cell
# "X" is a mino inside the active tetrimino
# "o" is a locked mino
var state_array =  [[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "], # [y] = 0, (y) = -40
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "], # [y] = 3, (y) = 8 first visible row
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "], 
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "], # [y] = 8, (y) = 88
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "], 
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "], # [y] = 13, (y) = 168
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "], 
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "], # [y] = 18, (y) = 248
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "], 
					[" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
					[" ", "o", " ", " ", " ", " ", " ", " ", " ", " "], 
					["o", "o", "o", " ", " ", " ", " ", " ", " ", " "]] # [y] = 22, (y) = 312

var columns = 10
var rows = 23

var safe_translation = Vector2(0, 0)

var active_tetrimino = null
var active_tetrimino_type = ""
var children_minos = null
var rotation_tester_tetrimino = null
var rotation_tester_minos = null
var mino_array_positions = [Vector2(0, 0), Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)]
var step_size = 16

onready var tests = RotationTests.new()

func _ready():
	get_parent().connect("new_spawn", self, "initialize_active_tetrimino_data")


func initialize_active_tetrimino_data():
	self.active_tetrimino = get_parent().active_tetrimino
	active_tetrimino_type = active_tetrimino.type
	children_minos = active_tetrimino.get_children()
	
	rotation_tester_tetrimino = get_parent().rotation_tester_tetrimino
	rotation_tester_minos = rotation_tester_tetrimino.get_children()
	
	update_active_tetrimino_data()
	
	active_tetrimino.connect("has_transformed", self, "update_active_tetrimino_data")


func update_active_tetrimino_data():
	safe_translation = Vector2(0, 0)
	
	# Wipe the previous active tetrimino
	for current_position in mino_array_positions:
		state_array[current_position.y][current_position.x] = " " # Read above state_array
	
	# Get and save the new positions
	mino_array_positions = []
	
	for current_mino in children_minos:
		var array_position = convert_to_array_index(current_mino.global_position)
		
		mino_array_positions.append(array_position)
	
	# Draw the new active tetrimino
	for current_position in mino_array_positions:
		state_array[current_position.y][current_position.x] = "X"


func convert_to_array_index(outside_position):
	# First addition is the center offset, division is the step size, second addition is index adjust
	
	var temp = Vector2(0, 0)
	
	temp.x = ((outside_position.x + 8) / 16) - 1
	temp.y = ((outside_position.y + 8) / 16) + 2
	
	return temp


func get_test_mino_positions(test_rotation):
	var temp = []
	
	rotation_tester_tetrimino.global_position = active_tetrimino.global_position
	
	for x in range(4):
		rotation_tester_minos[x].position = children_minos[x].position
	
	rotation_tester_tetrimino.rotation_degrees = test_rotation
	
	for current_mino in rotation_tester_minos:
		temp.append(convert_to_array_index(current_mino.global_position))
	
	return temp


func is_valid_rotation(current_state, test_state, test_rotation: int):
	tests.construct(active_tetrimino_type, current_state, test_state)
	
	var rotated_mino_array_positions = get_test_mino_positions(test_rotation)
	
	for test_number in range(5):
		var current_test = tests.get_test(test_number)
		
		if is_valid_test(current_test, rotated_mino_array_positions):
			safe_translation = current_test
			return true
	
	return false


func is_valid_test(test, rotated_mino_array_positions):
	for current_mino_position in rotated_mino_array_positions:
		var test_position = current_mino_position + test
		
		if !is_valid_position(test_position):
			return false
	
	return true


func is_valid_position(test_position):
	# The first two comparisions make sure the test position is within the array bounds
	# Having these two first makes sure it is safe to check array
	if test_position.x > columns - 1 or test_position.x < 0:
		return false
	elif test_position.y > rows - 1 or test_position.y < 0:
		return false
	# Checks if there is a locked mino in the position
	elif state_array[test_position.y][test_position.x] == "o":
		return false
	else:
		return true


func to_string():
	var temp = ""
	
	for y_index in range(23):
		for x_index in range(10):
			temp += state_array[y_index][x_index]
		
		temp += "\n"
	
	return temp
