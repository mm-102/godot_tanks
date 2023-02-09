extends Node2D

const CORPSE_LIFE_TIME = 20

var tank = preload("res://Player/Tank/Tank.tscn")
var tank_template = preload("res://Player/Tank/TankTemplate.tscn")
var empty_gd = preload("res://Empty.gd")
var time_of_last_stance = -INF
var world_stance_buffer: Array
var local_player_name = ""
var local_player_id = 0
onready var playerS_node = $"%Players"


func self_initiation(player_data):
	var player_id :int = player_data.ID
	var nick :String = player_data.Nick
	var spawn_point = player_data.SP
	var score = player_data.Score
	var tank_inst = tank.instance()
	local_player_id = player_id
	tank_inst.name = str(player_id)
	tank_inst.position = spawn_point
	if local_player_name.empty():
		local_player_name = "You"
	tank_inst.set_display_name(local_player_name)
	$Players.add_child(tank_inst, true)
	$Players.move_child(tank_inst, 0)

func create_player(player_data):
	var player_id :int = player_data.ID
	var nick :String = player_data.Nick
	var spawn_point = player_data.SP
	var score = player_data.Score
	var tank_inst = tank_template.instance()
	tank_inst.name = str(player_id)
	if nick.empty():
		nick = "Player" + str(player_id)
	tank_inst.position = spawn_point
	tank_inst.set_display_name(nick)
	$Players.add_child(tank_inst, true)
#	if local_player_id:
#		get_node("/root/Main/Game/Players/" + str(local_player_id))\
#		.get_node("%PlayerIndicators")\
#		.add_indicated_player(tank_inst)


func player_destroyed(player_id, _position, _rotation, projectile_name):
	if projectile_name != null:
		var projectile = get_node_or_null("/root/Main/Game/Projectiles/" + projectile_name)
		if projectile != null:
			projectile.die()
	get_node("Players/" + str(player_id)).die()
	create_corpse(player_id, _position, _rotation)

func local_player_destroyed(projectile_name):
	var projectile = get_node_or_null("/root/Main/Game/Projectiles/" + projectile_name)
	if projectile != null:	projectile.die()
	get_node("Tank").die()

func create_corpse(player_id, _position, _rotation):
	var static_body2d = StaticBody2D.new()
	var wall_inst = tank_template.instance()
	wall_inst.remove_from_group("Players")
	wall_inst.add_to_group("Corpse")
	static_body2d.name = str(player_id)
	static_body2d.set_collision_layer(4)
	static_body2d.set_collision_mask(3)
	static_body2d.set_position(_position)
	static_body2d.rotation = _rotation
	wall_inst.replace_by(static_body2d, true)
	static_body2d.get_node("%Sprite").set_frame(4)
	static_body2d.get_node("%Turret").queue_free()
	static_body2d.get_node("%RemoteTransform2D").queue_free()
	static_body2d.get_node("%CanvasLayer").queue_free()
	static_body2d.get_node("%VisibilityNotifier2D").queue_free()
	
	var lifeTime = Timer.new()
	lifeTime.wait_time = CORPSE_LIFE_TIME
	lifeTime.autostart = true
	static_body2d.add_child(lifeTime)
	lifeTime.connect("timeout",static_body2d,"queue_free")
	
	$Objects.add_child(static_body2d)


func spawn_bullet(player_id, bullet_data):
	var bullet_inst = Ammunition.get_tscn(bullet_data.AT).instance()
	bullet_inst.name = bullet_data.Name
#	bullet_inst.position = bullet_data.SP
#	bullet_inst.set_linear_velocity(bullet_data.V)
	bullet_inst.setup_multiplayer(bullet_data)
	if player_id == get_tree().get_network_unique_id():
		bullet_inst.player_path = NodePath(Paths.PLAYERS_N + "/" + str(local_player_id))
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
			if playerS_node.has_node(str(player)) and !playerS_node.get_node(str(player)).is_in_group("ME") and world_stance_buffer[1].WS.has(player):
				playerS_node.get_node(str(player)).template_stance(\
						world_stance_buffer[1].WS[player], \
						world_stance_buffer[2].WS[player], \
						interpolation_factor)
	elif render_time > world_stance_buffer[1].T:
		var extrapolation_factor = \
				float(render_time - world_stance_buffer[0].T) \
				/ float(world_stance_buffer[1].T - world_stance_buffer[0].T) - 1.0
		for player in world_stance_buffer[1].WS.keys():
			if playerS_node.has_node(str(player)) and !playerS_node.get_node(str(player)).is_in_group("ME") and world_stance_buffer[0].WS.has(player):
				playerS_node.get_node(str(player)).template_stance(\
						world_stance_buffer[0].WS[player], \
						world_stance_buffer[1].WS[player], \
						extrapolation_factor)
