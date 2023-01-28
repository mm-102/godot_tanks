extends Node2D


export(int, 0, 100) var max_indicators = 5
var tank = null

const indicator_tscn = preload("res://Player/Tank/IndicatorArrow.tscn")

func _ready():
	if get_node("/root/Main").is_multiplayer:
		tank = get_node("/root/Main/Game/Players/" + str(get_node("/root/Main/Game").local_player_id))
		for player_node in get_tree().get_nodes_in_group("Players"):
			if player_node.name != tank.name:
				add_indicated_player(player_node)
			
func add_indicated_player(player):
	var indicator = indicator_tscn.instance()
	indicator.player = tank
	indicator.target_player = player
	add_child(indicator)
