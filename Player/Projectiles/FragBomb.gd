extends Projectile

#var ammo_type = Ammunition.TYPES.FRAG_BOMB
#
export var count = 5
export var frag_spawn_distance = 10
export(Ammunition.FRAG_TYPES) var frag_type
const FRAG_TSCNS = {
	Ammunition.FRAG_TYPES.BULLET: preload("res://Player/Projectiles/Bullet.tscn"),
	Ammunition.FRAG_TYPES.FIREBALL: preload("res://Player/Projectiles/Fireball.tscn"),
	Ammunition.FRAG_TYPES.ROCKET: preload("res://Player/Projectiles/Rocket.tscn"),
}
export var frag_speed_multiplier = 0.7
export var frag_lifetime_multiplier = 0.5
export var frag_scale_multiplier = 0.5
var is_dying = false



func _ready():
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color.red, life_time)
	$Tween.start()
	self.set_angular_velocity(10)


func spawn_frag(_rotation):
	var frag_inst: Projectile = FRAG_TSCNS[frag_type].instance()
	var shootable_data = ShootableSetupData.new()
	
	shootable_data.position = self.position + Vector2.UP.rotated(_rotation) * frag_spawn_distance
	shootable_data.rotation = _rotation
	shootable_data.shooter = shooter
	
	shootable_data.frag_speed_multiplier = frag_speed_multiplier
	shootable_data.frag_lifetime_multiplier = frag_lifetime_multiplier
	shootable_data.frag_scale_multiplier = frag_scale_multiplier
	
	frag_inst.setup_frag(shootable_data)
	get_tree().get_root().add_child(frag_inst)



func die():
	if is_dying:
		return
	is_dying = true
	for n in range(count):
		var _rotation = 2 * PI * n / count
		call_deferred("spawn_frag", _rotation)
	
	queue_free()
