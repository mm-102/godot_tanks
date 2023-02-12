extends Camera2D

var ZOOM_SPEED
var MOVE_SPEED
var MAX_ZOOM_IN
var MAX_ZOOM_OUT

var following = false


func _ready():
	$"/root/Main/Settings".connect("apply_changes", self, "apply_settings")
	apply_settings()

func apply_settings():
	var settings = $"/root/Main/Settings".SETTINGS
	ZOOM_SPEED = settings.SPECTATOR_CAMERA_ZOOM_SPEED
	MOVE_SPEED = settings.SPECTATOR_CAMERA_MOVE_SPEED
	MAX_ZOOM_IN = settings.SPECTATOR_CAMERA_MAX_ZOOM_IN
	MAX_ZOOM_OUT = settings.SPECTATOR_CAMERA_MAX_ZOOM_OUT

func zoom_point(zoom_diff, mouse_position):
	var viewport_size = get_viewport().size
	var previous_zoom = zoom
	if (zoom + zoom_diff) < MAX_ZOOM_IN:
		zoom = MAX_ZOOM_IN
	elif (zoom + zoom_diff) > MAX_ZOOM_OUT:
		zoom = MAX_ZOOM_OUT
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
