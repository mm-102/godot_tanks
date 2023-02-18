extends Projectile

var FOLLOW_SPEED

var _target : PhysicsBody2D = null
var started_targeting = false

func set_params():
	SPEED = $"/root/Master/Settings".SETTINGS.ROCKET_SPEED
	FOLLOW_SPEED = $"/root/Master/Settings".SETTINGS.ROCKET_FOLLOW_SPEED

func _on_StartTargeting_timeout():
	started_targeting = true
	
func _set_target():
	var t = null
	var d = INF
	for player_node in get_tree().get_nodes_in_group("Players"):
#		if player_node.dead:
#			continue
		var cd = global_transform.origin.distance_to(player_node.global_transform.origin)
		if cd < d:
			d = cd
			t = player_node
	
	_target = t

func _integrate_forces(_state):
	if !started_targeting:
		rotation = linear_velocity.angle()
		return
	elif _target == null or !is_instance_valid(_target) or !_target.is_in_group("Players"):
		_set_target()
		return
		
	rotation = global_transform.origin.angle_to_point(_target.global_transform.origin) + PI
	linear_velocity = linear_velocity.linear_interpolate((_target.global_transform.origin.direction_to(global_transform.origin) * -SPEED), _state.get_step()*FOLLOW_SPEED)
