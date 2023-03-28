extends ParallaxBackground

onready var texture_size = $"ParallaxLayer/TextureRect".texture.get_size()
var zoom = Vector2.ONE

func _process(delta):
	var window_size = get_viewport().get_visible_rect().size * (zoom + Vector2(0.2,0.2))
	var size_vector = window_size * texture_size
	$ParallaxLayer/TextureRect.rect_size = size_vector
	$ParallaxLayer.motion_mirroring = size_vector
	
func zoom_change(new_zoom): # called by signals
	zoom = new_zoom
