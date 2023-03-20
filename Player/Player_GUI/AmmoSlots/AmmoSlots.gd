extends VBoxContainer

const SLOT_BASE_TSCN = preload("res://Player/Player_GUI/AmmoSlots/Slot.tscn")
const P_SLOT = "p_slot_"
const BASE_SLOT = 0
var event_funcs = {
	"shoot": funcref(self, "shoot_event"),
	"pick_up": funcref(self, "pick_up_event"),
	"change_selection" : funcref(self, "change_selection"),
	"reset_autoload" : funcref(self, "reset_autoload")
}
var current_selection = BASE_SLOT

func on_special_ammo_event(event, args : Array):
	event_funcs[event].call_func(args)

func shoot_event(args : Array):
	var type = str(args[0])
	var amount_left = args[1]
	if amount_left <= 0 and int(type) != GameSettings.Dynamic.Tank.BaseAmmoType:
		$AmmoSlots.get_node(type).queue_free()
		change_selection([
			BASE_SLOT,
			GameSettings.Dynamic.Ammunition[GameSettings.Dynamic.Tank.BaseAmmoType].Reload
		])
		return
	if amount_left > 0:
		change_selection([
			BASE_SLOT,
			GameSettings.Dynamic.Ammunition[GameSettings.Dynamic.Tank.BaseAmmoType].Reload
		])
	else:
		change_selection([
			BASE_SLOT,
			GameSettings.Dynamic.Ammunition[GameSettings.Dynamic.Tank.BaseAmmoType].Reload \
			* GameSettings.Dynamic.Tank.AutoloadTimeMultiplier
		])
	if amount_left != INF:
		$AmmoSlots.get_node(type).set_left_ammo(amount_left)

func pick_up_event(args : Array):
	var type = str(args[0])
	var amount_left = args[1]
	var slot = $AmmoSlots.get_node_or_null(type)
	if slot == null:
		var new_slot = SLOT_BASE_TSCN.instance()
		new_slot.setup(type, amount_left)
		$AmmoSlots.add_child(new_slot)
		if $AmmoSlots.get_child_count() == 1:
			change_selection([0, GameSettings.Dynamic.Ammunition[GameSettings.Dynamic.Tank.BaseAmmoType].Reload \
			* GameSettings.Dynamic.Tank.AutoloadTimeMultiplier])
			var autoload_slot = SLOT_BASE_TSCN.instance()
			autoload_slot.setup(type, INF)
			autoload_slot.name = "Autoload"
			add_child(autoload_slot)
			move_child(autoload_slot, 0)
	if amount_left != INF:
		$AmmoSlots.get_node(type).set_left_ammo(amount_left)

func change_selection(args : Array):
	var new_selection = args[0]
	var reload_time = args[1]
	if $AmmoSlots.get_child_count() >= new_selection:
		$AmmoSlots.get_child(current_selection).set_is_selected(false)
	$AmmoSlots.get_child(new_selection).set_is_selected(true, reload_time)
	current_selection = new_selection

func reset_autoload(args : Array):
	var autoload_n = get_node("Autoload")
	autoload_n.set_is_selected(true, args[0])

func test_all():
	for type in Ammunition.TYPES.size():
		on_special_ammo_event("pick_up", [type, 1])
