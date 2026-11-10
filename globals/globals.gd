extends Node

var player_position = Vector2(0,0)

var remaining_explosions = 1

var lit_up = false

var current_level : Node2D

var player_move_disable : bool

signal next_level

signal light_player_up(size)

signal player_movement

signal pause_game
