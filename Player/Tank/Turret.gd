extends Sprite

var use_touch = false

func _ready():
	use_touch = get_node(Dir.MASTER).is_touch_screen

func _process(_delta):
	if use_touch:
		return
	var mouse = get_local_mouse_position()
	var a = position.angle_to_point(mouse) - PI / 2
	rotate(a)
