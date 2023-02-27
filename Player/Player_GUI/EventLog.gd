extends VBoxContainer

const kill_event_tscn = preload("res://Player/Player_GUI/KillEvent.tscn")


func on_kill_event(killer : String, killed : String, ammo_type : int):
	var event = kill_event_tscn.instance()
	event.killer = killer
	event.killed = killed
	event.icon_type = ammo_type
	add_child(event)
