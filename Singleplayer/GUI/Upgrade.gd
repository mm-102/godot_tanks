extends HBoxContainer
signal text_entered(path, new_text)
var upgrade_path

func setup(_upgrade_path, value = null):
	upgrade_path = _upgrade_path
	var upgrade_name = ""
	for name_pice in _upgrade_path:
		upgrade_name += str(name_pice) + " "
	upgrade_name += ": "
	$Name.text = upgrade_name
	$Value.text = str(value)


func _on_Value_text_entered(new_text):
	emit_signal("text_entered", upgrade_path, new_text)
