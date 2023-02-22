extends Area2D

export(Ammunition.TYPES) var type = Ammunition.TYPES.ROCKET
const bigger_types = [
	Ammunition.TYPES.FRAG_BOMB,
	Ammunition.TYPES.FIREBALL,
]


func _on_AmmoBox_body_entered(body):
	if !body.is_in_group("Players"):
		return
	if body.is_in_group("ME"):
		if body.pick_up_ammo_box(type):
			queue_free()
	
func _ready():
	var sprite = $TypeSprite
	if type in bigger_types:
		sprite.set_scale(Vector2(3,3))
	sprite.texture = Ammunition.get_box_texture(type)
