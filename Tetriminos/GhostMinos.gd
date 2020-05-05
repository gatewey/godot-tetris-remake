extends Sprite

onready var ghost_tetrimino = get_parent()


func _physics_process(_delta):
	# Corrects the sprite's rotation when the parent Tetrimino is rotated
	rotation_degrees = -1 * ghost_tetrimino.rotation_degrees
