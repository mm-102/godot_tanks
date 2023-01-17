extends Reference
class_name Ammunition

enum TYPES{BULLET, ROCKET, FRAG_BOMB, LASER}


const _ammo_tscn = {
	TYPES.BULLET: preload("res://Player/Projectiles/Bullet.tscn"),
	TYPES.ROCKET: preload("res://Player/Projectiles/Rocket.tscn"),
	TYPES.FRAG_BOMB: preload("res://Player/Projectiles/FragBomb.tscn"),
	TYPES.LASER: preload("res://Player/Projectiles/LaserBeam.tscn")
}

const _ammo_box_texture = {
	TYPES.BULLET: preload("res://textures/bullet.png"),
	TYPES.ROCKET: preload("res://textures/rocket.png"),
	TYPES.FRAG_BOMB: preload("res://textures/bullet.png"),
	TYPES.LASER: preload("res://textures/laser_box.png")
}


static func get_tscn(name):
	return _ammo_tscn[name]

static func get_box_texture(name):
	return _ammo_box_texture[name]
