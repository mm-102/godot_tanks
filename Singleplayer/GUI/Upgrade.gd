extends HBoxContainer
signal value_entered(path, new_value)
var upgrade_path

func setup(_upgrade_path : Array, value = 0):
	upgrade_path = _upgrade_path
	var upgrade_name = ""
	var i = 0
	if upgrade_path[0] == "Ammunition":
		i = 2
		upgrade_name += Ammunition.get_string_from_type(int(_upgrade_path[1])) + " "
	for name_pice in _upgrade_path.slice(i, _upgrade_path.size() - 1):
		upgrade_name += str(name_pice) + " "
	upgrade_name += ": "
	$Name.text = upgrade_name
	set_value(value)

func set_value(value = 0):
	$Slider.value = value
	$Slider.max_value = value * 5
	$Value.value = value


func _on_value_change(new_value):
	emit_signal("value_entered", upgrade_path, new_value)

func _on_Slider_value_changed(value):
	$Value.value = value

func _on_ResetButton_pressed():
	set_value(GameSettings.DEFAULT[upgrade_path])
