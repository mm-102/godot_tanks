extends Camera2D

signal zoom_change(new_zoom)

const S = GameSettings.STATIC.CAMERA.SPECTATOR
var following = false



func _ready():
	var _err = connect("zoom_change", get_node(Dir.MAIN + "/Background"), "zoom_change")
	_err = Transfer.connect("data_during_game_recived", self, "_on_data_during_game_recived")
	set_process_input(false)
	set_process(false)

func start_spectating():
	_set_current(true)
	set_process_input(true)
	set_process(true)

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

func _input(event):
	if event.is_action_released("p_zoom_in"):
		zoom_point(Vector2.ONE * -S.ZOOM_SPEED, event.global_position)
		
	if event.is_action_released("p_zoom_out"):
		zoom_point(Vector2.ONE * S.ZOOM_SPEED, event.global_position)
		
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


func _on_data_during_game_recived():
	start_spectating()

func on_self_player_died(pos):
	start_spectating()
	set_global_position(pos)
	
