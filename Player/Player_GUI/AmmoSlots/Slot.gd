tool
extends Control

const LOADING_COLOR = "70ffff"
const LOADED_COLOR = "66ff80"
export var is_selected: bool = false setget set_is_selected

func _ready():
	$SlotRect/ProgressBar.set_loading_color(Color(LOADING_COLOR))

func set_is_selected(value : bool, reload_time : float = 0):
	is_selected = value
	$SlotRect/ProgressBar.set_loading_color(Color(LOADING_COLOR))
	if is_selected:
		$Tween.remove_all()
		$Tween.interpolate_method(get_node("SlotRect/ProgressBar"), "set_value", 0.0, 1.0, reload_time, Tween.TRANS_LINEAR)
		$Tween.start()
	else:
		$Tween.stop_all()
		$SlotRect/ProgressBar.set_value(0.0)
		
func _on_Tween_tween_all_completed():
	$SlotRect/ProgressBar.set_loading_color(Color(LOADED_COLOR))
		

func setup(type, amount_left):
	name = type
	$SlotRect.type = int(type)

	if amount_left >= INF:
		$Number.text = ""
	else:
		$Number.text = str(amount_left)

func set_left_ammo(amount_left):
	$Number.text = str(amount_left)



