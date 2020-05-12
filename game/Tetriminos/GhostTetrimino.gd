extends Position2D

var real_tetrimino = null
var real_minos = []
var ghost_mino_rays = []

onready var ghost_minos = get_children()


func _ready():
	real_tetrimino = get_parent().active_tetrimino
	real_minos = get_real_minos()
	
	ghost_mino_rays = get_ghost_mino_rays()
	update_children_transform()
	
	global_transform = real_tetrimino.global_transform
	
	# REALLY IMPORTANT
	real_tetrimino.connect("has_transformed", self, "update_transform")


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


func update_transform():
	global_transform = real_tetrimino.global_transform
	update_children_rotation()
	
	force_children_ray_updates()
	
	var temp
	var closest_collision = 1000 # Arbitrary large number
	
	for current_ray in ghost_mino_rays:
		temp = current_ray.get_collision_point().y - current_ray.global_position.y - 8
		
		if temp < closest_collision:
			closest_collision = temp
	
	global_position.y += closest_collision


func update_children_transform():
	for x in range(4):
		ghost_minos[x].transform = real_minos[x].transform

func update_children_rotation():
	for current_minos in ghost_minos:
		current_minos.rotation_degrees = -1 * rotation_degrees

func force_children_ray_updates():
	for current_ray in ghost_mino_rays:
		current_ray.force_raycast_update()
