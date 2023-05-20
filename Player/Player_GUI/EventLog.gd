extends VBoxContainer

const kill_event_tscn = preload("res://Player/Player_GUI/KillEvent.tscn")
var players_nicks: Dictionary

func setup_player_names(PlayerSData):
	for player in PlayerSData:
		players_nicks[player.ID] = player.Nick

func on_kill_event(killer : String, killed : String, ammo_type : int):
	var event = kill_event_tscn.instance()
	event.killer = players_nicks[int(killer)]
	event.killed = players_nicks[int(killed)]
	event.icon_type = ammo_type
	add_child(event)
