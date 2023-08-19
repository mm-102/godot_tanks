extends Node

func start(time):
	$Timer.start(time)
	$Laserbeam_charge.play()
func die():
	queue_free()
