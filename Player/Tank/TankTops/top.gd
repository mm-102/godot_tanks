extends Node2D

export var move_with_mouse: Array


func _process(delta):
	$Rotor.look_at(get_global_mouse_position())
