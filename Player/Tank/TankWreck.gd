extends StaticBody2D

var lifeTime

func _ready():
	$AnimationPlayer.play("explode")
	$LifeTime.start(lifeTime)

func _on_LifeTime_timeout():
	queue_free()
