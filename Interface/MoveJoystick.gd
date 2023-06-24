extends TouchScreenButton

const sensitivity = 0.4

var press = false

func _unhandled_input(event):
	if !(event is InputEventScreenDrag):	return
	if !press:	return
	
	var rel_pos : Vector2 = event.position - global_position - Vector2(shape.radius, shape.radius)
	
	if rel_pos.length() <= shape.radius:
		$Sprite.position = rel_pos
	else:
		$Sprite.position = Vector2(shape.radius, 0).rotated(rel_pos.angle())
	
	var pos_norm : Vector2 = $Sprite.position / shape.radius
#	print(pos_norm)
	if pos_norm.x > sensitivity:
		Input.action_release("p_left")
		Input.action_press("p_right")
	elif pos_norm.x < -sensitivity:
		Input.action_release("p_right")
		Input.action_press("p_left")
	else:
		Input.action_release("p_left")
		Input.action_release("p_right")
		
	if pos_norm.y > sensitivity:
		Input.action_release("p_forward")
		Input.action_press("p_backward")
	elif pos_norm.y < -sensitivity:
		Input.action_release("p_backward")
		Input.action_press("p_forward")
	else:
		Input.action_release("p_forward")
		Input.action_release("p_backward")
		

func _on_Joystick_pressed():
	press = true

func _on_Joystick_released():
	press = false
	$Sprite.position = Vector2.ZERO
	Input.action_release("p_forward")
	Input.action_release("p_backward")
	Input.action_release("p_left")
	Input.action_release("p_right")
