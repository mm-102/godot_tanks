extends TouchScreenButton

signal set_turret_angle(angle)

var press = false

func _unhandled_input(event):
	if !(event is InputEventScreenDrag):	return
	if !press:	return
	
	var rel_pos : Vector2 = event.position - global_position - Vector2(shape.radius, shape.radius)
	
	if rel_pos.length() <= shape.radius:
		$Sprite.position = rel_pos
	elif rel_pos.length() <= 4 * shape.radius:
		$Sprite.position = Vector2(shape.radius, 0).rotated(rel_pos.angle())
	
	var turret_angle = $Sprite.position.angle() + PI / 2
	emit_signal("set_turret_angle", turret_angle)

func _on_Joystick_pressed():
	press = true

func _on_Joystick_released():
	press = false
	$Sprite.position = Vector2.ZERO

