extends Node2D

var is_shooting_locked = false

func get_turret_global_rotation() -> float:
	return $RotateAtMouse.global_rotation

func _unhandled_input(event):
	if event.is_action_pressed("p_shoot") and not is_shooting_locked:
#		if GameSettings.Dynamic.Ammunition[special_ammo[ammo_slot].type].has("ChargeTime"):
#			call_deferred("_charge_shoot")
#			return
		call_deferred("shoot")
