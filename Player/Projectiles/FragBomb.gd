extends Projectile



func spawn_frag(rotation):
	var frag_inst = load("res://Global/Ammunition.gd").get_tscn(s.Frag.Type).instance()

	var frag_timer : Timer = frag_inst.get_node("LifeTime")
	frag_timer.wait_time *= s.Frag.LifetimeMultiplayer
	
	var frag_sprite : Sprite = frag_inst.get_node("Sprite")
	frag_sprite.set_scale(frag_sprite.scale * s.Frag.Scale)
	
	var frag_col_shape : CollisionShape2D = frag_inst.get_node("CollisionShape2D")
	frag_col_shape.set_scale(frag_col_shape.scale * s.Frag.Scale)
	
	var velocity = Vector2.UP.rotated(rotation)
	frag_inst.position = position + 1 * velocity # separate frags from each other
	frag_inst.set_linear_velocity(velocity * s.Frag.Speed)
	get_node(Dir.PROJECTILES).add_child(frag_inst)
	
func explode():
	for n in range(s.Count):
		var rotation = 2 * PI * n / s.Count
		call_deferred("spawn_frag", rotation)

	.die()	#call super die() function

func die():
	explode()
