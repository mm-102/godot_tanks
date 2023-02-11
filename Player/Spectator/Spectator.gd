extends Camera2D

const ZOOM_SPEED = 0.3
const MOVE_SPEED = 50
const MAX_ZOOM_IN = Vector2(0.1, 0.1)

var following = false

func zoom_point(zoom_diff, mouse_position):
	var viewport_size = get_viewport().size
	var previous_zoom = zoom
	if (zoom + zoom_diff) < MAX_ZOOM_IN:
		zoom = MAX_ZOOM_IN
	else:
		zoom = zoom + zoom_diff
	position += ((viewport_size * 0.5) - mouse_position) * (zoom - previous_zoom)

func _unhandled_input(event):
	if event.is_action_released("p_zoom_in"):
		zoom_point(Vector2.ONE * -ZOOM_SPEED, event.position)
		
	if event.is_action_released("p_zoom_out"):
		zoom_point(Vector2.ONE * ZOOM_SPEED, event.position)
		
	if event.is_action_pressed("p_shoot"):
		following = true
		
	if event.is_action_released("p_shoot"):
		following = false
	
	if event is InputEventMouseMotion and following:
		position -= event.relative * zoom

func _process(_delta):
	var velocity = Vector2.ZERO
	velocity.y = int(Input.is_action_pressed("p_backward")) - int(Input.is_action_pressed("p_forward"))
	velocity.x = int(Input.is_action_pressed("p_right")) - int(Input.is_action_pressed("p_left"))
	if velocity != Vector2.ZERO:
		$Tween.stop(self, "position")
		$Tween.interpolate_property(self, "position", position, position + velocity * MOVE_SPEED, 0.1)
		$Tween.start()
