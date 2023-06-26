extends MarginContainer

func _ready():
	var use_touch = get_node(Dir.MASTER).is_touch_screen
	if !use_touch:
		queue_free()
