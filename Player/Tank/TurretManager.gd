extends Node2D

var turrets: Dictionary = {
	Ammunition.TYPES.BULLET: preload("res://Player/Tank/TankTops/top_bullet.tscn").instance(),
	Ammunition.TYPES.FRAG_BOMB: preload("res://Player/Tank/TankTops/top_bomb.tscn").instance(),
	Ammunition.TYPES.FIREBALL: preload("res://Player/Tank/TankTops/top_fireball.tscn").instance(),
	Ammunition.TYPES.LASER: preload("res://Player/Tank/TankTops/top_laser.tscn").instance(),
	Ammunition.TYPES.ROCKET: preload("res://Player/Tank/TankTops/top_rocket.tscn").instance(),
}
var current_turret: int setget set_current_turret
func set_current_turret(new):
	if turrets.has(new):
		current_turret = new
		for child in self.get_children():
			self.remove_child(child)
		self.add_child(turrets[current_turret])

func _ready():
	set_current_turret(Ammunition.TYPES.BULLET)
