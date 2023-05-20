extends StaticBody2D

func highlight(_global_position):
	var coordinates = get_parent().world_to_map(_global_position)
	var top_left_corrner = get_parent().map_to_world(coordinates)
	$Highlight.highlight(top_left_corrner)
