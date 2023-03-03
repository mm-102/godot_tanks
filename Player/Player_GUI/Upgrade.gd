extends VBoxContainer

signal upgrade_selected(upgrade_path)
var upgrade_path: Array
onready var label_name = $Name
onready var button = $Button



func init(_upgrade_path):
	upgrade_path = _upgrade_path
	var _name = ""
	for pice in _upgrade_path:
		_name += str(pice) + " "
	_name[-1] = ""
	set_name(_name)

func _ready():
	label_name.text = name

func disable(value):
	button.set_disabled(value)

func _on_TextureRect_pressed():
	emit_signal("upgrade_selected", upgrade_path)
