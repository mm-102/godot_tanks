extends Node2D

const CORPSE_LIFE_TIME = 20

var tank = preload("res://Player/Tank/Tank.tscn")
var tank_template = preload("res://Player/Tank/TankTemplate.tscn")
var empty_gd = preload("res://Empty.gd")

var comming_world_stance = null
var time_stamp = {
	"Old": -INF,
	"New": -INF,
	"Latest": -INF,
}
var current_world_stances: Array 

var world_stance_buffer: Array
var local_player_id = 0
var interpolation_factor = 0

onready var players_n = $"%Players"
onready var projectiles_n = $"%Projectiles"
onready var objects_n = $"%Objects"
onready var map_n = $"Map"
onready var main_n = get_node(Dir.MAIN)
onready var clock_n = get_node(Dir.T_CLOCK)



func set_corspses_data(corspes_data):
	for corpse_data in corspes_data:
		create_corpse(corpse_data)


func self_initiation(player_data):
	var player_id :int = player_data.ID
#	var nick :String = player_data.Nick
	var spawn_point = player_data.P
	var tank_inst = tank.instance()
	local_player_id = player_id
	tank_inst.name = str(player_id)
	tank_inst.position = spawn_point
	var local_player_name = get_node(Dir.MAIN).local_player_name
	if local_player_name.empty():
		local_player_name = "You"
	tank_inst.set_display_name(local_player_name)
	players_n.add_child(tank_inst, true)
	players_n.move_child(tank_inst, 0)

func create_template(player_data):
	if !player_data.has("P"):
		return
	var tank_inst = tank_template.instance()
	tank_inst.setup(player_data)
	players_n.add_child(tank_inst, true)
#	if local_player_id:
#		get_node("/root/Main/Game/Players/" + str(local_player_id))\
#		.get_node("%PlayerIndicators")\
#		.add_indicated_player(tank_inst)


func player_destroyed(corpse_data, projectile_name):
	if projectile_name != null:
		var projectile = projectiles_n.get_node_or_null(projectile_name)
		if projectile != null:
			projectile.die()
	players_n.get_node(str(corpse_data.ID)).die()
	create_corpse(corpse_data)

func local_player_destroyed(projectile_name):
	var projectile = projectiles_n.get_node_or_null(projectile_name)
	if projectile != null:	projectile.die()
	get_node("Tank").die()

func create_corpse(corpse_data):
	var static_body2d = StaticBody2D.new()
	var wall_inst = tank_template.instance()
	wall_inst.remove_from_group("Players")
	wall_inst.remove_from_group("Template")
	wall_inst.add_to_group("Corpse")
	static_body2d.name = str(corpse_data.ID)
	static_body2d.set_collision_layer(4)
	static_body2d.set_collision_mask(3)
	static_body2d.set_position(corpse_data.Pos)
	static_body2d.rotation = corpse_data.Rot
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
	
	objects_n.add_child(static_body2d)


func spawn_bullet(player_id, bullet_data, spawn_time):
	var bullet_inst = Ammunition.get_tscn(bullet_data.AT).instance()
	var gd = Ammunition.get_gd_multi(bullet_data.AT)
	if gd != null:
		bullet_inst.set_script(gd)
	var client_clock = clock_n.client_clock
	yield(get_tree().create_timer((spawn_time - client_clock)*0.001), "timeout")
	bullet_inst.setup_multiplayer(bullet_data)
	if player_id == get_tree().get_network_unique_id():
		bullet_inst.player_path = NodePath(Dir.PLAYERS + "/" + str(local_player_id))
	projectiles_n.add_child(bullet_inst, true)

func update_bounce_bullet(bulletS_state, time):
	if time < clock_n.get_time():
		print("[GAME]: Recived bullet bounce data too old.")
		return
	for bullet_state in bulletS_state:
		var bullet_n = projectiles_n.get_node_or_null(bullet_state.Name)
		if bullet_n == null:
			return
		bullet_n.append_new_state(bullet_state, time - clock_n.get_time())


func interpolation_factor() -> float:
	var actual_time = Transfer.get_time()
	var interpolation_factor = \
			float(actual_time - time_stamp.Old) \
			/ float(time_stamp.New - time_stamp.Old)
	return interpolation_factor


func add_world_stance(time, world_stance):
	if time_stamp.Latest >= time:
		return
	time_stamp.Latest = time
	if current_world_stances.size() == 3:
		comming_world_stance = world_stance
	else:
		time_stamp.Old = time_stamp.New 
		time_stamp.New = time
		current_world_stances.append(world_stance)

func _physics_process(_delta: float) -> void:
	var render_time = Transfer.get_time()
	while current_world_stances.size() > 2 and render_time > time_stamp.New:
		time_stamp.Old = time_stamp.New 
		current_world_stances.remove(0)
		if comming_world_stance != null:
			time_stamp.New = time_stamp.Latest
			current_world_stances.append(comming_world_stance)
			comming_world_stance = null
