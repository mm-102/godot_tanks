extends Camera2D

signal zoom_change(new_zoom)

const S = GameSettings.CAMERA

func _ready():
	connect("zoom_change", get_node(Dir.MAIN + "/Background"), "zoom_change")

func _unhandled_input(event):
	if event.is_action_released("p_zoom_in"):
		if zoom - S.ZOOM_SPEED * Vector2.ONE < S.MAX_ZOOM_IN:
			zoom = S.MAX_ZOOM_IN
			return
		zoom = zoom - S.ZOOM_SPEED * Vector2.ONE
		emit_signal("zoom_change", zoom)
		
	if event.is_action_released("p_zoom_out"):
		if zoom + S.ZOOM_SPEED * Vector2.ONE > S.MAX_ZOOM_OUT:
			zoom = S.MAX_ZOOM_OUT
			return
		zoom = zoom + S.ZOOM_SPEED * Vector2.ONE
		emit_signal("zoom_change", zoom)
