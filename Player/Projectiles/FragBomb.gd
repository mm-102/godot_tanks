extends Projectile

#var ammo_type = Ammunition.TYPES.FRAG_BOMB
#
var beginning_time

func _init():
	s = GameSettings.Dynamic.Ammunition[2]

func _ready():
	beginning_time = s.LifeTime # as lifeTime is not kept in dynamic settings :(

func spawn_frag(rotation):
	var frag_inst = load("res://Global/Ammunition.gd").get_tscn(s.Frag.Type).instance()
	
	var gd = Ammunition.get_gd_multi(s.Frag.Type)
	if gd != null:
		frag_inst.set_script(gd)
		
	#var frag_timer : Timer = frag_inst.get_node("LifeTime")
	frag_inst.left_time = GameSettings.Dynamic.Ammunition[s.Frag.Type].LifeTime * s.Frag.LifetimeMultiplayer
	frag_inst.set_scale(frag_inst.scale * s.Frag.Scale)
	frag_inst.is_shot_sound_enabled = false
	
	var velocity = Vector2.UP.rotated(rotation) 
	frag_inst.position = position + 1 * velocity # separate frags from each other
	frag_inst.set_linear_velocity(velocity * s.Frag.Speed * GameSettings.Dynamic.Ammunition[s.Frag.Type].Speed)
	get_node(Dir.PROJECTILES).add_child(frag_inst)
	
func explode():
	$Frag_Bomb_explosion.play()
	for n in range(s.Count):
		var rotation = 2 * PI * n / s.Count
		call_deferred("spawn_frag", rotation)
	hide()
	yield($Frag_Bomb_explosion,"finished")
	.die()	#calls super die() function

func die():
	explode()

func _physics_process(delta):
	$Sprite.self_modulate = Color.red.linear_interpolate(Color.black, $LifeTime.time_left / beginning_time)
	$Sprite.rotate(2 * delta)
