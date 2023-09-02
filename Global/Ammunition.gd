extends Reference
class_name Ammunition

enum TYPES{BULLET, ROCKET, FRAG_BOMB, LASER, LASER_BULLET, FIREBALL}
const RELOAD: Dictionary = {
	TYPES.BULLET: 2,
	TYPES.ROCKET: 2,
	TYPES.FRAG_BOMB: 2,
	TYPES.LASER: 2,
	TYPES.LASER_BULLET: 2,
	TYPES.FIREBALL: 2,
}
enum FRAG_TYPES{BULLET, FIREBALL, ROCKET}


const _ammo_tscn_path = {
	TYPES.BULLET: "res://Player/Projectiles/Bullet.tscn",
	TYPES.ROCKET: "res://Player/Projectiles/Rocket.tscn",
	TYPES.FRAG_BOMB: "res://Player/Projectiles/FragBomb.tscn",
	TYPES.LASER: "res://Player/Projectiles/LaserBeam.tscn",
	TYPES.LASER_BULLET: "res://Player/Projectiles/LaserBullet.tscn",
	TYPES.FIREBALL: "res://Player/Projectiles/Fireball.tscn"
}

const _ammo_charge_particles_tscn_path = {
	TYPES.LASER : "res://Player/Particles/ChargeLaserBeamParticles.tscn"
}

#const _ammo_gd_multi = {
#	TYPES.ROCKET: preload("res://Player/Projectiles/RocketMulti.gd"),
#}

const _ammo_box_texture = {
	TYPES.BULLET: preload("res://textures/box_texture/bullet_box.png"),
	TYPES.ROCKET: preload("res://textures/box_texture/rocket_box.png"),
	TYPES.FRAG_BOMB: preload("res://textures/box_texture/frag_bomb_box.png"),
	TYPES.LASER: preload("res://textures/box_texture/laser_box.png"),
	TYPES.LASER_BULLET: preload("res://textures/box_texture/laser_bullet_box.png"),
	TYPES.FIREBALL: preload("res://textures/box_texture/fireball_box.png")
}


static func get_tscn(name):
	return load(_ammo_tscn_path[name])

static func get_charge_particles_tscn(name):
	if _ammo_charge_particles_tscn_path.has(name):
		return load(_ammo_charge_particles_tscn_path[name])
	return null

static func get_gd_multi(_name):
#	if _ammo_gd_multi.has(name):
#		return _ammo_gd_multi[name]
	return null

static func get_box_texture(name):
	return _ammo_box_texture[name]

static func get_string_from_type(type):
	return TYPES.keys()[type]\
		.to_lower()\
		.replace("_", " ")\
		.capitalize()
