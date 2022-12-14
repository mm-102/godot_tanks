extends Node2D

var tank = preload("res://Player/Tank/Tank.tscn")
var tank_template = preload("res://Player/Tank/TankTemplate.tscn")
var empty_gd = preload("res://Empty.gd")
var time_of_last_stance = -INF
var world_stance_buffer: Array
onready var playerS_node = $"%Players"


func self_initiation(spawn_point):
	var tank_inst = tank.instance()
	tank_inst.position = spawn_point
	add_child_below_node($Players, tank_inst, true)

func create_player(player_id):
	var tank_inst = tank_template.instance()
	tank_inst.name = str(player_id)
	$Players.add_child(tank_inst, true)


func player_destroyed(player_id, _position, _rotation):
	get_node("Players/" + str(player_id)).die()
	create_corpse(player_id, _position, _rotation)

func create_corpse(player_id, _position, _rotation):
	var static_body2d = StaticBody2D.new()
	var wall_inst = tank_template.instance()
	static_body2d.name = str(player_id)
	static_body2d.set_collision_mask(3)
	static_body2d.set_position(_position)
	static_body2d.rotation = _rotation
	wall_inst.replace_by(static_body2d, true)
	static_body2d.get_node("%Sprite").set_frame(4)
	static_body2d.get_node("%Turret").queue_free()
	$Objects.add_child(static_body2d)


func spawn_bullet(player_id, bullet_data):
	pass



func add_world_stance(time, world_stance):
	if time_of_last_stance < time:
		time_of_last_stance = time
		world_stance_buffer.append({"T": time, "WS": world_stance})


func _physics_process(_delta: float) -> void:
	var render_time = get_node("/root/Transfer/Clock").client_clock
	if world_stance_buffer.size() <= 1:
		return
	while world_stance_buffer.size() > 2 and render_time > world_stance_buffer[2].T:
		world_stance_buffer.remove(0)
	if world_stance_buffer.size() > 2:
		var interpolation_factor = \
				float(render_time - world_stance_buffer[1].T) \
				/ float(world_stance_buffer[2].T - world_stance_buffer[1].T)
		for player in world_stance_buffer[2].WS.keys():
			if playerS_node.has_node(str(player)) and world_stance_buffer[1].WS.has(player):
				playerS_node.get_node(str(player)).template_stance(\
						world_stance_buffer[1].WS[player], \
						world_stance_buffer[2].WS[player], \
						interpolation_factor)
#	elif render_time > world_stance_buffer[1].T:
#		var extrapolation_factor = float(render_time - world_stance_buffer[0].T) / float(world_stance_buffer[1].T - world_stance_buffer[0].T) - 1.0
#		for player in world_stance_buffer[1].keys():
#			if !world_stance_buffer[0].has(player):
#				continue
#			if playerS_node.has_node(str(player)):
#				var position_delta = world_stance_buffer[1][player]["Location"]["P"] - world_stance_buffer[0][player]["Location"]["P"]
#				var new_position = world_stance_buffer[1][player]["Location"]["P"] + position_delta * extrapolation_factor
#				playerS_node.get_node(str(player)).set_position(new_position)
