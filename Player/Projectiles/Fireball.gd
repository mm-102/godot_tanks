extends Projectile

const explosion_particles_tsnc = preload("res://Player/Particles/FireballExplosionParticles.tscn")
onready var is_multiplayer = get_node(Dir.MASTER).is_multiplayer
#const ammo_type = Ammunition.TYPES.FIREBALL
#
func _init():
	s = GameSettings.Dynamic.Ammunition[5]

func die():
	explode()

func _on_Fireball_body_entered(_body):
	# explode when fireball touch ANYTHING
	explode()
	
func explode():
	$Fireball_explosion.play()
	var explosion_particles = explosion_particles_tsnc.instance()
	explosion_particles.global_position = global_position
	explosion_particles.one_shot = true
	get_node(Dir.PROJECTILES).call_deferred("add_child", explosion_particles)
	
	for body in $ExplosionArea.get_overlapping_bodies():
		if body.is_in_group("Projectiles") or (body.is_in_group("Players") and !is_multiplayer):
			body.die()
	hide()
	yield($Fireball_explosion,"finished")
	.die()
