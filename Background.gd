extends ParallaxBackground

onready var texture_size = $"ParallaxLayer/TextureRect".texture.get_size()
var zoom = Vector2.ONE

func _process(delta):
	var window_size = get_viewport().get_visible_rect().size
	var size_vector = Vector2(\
	texture_size.x * (int(window_size.x / texture_size.x)+2),\
	texture_size.y * (int(window_size.y / texture_size.y)+2)\
	)
	$ParallaxLayer/TextureRect.rect_size = size_vector
	$ParallaxLayer.motion_mirroring = size_vector
	
func zoom_change(new_zoom): # called by signals
	zoom = new_zoom
