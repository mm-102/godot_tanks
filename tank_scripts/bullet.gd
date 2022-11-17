extends RigidBody2D

var _time = 10

func _ready():
	var timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start(_time)

func _on_timer_timeout():
	die()

func die():
	get_parent().get_parent().get_child(0).ammo_left += 1
	get_parent().queue_free()
