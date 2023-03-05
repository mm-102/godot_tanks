extends Node2D

var tank = preload("res://Player/Tank/Tank.tscn")
var tank_template = preload("res://Player/Tank/TankTemplate.tscn")
var tank_wreck = preload("res://Player/Tank/TankWreck.tscn")
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
var CORPSE_LIFE_TIME

onready var players_n = $"%Players"
onready var projectiles_n = $"%Projectiles"
onready var objects_n = $"%Objects"
onready var map_n = $"Map"
onready var main_n = get_node(Dir.MAIN)
onready var clock_n = get_node(Dir.T_CLOCK)




func set_corspses_data(corspes_data):
	for corpse_data in corspes_data:
		create_corpse(corpse_data)

func set_bullets_data(bullets_data):
	for bullet in bullets_data:
		spawn_bullet(bullet.PlayerID, bullet, 0)

func self_initiation(player_data):
	local_player_id = player_data.ID
	var tank_inst = tank.instance()
	var local_player_name = get_node(Dir.MAIN).local_player_name
	tank_inst.setup_multi(player_data, local_player_name)
	players_n.add_child(tank_inst, true)
	players_n.move_child(tank_inst, 0)

func create_template(template_data):
	if !template_data.has("P"):
		return
	var tank_inst = tank_template.instance()
	tank_inst.setup(template_data)
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
	var local_player = get_node("Tank")
	var corpse_data = {
		"ID" : "Tank",
		"Pos" : local_player.position,
		"Rot" : local_player.rotation,
		"LT" : local_player.CORPSE_LIFE_TIME,
		"Color": local_player.color
	}
	local_player.die()
	create_corpse(corpse_data)
	
func ammobox_destroyed(name):
	var obj = get_node_or_null(Dir.MAP+"/AmmoBoxes/"+name)
	if obj != null:
		obj.queue_free()

func create_corpse(corpse_data):
	var wreck_inst = tank_wreck.instance()
	wreck_inst.setup_multi(corpse_data)
	$Objects.add_child(wreck_inst)


func spawn_bullet(player_id, bullet_data, spawn_time):
	var bullet_inst = Ammunition.get_tscn(bullet_data.AT).instance()
	var gd = Ammunition.get_gd_multi(bullet_data.AT)
	if gd != null:
		bullet_inst.set_script(gd)
	var client_clock = clock_n.client_clock
	yield(get_tree().create_timer((spawn_time - client_clock)*0.001), "timeout")
	bullet_inst.setup_multi(bullet_data)
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
	if time_stamp.New == time_stamp.Old:
		return 0.0
	var interpolation_factor : float = \
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
		current_world_stances.remove(0)
		if comming_world_stance != null:
			time_stamp.Old = time_stamp.New 
			time_stamp.New = time_stamp.Latest
			current_world_stances.append(comming_world_stance)
			comming_world_stance = null
