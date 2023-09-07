extends CenterContainer

onready var slot = $"0"

var ammo_autoload_res: AmmunitionSlotObj setget set_ammo_autoload_res
func set_ammo_autoload_res(new):
	ammo_autoload_res = new
	slot.progress_bar.loading_time = ammo_autoload_res.reload_time
	slot.slot_rect.set_type(ammo_autoload_res.ammo_type)
	slot.slot_rect.set_amount_left_text(ammo_autoload_res.amount)
	ammo_autoload_res.connect("changed", self, "_on_ammo_base_res_changed")
	_on_ammo_base_res_changed()
	
var ammo_base_res: AmmunitionSlotObj setget set_ammo_base_res
func set_ammo_base_res(new):
	ammo_base_res = new


func _on_ammo_base_res_changed():
	slot.progress_bar.set_state(ammo_autoload_res.state)
