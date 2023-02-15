extends Position2D

var active_tetrimino = null
var active_minos = []
var children_minos_rays = []
var minos = []

onready var children_minos = get_children()


func _ready():
	active_tetrimino = get_parent().active_tetrimino
	active_minos = get_active_minos()
	
	children_minos_rays = get_children_minos_rays()
	set_children_color()
	update_children_transform()
	
	global_transform = active_tetrimino.global_transform


func _physics_process(_delta):
	update_transform()

# Was having issues with the way I was doing this. Just resized manually
func get_active_minos():
	var temp = []
	
	for x in range(4):
		temp.append(active_tetrimino.get_child(x))
	
	return temp

func get_children_minos_rays():
	var temp = []
	
	for current_mino in children_minos:
		temp.append(current_mino.get_child(0))
	
	return temp

func set_children_color():
	for current_mino in children_minos:
		current_mino.set_mino_color(active_tetrimino.type)

func update_transform():
	global_transform = active_tetrimino.global_transform
	update_children_rotation()
	
	force_children_ray_updates()
	
	var temp
	var closest_collision = 1000 # Arbitrary large number
	
	for current_ray in children_minos_rays:
		temp = current_ray.get_collision_point().y - current_ray.global_position.y - 8
		
		if temp < closest_collision:
			closest_collision = temp
	
	global_position.y += closest_collision

func update_children_transform():
	for x in range(4):
		children_minos[x].transform = active_minos[x].transform

func update_children_rotation():
	for current_minos in children_minos:
		current_minos.rotation_degrees = -1 * rotation_degrees

func force_children_ray_updates():
	for current_ray in children_minos_rays:
		current_ray.force_raycast_update()
