extends "res://Player/Projectiles/Projectile.gd"

onready var frag_tscn = load("res://Player/Projectiles/Bullet.tscn")

const FRAG_COUNT = 15
const FRAG_SPEED = 200

func _on_LifeTime_timeout():
	for n in range(FRAG_COUNT):
		var frag_inst = frag_tscn.instance()
		frag_inst.scale = Vector2(0.1,0.1) # not working
		var rot = 2 * PI * n / FRAG_COUNT
		var velocity = Vector2.UP.rotated(rot)
		frag_inst.position = position + 1 * velocity # separate frags from each other
		frag_inst.player_path = get_path()
		frag_inst.set_linear_velocity(velocity * FRAG_SPEED)
		get_node("/root/Map/Projectiles").add_child(frag_inst)
	
	die() # call super class die() function
