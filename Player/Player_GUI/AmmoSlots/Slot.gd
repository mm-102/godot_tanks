extends Control

enum STATES{NOT_SELECTED, LOADING, LOADED}
export(STATES) var state = STATES.NOT_SELECTED setget set_state
func set_state(new):
	state = new
	state_functions[state].call_func()

var reload_time = 0
onready var progress_bar = $SlotRect/ProgressBar
onready var state_functions = {
	STATES.NOT_SELECTED: funcref(progress_bar, "reset"),
	STATES.LOADING: funcref(progress_bar, "start_loading"),
	STATES.LOADED: funcref(progress_bar, "loaded"),
}



func setup(type, amount_left, _reload_time):
	name = type
	progress_bar.loading_time = _reload_time
	$SlotRect.type = int(type)
	set_left_ammo(amount_left)


func _ready():
	$TouchScreenButton.action = "p_slot_" + str(get_index())



func set_left_ammo(amount_left):
	if amount_left >= INF:
		$Number.text = ""
	else:
		$Number.text = str(amount_left)



