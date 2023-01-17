extends RigidBody2D
class_name Projectile

const BULLET_SPEED = 200

var player_path = NodePath("")

func setup(player : RigidBody2D):
	player_path = player.get_path()
	var point = player.get_node("%BulletPoint")
	position = point.global_position
	set_linear_velocity(Vector2.UP.rotated(point.global_rotation) * BULLET_SPEED)

func setup_multiplayer(bullet_data : Dictionary):
	position = bullet_data.SP
	set_linear_velocity(bullet_data.V)

func _on_LifeTime_timeout():
	die()

func die():
	var player = get_node_or_null(player_path)
	if !(player == null):
		player.ammo_left += 1
	queue_free()
