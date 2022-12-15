extends RigidBody2D
class_name Projectile

var player_path = null

func _on_LifeTime_timeout():
	die()


func die():
	if player_path != null:
		var player = get_node(player_path)
		player.ammo_left += 1
	queue_free()
