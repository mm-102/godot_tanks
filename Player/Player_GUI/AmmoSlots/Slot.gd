tool
extends Control

const LOADING_COLOR = "70ffff"
const LOADED_COLOR = "66ff80"
export var is_selected: bool = false setget set_is_selected


func set_is_selected(value : bool, reload_time : float = 0):
	is_selected = value
	if is_selected == true:
		get_node("Background").tint_progress = LOADING_COLOR
		$Tween.remove_all()
		$Tween.interpolate_property(get_node("Background"), "value", 0, 100, reload_time, Tween.TRANS_LINEAR)
		$Tween.start()
	else:
		$Tween.stop_all()
		get_node("Background").value = 0
		
func _on_Tween_tween_all_completed():
	get_node("Background").tint_progress = LOADED_COLOR
		

func setup(type, amount_left):
	name = type
	get_node("Background/Icon").set_texture(Ammunition.get_box_texture(int(type)))
	if int(type) == Ammunition.TYPES.BULLET:
		get_node("Background/Icon").set_custom_minimum_size(Vector2(7, 7))
	if amount_left >= INF:
		get_node("Background/Number").text = ""
	else:
		get_node("Background/Number").text = str(amount_left)

func set_left_ammo(amount_left):
	get_node("Background/Number").text = str(amount_left)



