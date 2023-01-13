extends Area2D

export(Ammunition.TYPES) var type = Ammunition.TYPES.ROCKET



func _on_AmmoBox_body_entered(body):
	if !body.is_in_group("Players"):
		return
	if body.is_in_group("ME"):
		body.special_ammo[type] += 1
		body.emit_signal("special_ammo_change", type, body.special_ammo[type])
	queue_free()
	
func _ready():
	var sprite = $TypeSprite
	sprite.texture = Ammunition.get_box_texture(type)
