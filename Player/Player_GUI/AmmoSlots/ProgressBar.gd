extends ColorRect

const LOADING_COLOR = Color("70ffff")
const LOADED_COLOR = Color("66ff80")

const STATES = AmmunitionSlotObj.STATES
export(STATES) var state = STATES.NOT_SELECTED setget set_state
func set_state(new):
	state = new 
	state_functions[state].call_func()
var state_functions = {
	STATES.NOT_SELECTED: funcref(self, "reset"),
	STATES.LOADING: funcref(self, "start_loading"),
	STATES.LOADED: funcref(self, "loaded"),
}
var loading_time = 0





func reset():
	$Tween.stop_all()
	set_value(0.0)
	set_loading_color(LOADING_COLOR)
 
func start_loading():
	reset()
	$Tween.interpolate_method(self, "set_value", 0.0, 1.0, loading_time, Tween.TRANS_LINEAR)
	$Tween.start()

func loading_from_time(init_value, time):
	reset()
	$Tween.interpolate_method(self, "set_value", init_value, 1.0, time, Tween.TRANS_LINEAR)
	$Tween.start()

func loaded():
	$Tween.stop_all()
	set_value(1.0)
	set_loading_color(LOADED_COLOR)




func set_value(val):
	material.set_shader_param("value", val)

func set_loading_color(col):
	material.set_shader_param("modulate_bar", col)

func _on_Tween_tween_all_completed():
	set_state(STATES.LOADED)
