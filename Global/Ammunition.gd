extends Node

enum TYPES{BULLET, ROCKET, FRAG_BOMB}



var _ammo_tscn = {
	TYPES.BULLET: preload("res://Player/Projectiles/Bullet.tscn"),
	TYPES.ROCKET: preload("res://Player/Projectiles/Rocket.tscn"),
	TYPES.FRAG_BOMB: preload("res://Player/Projectiles/FragBomb.tscn")
}

var _ammo_box_texture = {
	TYPES.BULLET: preload("res://textures/bullet.png"),
	TYPES.ROCKET: preload("res://textures/rocket.png"),
	TYPES.FRAG_BOMB: preload("res://textures/bullet.png")
}



func get_box_texture(name):
	return _ammo_box_texture[name]

func get_tscn(name):
	return _ammo_tscn[name]
