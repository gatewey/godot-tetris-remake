extends Position2D

onready var real_tetrimino = get_parent()


func _process(delta):
	rotation_degrees = real_tetrimino.rotation_degrees
