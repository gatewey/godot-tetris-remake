extends Node2D

signal new_spawn

var active_tetrimino_type = ""
var active_tetrimino = null
var ghost_tetrimino = null
var rotation_tester_tetrimino = null

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

onready var playfield = $Playfield


func _ready():
	active_tetrimino = preloaded_i_tetrimino.instance()
	active_tetrimino_type = "i"
	
	ghost_tetrimino = preloaded_ghost_tetrimino.instance()
	rotation_tester_tetrimino = preloaded_rotatation_tester_tetrimino.instance()
	
	do_initial_spawn()


func do_initial_spawn():
	add_child(active_tetrimino)
	active_tetrimino.global_position = i_spawn.global_position
	
	add_child(ghost_tetrimino)
	# GhostTetrimino.gd controls how it is positioned
	
	add_child(rotation_tester_tetrimino)
	
	emit_signal("new_spawn")
