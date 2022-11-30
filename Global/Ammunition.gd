extends Node

enum TYPES{BULLET = 0, ROCKET = 1, FRAG_BOMB = 2}

var _ammo_tscn = {
	TYPES.BULLET: preload("res://Player/Projectiles/Bullet.tscn"),
	TYPES.ROCKET: preload("res://Player/Projectiles/Rocket.tscn"),
	TYPES.FRAG_BOMB: preload("res://Player/Projectiles/FragBomb.tscn")
}



func get_tscn(name):
	return _ammo_tscn[name]
