extends RigidBody2D
class_name Projectile

<<<<<<< HEAD
var player_path = NodePath()
=======
var player_path = NodePath("")
>>>>>>> 74ee30a046611648dd5d32d7572f29166de64a8f

func _on_LifeTime_timeout():
	die()


func die():
<<<<<<< HEAD
	var player_node = get_node_or_null(player_path)
	if !(player_node == null):
		player_node.ammo_left += 1
=======
	var player = get_node_or_null(player_path)
	if !(player == null):
		player.ammo_left += 1
>>>>>>> 74ee30a046611648dd5d32d7572f29166de64a8f
	queue_free()
