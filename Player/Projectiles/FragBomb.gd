extends "res://Player/Projectiles/Projectile.gd"


const FRAG_COUNT = 30
const FRAG_SPEED = 150
const FRAG_SCALE = 0.5
const FRAG_LIFETIME_MULTIPLIER = 0.2

const BULLET_TSCN =  preload("res://Player/Projectiles/Bullet.tscn")


func spawn_frag(rotation):
	var frag_inst = BULLET_TSCN.instance()

	var frag_timer : Timer = frag_inst.get_node("LifeTime")
	frag_timer.wait_time *= FRAG_LIFETIME_MULTIPLIER
	
	var frag_sprite : Sprite = frag_inst.get_node("Sprite")
	frag_sprite.set_scale(frag_sprite.scale * FRAG_SCALE)
	
	var frag_col_shape : CollisionShape2D = frag_inst.get_node("CollisionShape2D")
	frag_col_shape.set_scale(frag_col_shape.scale * FRAG_SCALE)
	
	var velocity = Vector2.UP.rotated(rotation)
	frag_inst.position = position + 1 * velocity # separate frags from each other
	frag_inst.player_path = get_path()
	frag_inst.set_linear_velocity(velocity * FRAG_SPEED)
	get_node("/root/Main/Map/Projectiles").add_child(frag_inst)
	
func explode():
	for n in range(FRAG_COUNT):
		var rotation = 2 * PI * n / FRAG_COUNT
		call_deferred("spawn_frag", rotation)

	.die()	#call super die() function

func die():
	explode()
