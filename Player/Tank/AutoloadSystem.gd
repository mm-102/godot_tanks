extends Node

var base_slot: AmmunitionSlotObj
var autoload_clip_res: AmmunitionSlotObj setget set_autoload_clip_res
func set_autoload_clip_res(new):
	autoload_clip_res = new
	autoload_clip_res.connect("state_changed", self, "_on_autoload_state_changed")
var last_base_ammo_amount: int



func _on_base_slot_changed():
	if last_base_ammo_amount != base_slot.amount\
			and base_slot.amount < autoload_clip_res.amount\
			and autoload_clip_res.state != AmmunitionSlotObj.STATES.LOADING:
		autoload_clip_res.start_loading()

func add_ammo_to_base_slot():
	if base_slot.amount < autoload_clip_res.amount:
		base_slot.amount += 1
	check_is_base_slot_ammo_not_full()


func check_is_base_slot_ammo_not_full():
	if base_slot.amount < autoload_clip_res.amount:
		autoload_clip_res.start_loading()


func _on_autoload_state_changed(state):
	if state == AmmunitionSlotObj.STATES.LOADED:
		add_ammo_to_base_slot()
