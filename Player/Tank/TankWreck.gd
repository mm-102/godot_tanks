extends StaticBody2D

var life_time = GameSettings.Dynamic.Wreck.LifeTime
var color := Color.black
var s = GameSettings.Dynamic.Wreck


func setup_multi(corpse_data):
	life_time = s.LifeTime
	name = str(corpse_data.ID)
	set_position(corpse_data.Pos)
	rotation = corpse_data.Rot
	color = corpse_data.Color
	if corpse_data.has("LT"):
		life_time = corpse_data.LT


func _ready():
	$CollisionShape2D/Sprite.modulate = color
	$LifeTime.start(life_time)
	$Tween.interpolate_property($"CollisionShape2D/Sprite", "modulate", null, Color.black, 0.5)
	$Tween.start()
	

func highlight(_global_point):
	$Highlight.highlight()


func _on_LifeTime_timeout():
	queue_free()


func _on_Tween_tween_all_completed():
	$Particles2D.emitting = false
