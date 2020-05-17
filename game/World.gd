extends Node2D

signal new_spawn

enum {
	I,
	J,
	L,
	O,
	S,
	T,
	Z
}

var current_spawn_point = null
var active_tetrimino_type = ""
var active_tetrimino = null
var active_minos = null
var ghost_tetrimino = null
var rotation_tester_tetrimino = null

var rng = null
var tetrimino_bag = []
var current_bag_index = 0

onready var row_y =    {312: $LockedMinos/Row1,
						296: $LockedMinos/Row2,
						280: $LockedMinos/Row3,
						264: $LockedMinos/Row4,
						248: $LockedMinos/Row5,
						232: $LockedMinos/Row6,
						216: $LockedMinos/Row7,
						200: $LockedMinos/Row8,
						184: $LockedMinos/Row9,
						168: $LockedMinos/Row10,
						152: $LockedMinos/Row11,
						136: $LockedMinos/Row12,
						120: $LockedMinos/Row13,
						104: $LockedMinos/Row14,
						88:  $LockedMinos/Row15,
						72:  $LockedMinos/Row16,
						56:  $LockedMinos/Row17,
						40:  $LockedMinos/Row18,
						24:  $LockedMinos/Row19,
						8:   $LockedMinos/Row20,
					   -8:   $LockedMinos/Row21,
					   -24:  $LockedMinos/Row22}

onready var preloaded_i_tetrimino = preload("res://Tetriminos/iTetrimino.tscn")
onready var i_spawn = $SpawnPositions/iSpawn
onready var preloaded_j_tetrimino = preload("res://Tetriminos/jTetrimino.tscn")
onready var j_spawn = $SpawnPositions/jSpawn
onready var preloaded_l_tetrimino = preload("res://Tetriminos/elTetrimino.tscn")
onready var l_spawn = $SpawnPositions/elSpawn
onready var preloaded_o_tetrimino = preload("res://Tetriminos/oTetrimino.tscn")
onready var o_spawn = $SpawnPositions/oSpawn
onready var preloaded_s_tetrimino = preload("res://Tetriminos/sTetrimino.tscn")
onready var s_spawn = $SpawnPositions/sSpawn
onready var preloaded_t_tetrimino = preload("res://Tetriminos/tTetrimino.tscn")
onready var t_spawn = $SpawnPositions/tSpawn
onready var preloaded_z_tetrimino = preload("res://Tetriminos/zTetrimino.tscn")
onready var z_spawn = $SpawnPositions/zSpawn

onready var preloaded_ghost_tetrimino = preload("res://Tetriminos/GhostTetrimino.tscn")
onready var preloaded_rotatation_tester_tetrimino = preload("res://Tetriminos/RotationTesterTetrimino.tscn")
onready var preloaded_locked_mino = preload("res://Minos/LockedMinos.tscn")

onready var playfield = $Playfield
onready var lock_down_timer = $LockDownTimer


func _ready():
	rng = RandomNumberGenerator.new()
	generate_bag()
	spawn_tetrimino()


func generate_bag():
	var bag = [I, J, L, O, S, T, Z]
	var current_element = 6
	
	while current_element >= 0:
		rng.randomize()
		var remaining_element = rng.randi() % (current_element + 1)
		
		var temp = bag[current_element]
		bag[current_element] = bag[remaining_element]
		bag[remaining_element] = temp
		
		current_element -= 1
	
	tetrimino_bag = bag


func spawn_tetrimino():
	# Pull tetrimino out of randomly generated bag
	match tetrimino_bag[current_bag_index]:
		I:
			active_tetrimino = preloaded_i_tetrimino.instance()
			active_tetrimino_type = "i"
			current_spawn_point = i_spawn
		J:
			active_tetrimino = preloaded_j_tetrimino.instance()
			active_tetrimino_type = "j"
			current_spawn_point = j_spawn
		L:
			active_tetrimino = preloaded_l_tetrimino.instance()
			active_tetrimino_type = "l"
			current_spawn_point = l_spawn
		O:
			active_tetrimino = preloaded_o_tetrimino.instance()
			active_tetrimino_type = "o"
			current_spawn_point = o_spawn
		S:
			active_tetrimino = preloaded_s_tetrimino.instance()
			active_tetrimino_type = "s"
			current_spawn_point = s_spawn
		T:
			active_tetrimino = preloaded_t_tetrimino.instance()
			active_tetrimino_type = "t"
			current_spawn_point = t_spawn
		Z:
			active_tetrimino = preloaded_z_tetrimino.instance()
			active_tetrimino_type = "z"
			current_spawn_point = z_spawn
	
	# If the bag is empty, generate a new one
	if current_bag_index == 6:
		generate_bag()
		current_bag_index = 0
	else:
		current_bag_index += 1
	
	# Spawn the tetrimino and dependents
	add_child(active_tetrimino)
	active_tetrimino.global_position = current_spawn_point.global_position
	
	active_minos = active_tetrimino.get_children()
	
	ghost_tetrimino = preloaded_ghost_tetrimino.instance()
	add_child(ghost_tetrimino)
	
	rotation_tester_tetrimino = preloaded_rotatation_tester_tetrimino.instance()
	add_child(rotation_tester_tetrimino)
	
	active_tetrimino.connect("start_lockdown", self, "start_lockdown_timer")
	active_tetrimino.connect("force_lockdown", self, "_on_LockDownTimer_timeout")
	
	emit_signal("new_spawn")


func remove_active_tetrimino():
	active_tetrimino.disconnect("start_lockdown", self, "start_lockdown_timer")
	active_tetrimino.disconnect("force_lockdown", self, "_on_LockDownTimer_timeout")
	
	rotation_tester_tetrimino.queue_free()
	ghost_tetrimino.queue_free()
	active_tetrimino.queue_free()
	
	var active_tetrimino_type = ""
	var active_tetrimino = null
	var active_minos = null
	var ghost_tetrimino = null
	var rotation_tester_tetrimino = null


func start_lockdown_timer():
	lock_down_timer.start(0.5)


func stop_lockdown_timer():
	lock_down_timer.stop()


func _on_LockDownTimer_timeout():
	stop_lockdown_timer()
	
	# Creates new locked minos with the same position and color of active minos
	for current_mino in active_minos:
		var position_y: int = current_mino.global_position.y
		var row = row_y.get(position_y)
		var mino_instance = preloaded_locked_mino.instance()
		
		row.add_child(mino_instance)
		mino_instance.global_position = current_mino.global_position
		mino_instance.set_mino_color(active_tetrimino_type)
	
	remove_active_tetrimino()
	
	spawn_tetrimino()
