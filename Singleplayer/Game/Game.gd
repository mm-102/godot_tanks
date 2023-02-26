extends Node2D

onready var player = $Tank

func _ready():
	var local_player_name = get_node(Dir.MAIN).local_player_name
	if local_player_name.empty():
		local_player_name = "You"
	player.set_display_name(local_player_name)
