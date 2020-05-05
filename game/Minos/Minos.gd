extends Sprite

var colliding_left = false
var colliding_right = false
var colliding_down = false

onready var tetrimino = get_parent()
onready var collision_ray = $CollisionRay


func _process(delta):
	# Corrects the sprite's rotation when the parent Tetrimino is rotated
	rotation_degrees = -1 * tetrimino.rotation_degrees


func _physics_process(delta):
	do_collision_check()


# Checks the east west and south side of Mino for area collisions
func do_collision_check():
	# ===========================================
	#               Left
	collision_ray.set_cast_to(Vector2(-16, 0)) # Set the collision test
	collision_ray.force_raycast_update()       # Force a collision check
	if collision_ray.is_colliding():
		colliding_left = true
	else:
		colliding_left = false
	# ===========================================
	
	# ===========================================
	#               Right
	collision_ray.set_cast_to(Vector2(16, 0))
	collision_ray.force_raycast_update()
	if collision_ray.is_colliding():
		colliding_right = true
	else:
		colliding_right = false
	# ===========================================
	
	# ===========================================
	#               Down
	collision_ray.set_cast_to(Vector2(0, 16))
	collision_ray.force_raycast_update()
	if collision_ray.is_colliding():
		colliding_down = true
	else:
		colliding_down = false
