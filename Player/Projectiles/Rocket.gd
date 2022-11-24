extends RigidBody2D

var _time = 20
var _target_time = 2
var _target : RigidBody2D = null
var targeted = false

const _speed = 200
const _follow_speed = 5

func _ready():
	var death_timer = Timer.new()
	death_timer.connect("timeout", self, "_on_timer_timeout")
	add_child(death_timer)
	death_timer.start(_time)
	
	var target_timer = Timer.new()
	target_timer.connect("timeout", self, "_set_target")
	target_timer.one_shot = true
	add_child(target_timer)
	target_timer.start(_target_time)
	add_to_group("projectile")

func _on_timer_timeout():
	die()

func die():
	get_parent().get_parent().get_child(0).ammo_left += 1
	get_parent().queue_free()

func _set_target():
	targeted = true
	var t = null
	var d = INF
	for player_node in get_tree().get_nodes_in_group("Players"):
		if player_node.dead:
			continue
		var cd = global_transform.origin.distance_to(player_node.get_child(0).global_transform.origin)
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
	
	linear_velocity = linear_velocity.linear_interpolate((_target.global_transform.origin.direction_to(global_transform.origin) * -_speed), _state.get_step()*_follow_speed)
