extends Node2D

func _process(_delta):
	self.look_at(get_global_mouse_position())
