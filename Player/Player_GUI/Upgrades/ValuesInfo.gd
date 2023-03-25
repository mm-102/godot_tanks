extends HBoxContainer

const UPGRADE_ICONS = preload("res://textures/UpgradeIcon/UpgradeKey.gd")
const OBJECT_ICONS = preload("res://Player/Player_GUI/Upgrades/ObjectIcons.gd")
var attribute
var object
var readable_name: String
var upgrade_path: Array = ["Tank", "Speed"]
var add_number = 0
onready var attribute_texture_n = $"%Attribute"
onready var object_texture_n = $"%Object"


func init(_upgrade_path):
	upgrade_path = _upgrade_path
	attribute = _upgrade_path[-1]
	object = _upgrade_path[-2]
	set_name(str(_upgrade_path))
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
	readable_name = _name


func _ready():
	hide()
	set_tooltip(readable_name)
	$Base.set_text(str(GameSettings.DEFAULT[upgrade_path]))
	$Now.set_text(str(GameSettings.DEFAULT[upgrade_path]))
	attribute_texture_n.set_texture(UPGRADE_ICONS.get_image(attribute))
	object_texture_n.set_texture(OBJECT_ICONS.get_image(object))

func add_value(value):
	show()
	$Now.set_text(str(int($Now.get_text()) + value))
	add_number += value
	$Add.set_text(str("(+ ", add_number, ")"))
	
