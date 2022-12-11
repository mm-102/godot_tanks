extends MarginContainer

var current_type = Ammunition.TYPES.BULLET

const selection_color = "70ffff"
const base_color = "ffffff"

onready var Numbers = {
	Ammunition.TYPES.ROCKET : $"HBoxContainer/RocketCounter/Background/Number",
	Ammunition.TYPES.FRAG_BOMB : $"HBoxContainer/FragBombCounter/Background/Number"
}

onready var Backgrounds = {
	Ammunition.TYPES.BULLET : $"HBoxContainer/BulletCounter/Background",
	Ammunition.TYPES.ROCKET : $"HBoxContainer/RocketCounter/Background",
	Ammunition.TYPES.FRAG_BOMB : $"HBoxContainer/FragBombCounter/Background"
}


func _ready():
	Backgrounds[current_type].modulate = selection_color

func _on_special_ammo_change(type, amount_left):
	Numbers[type].text = str(amount_left)

func _on_special_ammo_type_change(new_type):
	Backgrounds[current_type].modulate = base_color
	Backgrounds[new_type].modulate = selection_color
	
	current_type = new_type
