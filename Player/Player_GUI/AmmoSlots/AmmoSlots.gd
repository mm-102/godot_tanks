extends HBoxContainer

const SLOT_BASE_TSCN = preload("res://Player/Player_GUI/AmmoSlots/Slot.tscn")
const P_SLOT = "p_slot_"
var event_funcs = {
	"shoot": funcref(self, "shoot_event"),
	"pick_up": funcref(self, "pick_up_event"),
}
const BASE_SLOT = 0
var MAX_AMMO_TYPES = 0
var current_selection = BASE_SLOT



func _ready():
	$"/root/Main/Settings".connect("apply_changes", self, "apply_settings")
	apply_settings()

func apply_settings():
	var settings = $"/root/Main/Settings".SETTINGS
	MAX_AMMO_TYPES = settings.PLAYER_MAX_AMMO_TYPES

func _input(event):
	choose_slot(event)

func choose_slot(event: InputEvent):
	for slot_num in range(MAX_AMMO_TYPES):
		if event.is_action_pressed(P_SLOT + str(slot_num)) && \
				get_child_count() > slot_num:
			change_selection(slot_num)

func on_special_ammo_event(event, type, amount_left):
	event_funcs[event].call_func(str(type), amount_left)

func shoot_event(type, amount_left):
	if amount_left <= 0:
		change_selection(BASE_SLOT)
		get_node(type).queue_free()
		return
	if amount_left != INF:
		get_node(type).set_left_ammo(amount_left)

func pick_up_event(type, amount_left):
	var slot = get_node_or_null(type)
	if slot == null:
		var new_slot = SLOT_BASE_TSCN.instance()
		new_slot.setup(type, amount_left)
		add_child(new_slot)
	elif amount_left != INF:
		get_node(type).set_left_ammo(amount_left)

func change_selection(new_selection):
	if get_child_count() >= new_selection:
		get_child(current_selection).set_is_selected(false)
	get_child(new_selection).set_is_selected(true)
	current_selection = new_selection



func test_all():
	for type in Ammunition.TYPES.size():
		on_special_ammo_event("pick_up", type, 1)
