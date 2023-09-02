extends Resource
class_name AmmunitionSlotObj

enum STATES{NOT_SELECTED, LOADING, LOADED}

export(Ammunition.TYPES) var ammo_type = -1 setget set_ammo_type
func set_ammo_type(new):
	ammo_type = new
	emit_changed()
export(STATES) var state: int = false setget set_state
func set_state(new):
	state = new
	emit_changed()
export(int) var amount = 0 setget set_amount
func set_amount(new):
	amount = new
	emit_changed()
export(int) var reload_time = 0 

