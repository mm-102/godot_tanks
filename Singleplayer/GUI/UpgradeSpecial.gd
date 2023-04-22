extends HBoxContainer

signal value_entered(path, new_value)
var upgrade_path

func setup(_upgrade_path : Array, value = 0):
	upgrade_path = _upgrade_path
	set_list()
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


func set_list():
	for shootable_id in Ammunition.TYPES.size():
		$OptionButton.add_item(Ammunition.get_string_from_type(shootable_id), shootable_id)
	if upgrade_path == ["Ammunition", Ammunition.TYPES.FRAG_BOMB, "Frag", "Type"]:
		for id in [1,2,3]:
			$OptionButton.set_item_disabled(id, true)

func set_value(value = 0):
	$OptionButton.select(value)


func _on_value_change(new_value):
	emit_signal("value_entered", upgrade_path, int(new_value))
	if upgrade_path == ["Tank", "BaseAmmoType"]:
		get_node("/root/Master/Main/Game/Tank").die()


func _on_ResetButton_pressed():
	set_value(GameSettings.SPECIAL_DEFAULT[upgrade_path])
