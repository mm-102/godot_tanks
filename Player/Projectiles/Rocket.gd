extends "res://Player/Projectiles/Projectile.gd"

const SPEED = 200
const FOLLOW_SPEED = 5

var _target : RigidBody2D = null



func _on_StartTargeting_timeout():
	_set_target()
	
func _set_target():
	var t = null
	var d = INF
	for player_node in get_tree().get_nodes_in_group("Players"):
		if player_node.dead:
			continue
		var cd = global_transform.origin.distance_to(player_node.global_transform.origin)
		if cd < d:
			d = cd
			t = player_node
	
	_target = t

func _integrate_forces(_state):
	if !_target:
		rotation = linear_velocity.angle()
		return
	if _target.dead:
		_set_target()
		return
		
	rotation = global_transform.origin.angle_to_point(_target.global_transform.origin) + PI
	
	linear_velocity = linear_velocity.linear_interpolate((_target.global_transform.origin.direction_to(global_transform.origin) * -SPEED), _state.get_step()*FOLLOW_SPEED)
