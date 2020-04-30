extends Position2D

const step_size = 16 # Represents the length of a mino in pixels

# Represents Tetrimino's ability to move.
#     If a single Mino is affected by any movement restriction the respective
# direction is blocked for the Tetrimino
var can_move_left = true
var can_move_right = true
var can_move_down = true
# ==============================================================================

var mino_boxes = []

onready var mino_root_nodes = self.get_children()


func _ready():
	rotation_degrees = 0
	get_mino_box_referrence()
	translation_ability_signals()  # Sets up signals from child Minos


func _process(delta):
	input_check()


func get_mino_box_referrence():
	for referrence in mino_root_nodes:
		mino_boxes.append(referrence.get_node("BoundingBox"))


func translation_ability_signals():
	for current_mino in mino_boxes:
		current_mino.connect("area_entered", self, "_on_wall_collide")
		current_mino.connect("area_exited", self, "_on_wall_move_away")


func _on_wall_collide(area):
	if area.name == "LeftArea":
		can_move_left = false
	
	if area.name == "RightArea":
		can_move_right = false
	
	if area.name == "BottomArea":
		can_move_down = false


func _on_wall_move_away(area):
	if area.name == "LeftArea":
		can_move_left = true
	
	if area.name == "RightArea":
		can_move_right = true
	
	if area.name == "BottomArea":
		can_move_down = true


func input_check():
	if Input.is_action_just_pressed("ui_left"):
		move_left()
		
	if Input.is_action_just_pressed("ui_right"):
		move_right()
		
	if Input.is_action_just_pressed("hard_drop"):
		pass
		
	if Input.is_action_just_pressed("soft_drop"):
		soft_drop()
		
	if Input.is_action_just_pressed("rotate_clockwise"):
		rotate_clockwise()
		
	if Input.is_action_just_pressed("rotate_counter_clockwise"):
		rotate_counter_clockwise()


func move_left():
	if can_move_left:
		position.x += -1 * step_size


func move_right():
	if can_move_right:
		position.x += step_size


func soft_drop():
	if can_move_down:
		position.y += step_size


func rotate_clockwise():
	if rotation_degrees == 360:
		rotation_degrees = 0
	
	rotation_degrees += 90


func rotate_counter_clockwise():
	if rotation_degrees == -360:
		rotation_degrees = 0
		
	rotation_degrees += -90
