extends Node

signal selected_turret(ammunition_clip_res)

const INPUT_BASE_NAME = "p_slot_"
const BASE_SLOT = 0
var num_of_slots = 3
var base_ammo_max_clip_size = 4
var base_ammo_reload_time_multiplayer = 0.5
var base_ammo_type: int = Ammunition.TYPES.LASER_BULLET
var selected_slot: AmmunitionSlotObj = null setget set_selected_slot
func set_selected_slot(new):
	if selected_slot != new: 
		selected_slot.state = AmmunitionSlotObj.STATES.NOT_SELECTED
		selected_slot = new
		selected_slot.state = AmmunitionSlotObj.STATES.LOADING
		emit_signal("selected_turret", selected_slot)
var ammunition_clips: Dictionary
var autoload_clip_res 
var ammunition_timers: Array



func _init():
	create_autoload_res()
	for i in range(num_of_slots):
		ammunition_clips[INPUT_BASE_NAME + str(i)] = AmmunitionSlotObj.new()


func _ready():
	var ammunition_clip_name: String = INPUT_BASE_NAME + str(BASE_SLOT)
	var base_slot = ammunition_clips[ammunition_clip_name]
	base_slot.ammo_type = base_ammo_type
	base_slot.amount = base_ammo_max_clip_size
	base_slot.state = AmmunitionSlotObj.STATES.LOADED
	base_slot.reload_time = Ammunition.RELOAD[base_ammo_type] * base_ammo_reload_time_multiplayer
	selected_slot = base_slot
	ammunition_clips[ammunition_clip_name] = base_slot
	$AutoloadSystem.autoload_clip_res = autoload_clip_res
	$AutoloadSystem.base_slot = base_slot
	$AutoloadSystem.last_base_ammo_amount = base_slot.amount
	ammunition_clips[ammunition_clip_name].connect("changed", $AutoloadSystem, "_on_base_slot_changed")
	emit_signal("selected_turret", selected_slot)
	GlobalSignals.emit_signal("new_ammunition_set", autoload_clip_res, ammunition_clips)


func _unhandled_input(event):
	if event is InputEventKey and event.is_pressed():
		for possible_action in ammunition_clips.keys():
			if event.is_action_pressed(possible_action):
				set_selected_slot(ammunition_clips[possible_action])


func create_autoload_res():
	autoload_clip_res = AmmunitionSlotObj.new()
	autoload_clip_res.ammo_type = base_ammo_type
	autoload_clip_res.amount = base_ammo_max_clip_size
	autoload_clip_res.state = AmmunitionSlotObj.STATES.LOADED
	autoload_clip_res.reload_time = Ammunition.RELOAD[base_ammo_type]


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

func pick_up_ammo_box(type, amount = 1):
	if type == base_ammo_type:
		return false
	
	for ammunition_clip in ammunition_clips:
		if ammunition_clip is AmmunitionSlotObj:
			if ammunition_clip.ammo_type == type:
				ammunition_clip.amount += amount
				return
	
	var ammunition_clip = AmmunitionSlotObj.new()
	ammunition_clip.ammo_type = type
	ammunition_clip.amount = amount
	#ammunition_clips.append(ammunition_clip)

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
