extends Sprite

onready var ghost_tetrimino = get_parent()


func _process(delta):
	rotation_degrees = -1 * ghost_tetrimino.rotation_degrees
