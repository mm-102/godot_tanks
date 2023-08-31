extends ColorRect

const LOADING_COLOR = Color("70ffff")
const LOADED_COLOR = Color("66ff80")
var loading_time = 0



func reset():
	$Tween.stop_all()
	set_value(0.0)
	set_loading_color(LOADING_COLOR)


func start_loading():
	reset()
	$Tween.interpolate_method(self, "set_value", 0.0, 1.0, loading_time, Tween.TRANS_LINEAR)
	$Tween.start()

func loaded():
	$Tween.stop_all()
	set_value(1.0)
	set_loading_color(LOADED_COLOR)



func set_value(val):
	material.set_shader_param("value", val)

func set_loading_color(col):
	material.set_shader_param("modulate_bar", col)
