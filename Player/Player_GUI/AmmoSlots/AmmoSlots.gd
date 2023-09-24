extends PanelContainer

const SLOT_TSCN = preload("res://Player/Player_GUI/AmmoSlots/Slot.tscn")
const INPUT_BASE_NAME = "p_slot_"
const BASE_SLOT = 0
var event_funcs = {
	"shoot": funcref(self, "shoot_event"),
	"pick_up": funcref(self, "pick_up_event"),
	"change_selection" : funcref(self, "change_selection"),
	"reset_autoload" : funcref(self, "reset_autoload")
}
var current_selection = BASE_SLOT
onready var ammo_autoload = $"Autoload"
var autoload_clip_res: AmmunitionSlotObj setget set_autoload_clip
func set_autoload_clip(new):
	autoload_clip_res = new
	ammo_autoload.ammo_autoload_res = autoload_clip_res
var ammunition_clips: Dictionary setget set_ammunition_clips
func set_ammunition_clips(new):
	ammunition_clips = new
	init_slots()



func _init():
	GlobalSignals.connect("new_ammunition_set", self, "_on_new_ammunition_set")

func _on_new_ammunition_set(_autoload_clip_res, _ammunition_clips):
	set_autoload_clip(_autoload_clip_res)
	set_ammunition_clips(_ammunition_clips)

func init_slots():
	for child in $AmmoSlots.get_children():
		if child is Node:
			child.queue_free()
	yield(get_tree(), "idle_frame")
	
	ammo_autoload.ammo_base_res = ammunition_clips[INPUT_BASE_NAME + str(BASE_SLOT)]
	for ammo_clip_keys in ammunition_clips:
		var slot_inst = SLOT_TSCN.instance()
		slot_inst.ammunition_clip_res = ammunition_clips[ammo_clip_keys]
		$AmmoSlots.add_child(slot_inst)





func on_special_ammo_event(event, args : Array):
	event_funcs[event].call_func(args)

func shoot_event(args : Array):
	var type = str(args[0])
	var amount_left = args[1]
	if amount_left != INF:
		$AmmoSlots.get_node(type).set_left_ammo(amount_left)
		
	if amount_left > 0:
		change_selection([
			current_selection,
			GameSettings.Dynamic.Ammunition[int(type)].Reload
		])
		return
		
	if int(type) != GameSettings.Dynamic.Tank.BaseAmmoType:
		$AmmoSlots.get_node(type).queue_free()
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

func pick_up_event(args : Array):
	var type = str(args[0])
	var amount_left = args[1]
	var slot = $AmmoSlots.get_node_or_null(type)
#	if slot == null:
#		var new_slot = SLOT_BASE_TSCN.instance()
#		new_slot.setup(type, amount_left)
#		$AmmoSlots.add_child(new_slot)
#		if $AmmoSlots.get_child_count() == 1:
#			change_selection([0, GameSettings.Dynamic.Ammunition[GameSettings.Dynamic.Tank.BaseAmmoType].Reload \
#			* GameSettings.Dynamic.Tank.AutoloadTimeMultiplier])
#			var autoload_slot = SLOT_BASE_TSCN.instance()
#			autoload_slot.setup(type, INF)
#			autoload_slot.name = "Autoload"
#			add_child(autoload_slot)
#			move_child(autoload_slot, 0)
#	if amount_left != INF:
#		$AmmoSlots.get_node(type).set_left_ammo(amount_left)

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
