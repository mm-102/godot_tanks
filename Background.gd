extends ParallaxBackground

onready var texture_size = $"ParallaxLayer/TextureRect".texture.get_size()
var zoom = Vector2.ONE
	
func zoom_change(new_zoom): # called by signals
	zoom = new_zoom
	_update()

func _update():
	var window_size = get_viewport().get_visible_rect().size * (zoom + Vector2(0.2,0.2))
	var size_vector = window_size * texture_size
	$ParallaxLayer/TextureRect.rect_size = size_vector
	$ParallaxLayer.motion_mirroring = size_vector

func _ready():
	get_tree().root.connect("size_changed", self, "_update")
	_update()
