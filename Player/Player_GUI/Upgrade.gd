extends VBoxContainer

signal upgrade_selected(upgrade_path)
var upgrade_path: Array
onready var label_name = $Name
onready var button = $Button


func init(_upgrade_path):
	upgrade_path = _upgrade_path
	var _name = ""
	for pice in _upgrade_path:
		if typeof(pice) == TYPE_INT or typeof(pice) == TYPE_REAL:
			match pice:
				0: pice = "Bullet"
				1: pice = "Rocket"
				2: pice = "Frag Bomb"
				3: pice = "Laser Beam"
				4: pice = "Laser Bullet"
				5: pice =  "Fire Ball"
		_name += str(pice) + " "
	_name[-1] = ""
	set_name(_name)

func _ready():
	label_name.text = name

func disable(value):
	if value == true:
		label_name.set_modulate(Color(1,1,1,0.3))
	else:
		label_name.set_modulate(Color(1,1,1,1))
	button.set_disabled(value)

func _on_TextureRect_pressed():
	emit_signal("upgrade_selected", upgrade_path)
