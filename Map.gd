extends Node2D

var player = preload("res://Player/Tank/Tank.tscn")



func init_player():
	var player_inst = player.instance()
	add_child_below_node($Players, player_inst, true)
