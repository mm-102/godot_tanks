extends Button

signal upgrade_selected(upgrade_path)
const UPGRADE_ICONS = preload("res://textures/UpgradeIcon/UpgradeKey.gd")
const OBJECT_ICONS = preload("res://Player/Player_GUI/Upgrades/ObjectIcons.gd")
var style_box = preload("res://Player/Player_GUI/Upgrades/Upgrade.tres")
var upgrade_path: Array
var attribute
var object
onready var attribute_texture_n = $"%Attribute"
onready var object_texture_n = $"%Object"


func init(_upgrade_path, state = "Normal"):
	upgrade_path = _upgrade_path
	match state:
		"Normal":
			attribute = _upgrade_path[-1]
			object = _upgrade_path[-2]
		"Winner":
			attribute = _upgrade_path[-2]
			object = _upgrade_path[-1]
	create_name(_upgrade_path)

func create_name(_upgrade_path):
	var _name = ""
	for pice in _upgrade_path:
		if typeof(pice) == TYPE_STRING && pice == "Ammunition":
			continue
		if typeof(pice) == TYPE_INT or typeof(pice) == TYPE_REAL:
			pice = Ammunition.get_string_from_type(pice)
		_name += str(pice) + " "
	_name[-1] = ""
	set_name(_name)

func _ready():
	set_tooltip(name)
	attribute_texture_n.set_texture(UPGRADE_ICONS.get_image(attribute))
	object_texture_n.set_texture(OBJECT_ICONS.get_image(object))

func disable(value):
	set_disabled(value)


func _on_Upgrade_draw():
	if get_draw_mode() == DRAW_DISABLED:
		$Cross.show()
	else:
		$Cross.hide()

func _on_Upgrade_pressed():
	emit_signal("upgrade_selected", upgrade_path)
