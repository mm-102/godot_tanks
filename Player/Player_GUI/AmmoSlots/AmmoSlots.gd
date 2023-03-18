extends HBoxContainer

const SLOT_BASE_TSCN = preload("res://Player/Player_GUI/AmmoSlots/Slot.tscn")
const P_SLOT = "p_slot_"
const BASE_SLOT = 0
var event_funcs = {
	"shoot": funcref(self, "shoot_event"),
	"pick_up": funcref(self, "pick_up_event"),
	"change_selection" : funcref(self, "change_selection")
}
var current_selection = BASE_SLOT



#func _ready():
#	test_all()

#func _input(event):
#	choose_slot(event)
#
#func choose_slot(event: InputEvent):
#	for slot_num in range(10):
#		if event.is_action_pressed(P_SLOT + str(slot_num)) && \
#				get_child_count() > slot_num:
#			change_selection(slot_num)

func on_special_ammo_event(event, args : Array):
	event_funcs[event].call_func(args)

func shoot_event(args : Array):
	var type = str(args[0])
	var amount_left = args[1]
	if amount_left <= 0:
		change_selection([
			BASE_SLOT,
			GameSettings.Dynamic.Ammunition[GameSettings.Dynamic.Tank.BaseAmmoType].Reload
		])
		get_node(type).queue_free()
		return
	if amount_left != INF:
		get_node(type).set_left_ammo(amount_left)

func pick_up_event(args : Array):
	var type = str(args[0])
	var amount_left = args[1]
	var slot = get_node_or_null(type)
	if slot == null:
		var new_slot = SLOT_BASE_TSCN.instance()
		new_slot.setup(type, amount_left)
		add_child(new_slot)
	if get_child_count() == 1:
		change_selection([0, 0])
	elif amount_left != INF:
		get_node(type).set_left_ammo(amount_left)

func change_selection(args : Array):
	var new_selection = args[0]
	var reload_time = args[1]
	if get_child_count() >= new_selection:
		get_child(current_selection).set_is_selected(false, reload_time)
	get_child(new_selection).set_is_selected(true, reload_time)
	current_selection = new_selection



func test_all():
	for type in Ammunition.TYPES.size():
		on_special_ammo_event("pick_up", [type, 1])
