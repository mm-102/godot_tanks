extends Node2D

export(Ammunition.TYPES) var turret_type
export(PackedScene) var shootable_tscn
var is_shooting_locked = false
var shooter = null
onready var spawn_point = $RotateAtMouse/ProjectileSpawnPoint
onready var turret_transform = $RotateAtMouse

func get_turret_global_rotation() -> float:
	return $RotateAtMouse.global_rotation

func _unhandled_input(event):
	if event.is_action_pressed("p_shoot") and not is_shooting_locked:
#		if GameSettings.Dynamic.Ammunition[special_ammo[ammo_slot].type].has("ChargeTime"):
#			call_deferred("_charge_shoot")
#			return
		call_deferred("shoot")

func shoot():
	var bullet_inst = shootable_tscn.instance()
	var shootable_data = ShootableSetupData.new()
	shootable_data.position = spawn_point.global_position
	shootable_data.rotation = turret_transform.global_rotation + PI * 0.5
	shootable_data.shooter = shooter
	bullet_inst.setup(shootable_data)
	get_tree().get_root().add_child(bullet_inst)
	#shot_successful()