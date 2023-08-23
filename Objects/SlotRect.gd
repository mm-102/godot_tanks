tool
extends ColorRect

enum BORDER_TYPES{DEFAULT, SUPER}
const SUPER_TYPES = [
	Ammunition.TYPES.LASER,
	Ammunition.TYPES.FIREBALL,
]

const BORDER_DICT = {
	BORDER_TYPES.DEFAULT: preload("res://Objects/gray_sampler.tres"),
	BORDER_TYPES.SUPER: preload("res://Objects/rainbow_sampler.tres"),
}


export(Ammunition.TYPES) var type setget set_type
func set_type(new):
	type = new
	$TypeRect.texture = Ammunition.get_box_texture(type)
	if type in SUPER_TYPES:
		set_border(BORDER_TYPES.SUPER)
	else:
		set_border(BORDER_TYPES.DEFAULT)

export(Vector2) var icon_scale = Vector2(0.75, 0.75) setget set_icon_scale
func set_icon_scale(new):
	icon_scale = new
	$TypeRect.rect_size = icon_scale * rect_size
	$TypeRect.rect_position = (Vector2.ONE - icon_scale) * rect_size * 0.5



func _ready():
	set_icon_scale(icon_scale)

func set_border(border_type):
	material.set_shader_param("border_ramp", BORDER_DICT[border_type])


