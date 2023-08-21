extends Projectile

const explosion_particles_tsnc = preload("res://Player/Particles/FireballExplosionParticles.tscn")
var is_multiplayer = false#get_node(Dir.MASTER).is_multiplayer
var is_dying = false
const ammo_type = Ammunition.TYPES.FIREBALL
#
#func _init():
#	s = GameSettings.Dynamic.Ammunition[5]



func _on_Fireball_body_entered(_body):
	if _body.get("ammo_type") == ammo_type:
		return
	die()
	
func die():
	if is_dying:
		return
	is_dying = true
	var explosion_particles = explosion_particles_tsnc.instance()
	explosion_particles.global_position = global_position
	explosion_particles.one_shot = true
	get_tree().get_root().call_deferred("add_child", explosion_particles)
	
	if not is_multiplayer:
		for body in $ExplosionArea.get_overlapping_bodies():
			if body.is_in_group("Projectiles") or (body.is_in_group("Players")):
				body.die()
	
	queue_free()
