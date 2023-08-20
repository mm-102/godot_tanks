extends KinematicBody2D

var movement_speed = 100
var rotation_speed = 2

onready var rotor = $Rotor
onready var collision = $Collision


func _physics_process(delta):
	movement(delta)

func movement(delta):
	var velocity: Vector2 = Vector2.ZERO
	var y_direction = Input.get_action_strength("p_backward") - Input.get_action_strength("p_forward")
	var x_direction = Input.get_action_strength("p_right") - Input.get_action_strength("p_left")
	if y_direction > 0:
		x_direction = -x_direction
	rotor.rotation += x_direction * rotation_speed * delta
	collision.rotation = rotor.rotation
	velocity = Vector2(0, y_direction * movement_speed).rotated(rotor.rotation)
	
	var _x = move_and_slide(velocity)

