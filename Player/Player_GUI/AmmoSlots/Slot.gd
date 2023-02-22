tool
extends Control

const SELECTION_COLOR = "70ffff"
const BASE_COLOR = "ffffff"
export var is_selected: bool = false setget set_is_selected


func set_is_selected(value: bool):
	is_selected = value
	if is_selected == true:
		get_node("Background").modulate = SELECTION_COLOR
	else:
		get_node("Background").modulate = BASE_COLOR
		

func setup(type, amount_left):
	name = type
	get_node("Background/Icon").set_texture(Ammunition.get_box_texture(int(type)))
	get_node("Background/Number").text = str(amount_left)

func set_left_ammo(amount_left):
	get_node("Background/Number").text = str(amount_left)
