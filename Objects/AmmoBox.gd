extends Area2D

export(Ammunition.TYPES) var type = Ammunition.TYPES.ROCKET



func _on_AmmoBox_body_entered(player):
	player.ammo_type = type
	player.special_ammo[type] += 1
	player.emit_signal("special_ammo_change", type, player.special_ammo[type])
	queue_free()
	
func _ready():
	var sprite = $TypeSprite
	sprite.texture = Ammunition.get_box_texture(type)
	
