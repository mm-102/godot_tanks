extends Camera2D

signal zoom_change(new_zoom)

const S = GameSettings.SPECATOR.CAMERA

var following = false

func _ready():
	connect("zoom_change", get_node(Dir.MAIN + "/Background"), "zoom_change")

func zoom_point(zoom_diff, mouse_position):
	var viewport_size = get_viewport().size
	var previous_zoom = zoom
	if (zoom + zoom_diff) < S.MAX_ZOOM_IN:
		zoom = S.MAX_ZOOM_IN
	elif (zoom + zoom_diff) > S.MAX_ZOOM_OUT:
		zoom = S.MAX_ZOOM_OUT
	else:
		zoom = zoom + zoom_diff
	position += ((viewport_size * 0.5) - mouse_position) * (zoom - previous_zoom)
	emit_signal("zoom_change", zoom)

func _unhandled_input(event):
	if event.is_action_released("p_zoom_in"):
		zoom_point(Vector2.ONE * -S.ZOOM_SPEED, event.position)
		
	if event.is_action_released("p_zoom_out"):
		zoom_point(Vector2.ONE * S.ZOOM_SPEED, event.position)
		
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
		$Tween.interpolate_property(self, "position", position, position + velocity * S.MOVE_SPEED, 0.1)
		$Tween.start()
