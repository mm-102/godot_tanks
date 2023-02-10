extends Camera2D

const ZOOM_SPEED = 0.3
const MAX_ZOOM_IN = Vector2(0.1, 0.1)
const MAX_ZOOM_OUT = Vector2(2, 2)

func _unhandled_input(event):
	if event.is_action_released("p_zoom_in"):
		if zoom - ZOOM_SPEED * Vector2.ONE < MAX_ZOOM_IN:
			zoom = MAX_ZOOM_IN
			return
		zoom = zoom - ZOOM_SPEED * Vector2.ONE
		
	if event.is_action_released("p_zoom_out"):
		if zoom + ZOOM_SPEED * Vector2.ONE > MAX_ZOOM_OUT:
			zoom = MAX_ZOOM_OUT
			return
		zoom = zoom + ZOOM_SPEED * Vector2.ONE
