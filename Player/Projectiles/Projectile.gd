extends RigidBody2D

var player_path = null



func _on_LifeTime_timeout():
	die()


func die():
	var player = get_node_or_null(player_path)
	if !(player == null):
		player.ammo_left += 1
	queue_free()
