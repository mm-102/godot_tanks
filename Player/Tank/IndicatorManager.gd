extends Node2D

var max_indicators
var tank = null
var ind_list = []

const indicator_tscn = preload("res://Player/Tank/IndicatorArrow.tscn")

static func compare_distance(a,b):
	return a[1] < b[1]
			
func add_indicated_player(player):
	var indicator = indicator_tscn.instance()
	indicator.name = player.name
	indicator.player = tank
	indicator.target_player = player
	add_child(indicator)

func _on_RefreshTimer_timeout():
	var current_distance_list = []
	for player_node in get_tree().get_nodes_in_group("Players"):
		if !player_node.is_in_group("ME"):
			current_distance_list.push_back([player_node, to_local(player_node.global_position).length()])
	current_distance_list.sort_custom(self, "compare_distance")
	
	var new_ind_list = []
	for i in range(max_indicators):
		if i >= current_distance_list.size():	break
		new_ind_list.push_back(current_distance_list[i][0].name)
		if current_distance_list[i][0].name in ind_list:
			ind_list.erase(current_distance_list[i][0].name)
			continue
		add_indicated_player(current_distance_list[i][0])
		
	for to_delete in ind_list:
		var ind = get_node_or_null(to_delete)
		if ind != null:	ind.queue_free()
		
	ind_list = new_ind_list


func _on_Tank_ready():
	if !get_node(Dir.MASTER).is_multiplayer:
		queue_free()
		return
	tank = get_node("/root/Master/Main/Game/Players/" + str(get_node("/root/Master/Main/Game").local_player_id))
	$"/root/Master/Settings".connect("apply_changes", self, "apply_settings")
	apply_settings()
	$RefreshTimer.start()

func apply_settings():
	max_indicators = $"/root/Master/Settings".SETTINGS.MAX_INDICATOR_COUNT
