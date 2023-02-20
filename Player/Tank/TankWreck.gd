extends StaticBody2D

var lifeTime
var color

func _ready():
	$"CollisionShape2D/Sprite".modulate = color
	$Tween.interpolate_property($"CollisionShape2D/Sprite", "modulate", null, Color.black, 0.5)
	$Tween.start()
	$LifeTime.start(lifeTime)

func _on_LifeTime_timeout():
	queue_free()


func _on_Tween_tween_all_completed():
	$Particles2D.emitting = false
