extends RigidBody2D
class_name Projectile


var player_path = NodePath("")

func _init():
	# collision and mask for every projectile
	set_collision_layer(2)
	set_collision_mask(7)

func _on_LifeTime_timeout():
	die()


func die():
	var player = get_node_or_null(player_path)
	if !(player == null):
		player.ammo_left += 1
	queue_free()
