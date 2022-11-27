extends Sprite

func _process(_delta):
	var mouse = get_local_mouse_position()
	var a = position.angle_to_point(mouse) - PI / 2
	rotate(a)
