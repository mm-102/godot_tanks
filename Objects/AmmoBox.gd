extends Area2D
tool

const disappear_particles = preload("res://Objects/AmmoBoxDisappearParticles.tscn")

export(Ammunition.TYPES) var type = Ammunition.TYPES.ROCKET setget set_type

func _on_AmmoBox_body_entered(body):
	if !body.is_in_group("Players"):
		return
	if body.is_in_group("ME"):
		if body.pick_up_ammo_box(type):
			die()

func die():
	var particles = disappear_particles.instance()
	particles.one_shot = true
	particles.global_position = global_position
	particles.scale = scale
	get_parent().add_child(particles)
	queue_free()
	
func set_type(var t):
	type = t
	$SlotRect.type = type
