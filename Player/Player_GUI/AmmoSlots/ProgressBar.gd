extends ColorRect

const shader = preload("res://Player/Player_GUI/AmmoSlots/progress_bar.gdshader")

func set_value(var v):
	material.set_shader_param("value", v)

func set_loading_color(var col):
	material.set_shader_param("modulate_bar", col)

func _ready():
	material = ShaderMaterial.new()
	material.shader = shader
	
