extends RigidBody2D

const LIFE_TIME = 10

var player_path = null



func _on_LifeTime_timeout():
	die()


func die():
	get_node(player_path).ammo_left += 1
	queue_free()
