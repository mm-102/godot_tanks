extends MarginContainer

var current_type = Ammunition.TYPES.BULLET

const selection_color = "70ffff"
const base_color = "ffffff"

onready var Numbers = {
	Ammunition.TYPES.ROCKET : $"Ammunition/RocketCounter/Background/Number",
	Ammunition.TYPES.FRAG_BOMB : $"Ammunition/FragBombCounter/Background/Number"
}

onready var Backgrounds = {
	Ammunition.TYPES.BULLET : $"Ammunition/BulletCounter/Background",
	Ammunition.TYPES.ROCKET : $"Ammunition/RocketCounter/Background",
	Ammunition.TYPES.FRAG_BOMB : $"Ammunition/FragBombCounter/Background"
}


func _ready():
	Backgrounds[current_type].modulate = selection_color

func _on_special_ammo_change(type, amount_left):
	Numbers[type].text = str(amount_left)

func _on_special_ammo_type_change(new_type):
	Backgrounds[current_type].modulate = base_color
	Backgrounds[new_type].modulate = selection_color
	
	current_type = new_type
