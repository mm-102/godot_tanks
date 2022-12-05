extends Area2D

export(Ammunition.TYPES) var type = Ammunition.TYPES.ROCKET



func _on_AmmoBox_body_entered(player):
	player.ammo_type = type
	player.special_ammo_left += 1
	queue_free()
	
func _ready():
	var sprite = $TypeSprite
	sprite.texture = Ammunition.get_box_texture(type)
	
