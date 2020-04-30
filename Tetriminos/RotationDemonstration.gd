extends Position2D

export (int)var rotation_division = 10
export (bool)var can_rotate = false
export var speed_multiplier = 10


func _ready():
	rotation_degrees = 0


func _process(delta):
	var rotation_step = 360 / rotation_division
	
	if rotation_degrees == 360:
		rotation_degrees = 0
	
	if Input.is_action_just_pressed("ui_right"):
		can_rotate = true

	if Input.is_action_just_released("ui_right"):
		can_rotate = false
		
	do_rotation(rotation_step, delta)
	
	
func do_rotation(rotation_step, delta):
	if can_rotate:
		rotation_degrees += rotation_step * delta * speed_multiplier
