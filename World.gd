extends Node2D

var active_tetrimino = null
var ghost_tetrimino = null

onready var preloaded_i_tetrimino = preload("res://Tetriminos/iTetrimino.tscn")
onready var preloaded_j_tetrimino = preload("res://Tetriminos/jTetrimino.tscn")
onready var preloaded_l_tetrimino = preload("res://Tetriminos/elTetrimino.tscn")
onready var preloaded_o_tetrimino = preload("res://Tetriminos/oTetrimino.tscn")
onready var preloaded_s_tetrimino = preload("res://Tetriminos/sTetrimino.tscn")
onready var preloaded_t_tetrimino = preload("res://Tetriminos/tTetrimino.tscn")
onready var preloaded_z_tetrimino = preload("res://Tetriminos/zTetrimino.tscn")
onready var preloaded_ghost_tetrimino = preload("res://Tetriminos/GhostTetrimino.tscn")
onready var spawn_position = $SpawnPosition


func _ready():
	active_tetrimino = preloaded_i_tetrimino.instance()
	ghost_tetrimino = preloaded_ghost_tetrimino.instance()
	
	call_deferred("spawn_active_tetrimino")
	call_deferred("spawn_ghost_tetrimino")


func spawn_active_tetrimino():
	add_child(active_tetrimino)
	active_tetrimino.global_position = spawn_position.global_position


func spawn_ghost_tetrimino():
	add_child(ghost_tetrimino)
	# GhostTetrimino.gd controls how it is positioned
