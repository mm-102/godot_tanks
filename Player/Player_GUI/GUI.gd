extends MarginContainer


onready var Numbers = {
	Ammunition.TYPES.ROCKET : $"HBoxContainer/RocketCounter/Background/Number",
	Ammunition.TYPES.FRAG_BOMB : $"HBoxContainer/FragBombCounter/Background/Number"
}

func _on_special_ammo_change(type, amount_left):
	Numbers[type].text = str(amount_left)
