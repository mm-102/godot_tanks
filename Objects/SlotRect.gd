tool
extends ColorRect

export(Vector2) var icon_scale = Vector2(0.75, 0.75) setget set_icon_scale
func set_icon_scale(new):
	icon_scale = new
	$TypeRect.rect_size = icon_scale * rect_size
	$TypeRect.rect_position = (Vector2.ONE - icon_scale) * rect_size * 0.5


func _ready():
	set_icon_scale(icon_scale)

func set_border(border_type):
	material.set_shader_param("border_ramp", owner.BORDER_DICT[border_type])


