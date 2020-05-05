extends Position2D

var real_minos = []
var real_tetrimino = null
var ghost_mino_rays = []
var step_size = 16

onready var ghost_minos = get_children()


func _ready():
	real_tetrimino = get_parent().active_tetrimino
	real_minos = get_real_minos()
	
	ghost_mino_rays = get_ghost_mino_rays()
	initialize_ghost_minos()
	
	global_position = real_tetrimino.global_position
	
	# REALLY IMPORTANT
	real_tetrimino.connect("has_transformed", self, "update_transform")


func _physics_process(_delta):
	rotation_degrees = real_tetrimino.rotation_degrees


# Was having issues with the way I was doing this. Just resized manually
func get_real_minos():
	var temp = []
	
	for x in range(4):
		temp.append(real_tetrimino.get_child(x))
	
	return temp


func get_ghost_mino_rays():
	var temp = []
	
	for current_mino in ghost_minos:
		temp.append(current_mino.get_child(0))
	
	return temp


func initialize_ghost_minos():
	for x in range(4):
		ghost_minos[x].position = real_minos[x].position


func update_transform():
	global_position = real_tetrimino.global_position
	
	var temp
	var closest_collision = 1000 # Arbitrary large number
	
	for current_ray in ghost_mino_rays:
		temp = current_ray.get_collision_point().y - current_ray.global_position.y - 8
		
		if temp < closest_collision:
			closest_collision = temp
	
	global_position.y += closest_collision
