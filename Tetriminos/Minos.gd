extends Sprite


func _process(delta):
	# Corrects the sprite's rotation when the parent Tetrimino is rotated
	set_rotation_degrees(-1 * get_parent().get_rotation_degrees())
