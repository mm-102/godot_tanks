extends ColorRect
tool

const shader = preload("res://Objects/ammo_box_shader.gdshader")
const rainbow_sampler = preload("res://Objects/rainbow_sampler.tres")
const gray_sampler = preload("res://Objects/gray_sampler.tres")

export(Ammunition.TYPES) var type setget set_type
export(Vector2) var icon_scale = Vector2(0.75, 0.75) setget set_icon_scale

const super_types = [
	Ammunition.TYPES.LASER,
	Ammunition.TYPES.FIREBALL,
]

func set_icon_scale(var s):
	icon_scale = s
	$TypeRect.rect_size = icon_scale * rect_size
	$TypeRect.rect_position = (Vector2.ONE - icon_scale) * rect_size * 0.5


func set_type(var t):
	type = t
	if Engine.is_editor_hint():
		_set_type_when_ready()
	
func _set_type_when_ready():
	$TypeRect.texture = Ammunition.get_box_texture(type)
	if type in super_types:
		material.set_shader_param("border_ramp",rainbow_sampler)
	
	else:
		material.set_shader_param("border_ramp",gray_sampler)

func _ready():
	material = ShaderMaterial.new()
	material.shader = shader
	_set_type_when_ready()
	set_icon_scale(icon_scale)
