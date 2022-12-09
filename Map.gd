extends Node2D

var tank = preload("res://Player/Tank/Tank.tscn")
var tank_template = preload("res://Player/Tank/TankTemplate.tscn")
var world_stance_buffer: Array = [{"T": -INF}]
onready var playerS_node = $"%Players"


func self_initiation():
	var tank_inst = tank.instance()
	add_child_below_node($Players, tank_inst, true)

func create_player(player_id):
	var tank_inst = tank_template.instance()
	tank_inst.name = str(player_id)
	$Players.add_child(tank_inst, true)


func add_world_stance(world_stance):
	if world_stance_buffer.back().T < world_stance.T:
		world_stance_buffer.append(world_stance)

func process_world_stance(playerS_stance):
	pass

func _physics_process(_delta: float) -> void:
	var render_time = get_node("/root/Transfer/Clock").client_clock
	if world_stance_buffer.size() <= 1:
		return
	while world_stance_buffer.size() > 2 and render_time > world_stance_buffer[2]["T"]:
		world_stance_buffer.remove(0)
	if world_stance_buffer.size() > 2:
		var interpolation_factor = \
				float(render_time - world_stance_buffer[1]["T"]) \
				/ float(world_stance_buffer[2]["T"] - world_stance_buffer[1]["T"])
		world_stance_buffer.erase("T")
		for player in world_stance_buffer[2].keys():
			if playerS_node.has_node(str(player)) and world_stance_buffer[1].has(player):
				playerS_node.get_node(str(player)).template_stance(world_stance_buffer[1][player], world_stance_buffer[2][player], interpolation_factor)
#	elif render_time > world_stance_buffer[1]["T"]:
#		var extrapolation_factor = float(render_time - world_stance_buffer[0]["T"]) / float(world_stance_buffer[1]["T"] - world_stance_buffer[0]["T"]) - 1.0
#		for player in world_stance_buffer[1].keys():
#			if !world_stance_buffer[0].has(player):
#				continue
#			if playerS_node.has_node(str(player)):
#				var position_delta = world_stance_buffer[1][player]["Location"]["P"] - world_stance_buffer[0][player]["Location"]["P"]
#				var new_position = world_stance_buffer[1][player]["Location"]["P"] + position_delta * extrapolation_factor
#				playerS_node.get_node(str(player)).set_position(new_position)
