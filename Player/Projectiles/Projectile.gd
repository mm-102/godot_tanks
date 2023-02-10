extends RigidBody2D
class_name Projectile

const BULLET_SPEED = 200

var player_path = NodePath("")
var position_1 = position
var bullet_state_queue: Array



func setup(player : RigidBody2D):
	player_path = player.get_path()
	var point = player.get_node("%BulletPoint")
	position = point.global_position
	set_linear_velocity(Vector2.UP.rotated(point.global_rotation) * BULLET_SPEED)

func setup_multiplayer(bullet_data : Dictionary):
	set_name(bullet_data.Name)
	position = bullet_data.SP
	set_linear_velocity(bullet_data.V)

func _integrate_forces(state):
	if bullet_state_queue.empty() == true:
		return
	var bullet_state = bullet_state_queue.pop_front()
	var taransform = state.get_transform()
	taransform.origin = bullet_state.Pos
	set_linear_velocity(bullet_state.LV)
	bullet_state_queue.clear()
	state.set_transform(taransform)

func _on_LifeTime_timeout():
	die()

func append_new_state(bullet_state, time_diff):
	yield(get_tree().create_timer(time_diff * 0.001), "timeout")
#	call_deferred("set_new_state", bullet_state)
	bullet_state_queue.append(bullet_state)

func set_new_state(bullet_state):
	set_position(bullet_state.Pos)
	set_linear_velocity(bullet_state.LV)
#	print("[Bounce, Bullet", name, "]: Pos ", position, " | Time: ", get_node(Paths.T_CLOCK).get_time())

func die():
	var player = get_node_or_null(player_path)
	if !(player == null):
		player.ammo_left += 1
	print("[Bullet", name, "]: Pos ", position, " | Time: ", get_node(Paths.T_CLOCK).get_time())
	queue_free()
