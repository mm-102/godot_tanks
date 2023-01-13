extends Node2D

var tank = preload("res://Player/Tank/Tank.tscn")
var tank_template = preload("res://Player/Tank/TankTemplate.tscn")
var empty_gd = preload("res://Empty.gd")
var time_of_last_stance = -INF
var world_stance_buffer: Array
onready var playerS_node = $"%Players"
var local_player_name = ""

signal new_scoreboard_player(name)
signal update_player_score(name, score)
signal delete_scoreboard_player(name)


func _ready():
	#warning-ignore:return_value_discarded
	connect("new_scoreboard_player",get_node("/root/Main/Player_Gui_Layer/GUI"),"_on_new_scoreboard_player")
	#warning-ignore:return_value_discarded
	connect("update_player_score",get_node("/root/Main/Player_Gui_Layer/GUI"),"_on_update_player_score")
	#warning-ignore:return_value_discarded
	connect("delete_scoreboard_player",get_node("/root/Main/Player_Gui_Layer/GUI"),"_on_delete_scoreboard_player")

func update_player_score(player_id, new_score):
	emit_signal("update_player_score", NodePath(str(player_id)), new_score)

func self_initiation(spawn_point):
	var tank_inst = tank.instance()
	tank_inst.add_to_group("ME") # [info] missing "ME" by no persistent
	tank_inst.position = spawn_point
	if local_player_name.empty():
		local_player_name = "You"
	tank_inst.set_display_name(local_player_name)
	add_child_below_node($Players, tank_inst, true)

func create_player(player_id : int, player_name : String, spawn_point):
	var tank_inst = tank_template.instance()
	tank_inst.name = str(player_id)
	if player_name.empty():
		player_name = "Player" + str(player_id)
	tank_inst.position = spawn_point
	tank_inst.set_display_name(player_name)
	$Players.add_child(tank_inst, true)
	emit_signal("new_scoreboard_player", tank_inst.name, tank_inst.player_name)


func player_destroyed(player_id, _position, _rotation, projectile_name):
	get_node("/root/Main/Game/Projectiles/" + projectile_name).die()
	get_node("Players/" + str(player_id)).die()
	create_corpse(player_id, _position, _rotation)
	
	#temp
	emit_signal("delete_scoreboard_player", NodePath(str(player_id)))

func create_corpse(player_id, _position, _rotation):
	var static_body2d = StaticBody2D.new()
	var wall_inst = tank_template.instance()
	static_body2d.name = str(player_id)
	static_body2d.set_collision_layer(4)
	static_body2d.set_collision_mask(3)
	static_body2d.set_position(_position)
	static_body2d.rotation = _rotation
	wall_inst.replace_by(static_body2d, true)
	#static_body2d.get_node("%Tank").disconnect("ready", static_body2d, "_on_Tank_ready")
	static_body2d.get_node("%Sprite").set_frame(4)
	static_body2d.get_node("%Turret").queue_free()
	static_body2d.get_node("%RemoteTransform2D").queue_free()
	static_body2d.get_node("%CanvasLayer").queue_free()
	$Objects.add_child(static_body2d)


func spawn_bullet(player_id, bullet_data):
	var bullet_inst = Ammunition.get_tscn(bullet_data.AT).instance()
	bullet_inst.name = bullet_data.Name
	bullet_inst.position = bullet_data.SP
	bullet_inst.set_linear_velocity(bullet_data.V)
	if player_id == get_tree().get_network_unique_id():
		bullet_inst.player_path = NodePath(Paths.SELF_PLAYER)
	get_node("/root/Main/Game/Projectiles").add_child(bullet_inst)



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