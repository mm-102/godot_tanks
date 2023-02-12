extends Camera2D

var ZOOM_SPEED
var MAX_ZOOM_IN
var MAX_ZOOM_OUT

func _ready():
	$"/root/Main/Settings".connect("apply_changes", self, "apply_settings")
	apply_settings()

func apply_settings():
	var settings = $"/root/Main/Settings".SETTINGS
	ZOOM_SPEED = settings.PLAYER_CAMERA_ZOOM_SPEED
	MAX_ZOOM_IN = settings.PLAYER_CAMERA_MAX_ZOOM_IN
	MAX_ZOOM_OUT = settings.PLAYER_CAMERA_MAX_ZOOM_OUT
	
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
