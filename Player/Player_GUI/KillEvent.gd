extends HBoxContainer

var killer = "Killer"
var killed = "Killed"
var icon_type = Ammunition.TYPES.BULLET


func _ready():
	if killer.empty():
		$Killer.text = killed
		$Killed.text = "died"
		$Icon.texture = null
		return
	$Killer.text = killer
	$Killed.text = killed
	$Icon.texture = Ammunition.get_box_texture(icon_type)
	

func _on_LifeTime_timeout():
	$Tween.interpolate_property(self, "modulate", null, Color(1.0,1.0,1.0,0.0), 1)
	$Tween.start()


func _on_Tween_tween_all_completed():
	queue_free()
