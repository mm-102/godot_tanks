extends GDScript

const ICONS = {
	"Tank": preload("res://textures/box_texture/tank.svg"),
	"Wreck": preload("res://textures/box_texture/wreck.svg"),
	0: preload("res://textures/box_texture/bullet_box.png"),
	1: preload("res://textures/box_texture/rocket_box.png"),
	2: preload("res://textures/box_texture/frag_bomb_box.png"),
	"Frag": preload("res://textures/UpgradeIcon/cluster-bomb.svg"),
	3: preload("res://textures/box_texture/laser_box.png"),
	4: preload("res://textures/box_texture/laser_bullet_box.png"),
	5: preload("res://textures/box_texture/fireball_box.png"),
}

const TANK = "res://textures/tank_base.png"

static func get_image(attribute):
	if attribute == null:
		return
	if !ICONS.has(attribute):
		return preload("res://icon.png")
	return ICONS[attribute]
