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
	current_turret = new
	for child in self.get_children():
		self.remove_child(child)
	if turrets.has(new):
		current_turret_node = turrets[current_turret]
		self.add_child(turrets[current_turret])
	else:
		current_turret_node = null

var current_turret_node = null


func _ready():
	for turret in turrets.values():
		turret.shooter = owner
	#set_current_turret(Ammunition.TYPES.BULLET)

func get_turret_rotation() -> float:
	return current_turret_node.get_turret_global_rotation()


func _on_AmmunitionSystem_selected_turret(ammunition_clip_res: AmmunitionSlotObj):
#	if turrets.has(ammunition_clip_res.ammo_type):
#		turrets[ammunition_clip_res.ammo_type].ammunition_clip_res = ammunition_clip_res
	set_current_turret(ammunition_clip_res.ammo_type)
	if is_instance_valid(current_turret_node):
		current_turret_node.ammunition_clip_res = ammunition_clip_res
