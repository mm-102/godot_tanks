extends Reference
class_name Ammunition

enum TYPES{BULLET, ROCKET, FRAG_BOMB, LASER, LASER_BULLET, FIREBALL}


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

const _ammo_gd_multi = {
	TYPES.ROCKET: preload("res://Player/Projectiles/RocketMulti.gd"),
}

const _ammo_box_texture = {
	TYPES.BULLET: preload("res://textures/bullet.png"),
	TYPES.ROCKET: preload("res://textures/rocket.png"),
	TYPES.FRAG_BOMB: preload("res://textures/bullet.png"),
	TYPES.LASER: preload("res://textures/laser_box.png"),
	TYPES.LASER_BULLET: preload("res://textures/laser_bullet_box.png"),
	TYPES.FIREBALL: preload("res://textures/fireball_box.png")
}


static func get_tscn(name):
	return load(_ammo_tscn_path[name])

static func get_charge_particles_tscn(name):
	if _ammo_charge_particles_tscn_path.has(name):
		return load(_ammo_charge_particles_tscn_path[name])
	return null

static func get_gd_multi(name):
	if _ammo_gd_multi.has(name):
		return _ammo_gd_multi[name]
	return null

static func get_box_texture(name):
	return _ammo_box_texture[name]

static func get_string_from_type(type):
	return TYPES.keys()[type]\
		.to_lower()\
		.replace("_", " ")\
		.capitalize()
	
