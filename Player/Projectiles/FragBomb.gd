extends Projectile

#var ammo_type = Ammunition.TYPES.FRAG_BOMB
#
func _init():
	s = GameSettings.Dynamic.Ammunition[2]


func spawn_frag(rotation):
	var frag_inst = load("res://Global/Ammunition.gd").get_tscn(s.Frag.Type).instance()
	
	var gd = Ammunition.get_gd_multi(s.Frag.Type)
	if gd != null:
		frag_inst.set_script(gd)
	
	var frag_timer : Timer = frag_inst.get_node("LifeTime")
	frag_timer.wait_time *= s.Frag.LifetimeMultiplayer
	frag_inst.set_scale(frag_inst.scale * s.Frag.Scale)
	
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
