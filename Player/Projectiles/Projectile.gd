extends RigidBody2D

var player_path = null



func _on_LifeTime_timeout():
	die()


func die():
	if player_path:
		get_node(player_path).ammo_left += 1
	queue_free()
