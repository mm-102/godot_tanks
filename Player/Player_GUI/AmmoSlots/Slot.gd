extends Control
class_name Slot

enum STATES{NOT_SELECTED, LOADING, LOADED}
export(STATES) var state = STATES.NOT_SELECTED setget set_state
func set_state(new):
	state = new
	state_functions[state].call_func()


enum BORDER_TYPES{DEFAULT, SUPER}
const SUPER_TYPES = [
	Ammunition.TYPES.LASER,
	Ammunition.TYPES.FIREBALL,
]
const BORDER_DICT = {
	BORDER_TYPES.DEFAULT: preload("res://Objects/gray_sampler.tres"),
	BORDER_TYPES.SUPER: preload("res://Objects/rainbow_sampler.tres"),
}
const EMPTY = -1
export(int) var type = -1 setget set_type
func set_type(new):
	type = new
	if type == EMPTY:
		set_inside(true)
		return
	else:
		set_inside(false)
	$SlotRect/TypeRect.texture = Ammunition.get_box_texture(type)
	if type in SUPER_TYPES:
		$SlotRect.set_border(BORDER_TYPES.SUPER)
	else:
		$SlotRect.set_border(BORDER_TYPES.DEFAULT)


onready var progress_bar = $SlotRect/ProgressBar
onready var state_functions = {
	STATES.NOT_SELECTED: funcref(progress_bar, "reset"),
	STATES.LOADING: funcref(progress_bar, "start_loading"),
	STATES.LOADED: funcref(progress_bar, "loaded"),
}
var ammunition_clip_res: AmmunitionSlotObj = null setget set_ammunition_clip_res
func set_ammunition_clip_res(new):
	ammunition_clip_res = new
	ammunition_clip_res.connect("changed", self, "_on_ammunition_clip_res_changed")



func setup(type, amount_left, _reload_time):
	name = type
	progress_bar.loading_time = _reload_time
	$SlotRect.type = int(type)
	set_amount_left_text(amount_left)


func _ready():
	set_type(EMPTY)
	$TouchScreenButton.action = "p_slot_" + str(get_index())

func set_inside(is_empty: bool):
	$SlotRect/TypeRect.visible = not is_empty
	$Number.visible = not is_empty

func set_amount_left_text(amount_left):
	if amount_left >= INF:
		$Number.text = ""
	else:
		$Number.text = str(amount_left)


func _on_ammunition_clip_res_changed():
	#print(ammunition_clip_res.state)
	set_state(ammunition_clip_res.state)
	print(state)



func _on_Tween_tween_all_completed():
	set_state(STATES.LOADED)
