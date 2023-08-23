extends Node

var base_ammo_type: int = Ammunition.TYPES.BULLET

#func reset_autoload_timer():
#	var load_time = GameSettings.Dynamic.Ammunition[s.BaseAmmoType].Reload\
#			* s.AutoloadTimeMultiplier
#	autoload_timer_n.start(load_time)
#	emit_signal("special_ammo_event", "reset_autoload", [load_time])
#
#
#
#func _on_BaseTypeAutoload():
#	if special_ammo[0].amount < s.BaseAmmoClipSize - 1:
#		reset_autoload_timer()
#	if special_ammo[0].amount < s.BaseAmmoClipSize:
#		special_ammo[0].amount += 1
#		emit_signal("special_ammo_event", "pick_up" , [s.BaseAmmoType, special_ammo[0].amount])


func pick_up_ammo_box(type):
	if type == base_ammo_type:
		return false

#	var picked = false
#	var type_slot = {}
#	for slot in special_ammo.size():
#		type_slot[special_ammo[slot].type] = slot
#	if type_slot.has(type):
#		special_ammo[type_slot[type]].amount += 1
#		picked = true
#	elif special_ammo.size() < s.MaxAmmoTypes:
#		special_ammo.push_back({"type" : int(type), "amount" : 1})
#		type_slot[special_ammo[-1].type] = -1
#		picked = true
#	get_method_list()
#	if picked:
#		# [improve] This event 'pick_up' var may be done by constant ".PICK_UP with enum in global file
#		emit_signal("special_ammo_event", "pick_up" , [type, special_ammo[type_slot[type]].amount])
#	return picked

#
#func _update_slots_after_shoot():
#	emit_signal("special_ammo_event", "shoot", [special_ammo[ammo_slot].type, special_ammo[ammo_slot].amount])
#	if special_ammo[ammo_slot].amount <= 0\
#	 and special_ammo[ammo_slot].type != s.BaseAmmoType:
#		special_ammo.pop_at(ammo_slot)
#		ammo_slot = 0
#		set_turret_type(special_ammo[0].type)
#		if is_multiplayer:
#			transfer_n.fetch_change_ammo_type(special_ammo[0].type)
#
#
#
#func shot_successful():
#	special_ammo[ammo_slot].amount -= 1
#	_update_slots_after_shoot()
#	slot_locked = false
#	if ammo_slot == 0 and special_ammo[0].amount < s.BaseAmmoClipSize:
#		reset_autoload_timer()
#	if ammo_slot == 0 and special_ammo[0].amount == 0:
#		reload_timer_n.start(autoload_timer_n.time_left)
#	else:
#		reload_timer_n.start(GameSettings.Dynamic.Ammunition[special_ammo[ammo_slot].type].Reload)
