extends Node

func start(time):
	$Timer.start(time)

func die():
	queue_free()
