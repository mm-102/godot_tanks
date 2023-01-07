extends Node


const PORT = 42521
var ip = null

const MAP_PATH_OUT = "/root/Main/Map"
onready var time_diff_timer_node = $"%TimeDiffTimer"
onready var clock_node = $"%Clock"
onready var map_node
var network : NetworkedMultiplayerENet = null


#---------- SERVER CREATION ----------
func _ready():
	_connect_to_server()

func _connect_to_server():
	network = NetworkedMultiplayerENet.new()
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("server_disconnected", self, "_server_disconnected")
	network.create_client(ip, PORT)
	get_tree().set_network_peer(network)
	print("[Transfer]: Connecting to server...")

func _server_disconnected():
	print("[Transfer]: Connection lost")
	$"/root/Main".exit_to_menu()

func _on_connection_failed():
	print("[Transfer]: Faild to connect")

func _on_connection_succeeded():
	print("[Transfer]: Succesfully connected")
	fetch_init_data()
	clock_node.determine_begining_time_diff()
	time_diff_timer_node.start()
	$"/root/Main/Menu".queue_free()

#---- INIT DATA ----
func fetch_init_data():
	map_node = $"/root/Main/Map"
	rpc_id(1, "recive_init_data", map_node.local_player_name)

remote func recive_init_data(spawn_point, playerS_name, playerS_corpseS, playerS_score):
	map_node = $"/root/Main/Map"
	if !get_tree().get_rpc_sender_id() == 1:
		return
	map_node.self_initiation(spawn_point)
	for player in playerS_name:
		map_node.create_player(player.ID, player.PlayerName)
	for corpse_data in playerS_corpseS:
		map_node.create_corpse(corpse_data.Name, corpse_data.P, corpse_data.R)
	for score_data in playerS_score:
		map_node.update_player_score(score_data.Name, score_data.Score)

#---------- CORE GAME MECHANIC ----------

remote func recive_player_destroyed(player_id, position, rotation, projectile_name):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	if player_id == get_tree().get_network_unique_id():
		$"/root/Main".exit_to_menu()
		return
	map_node = $"/root/Main/Map"
	map_node.player_destroyed(player_id, position, rotation, projectile_name)

func fetch_stance(player_stance: Dictionary):
	rpc_unreliable_id(1, "recive_stance", player_stance)

func fetch_shoot(player_stance, shoot_type):
	rpc_unreliable_id(1, "recive_shoot", player_stance, shoot_type)

remote func recive_world_stance(time, playerS_stance):
	map_node = $"/root/Main/Map"
	if !get_tree().get_rpc_sender_id() == 1:
		return
	map_node.add_world_stance(time, playerS_stance)

remote func recive_shoot(player_id, bullet_data):
	map_node = $"/root/Main/Map"
	if !get_tree().get_rpc_sender_id() == 1:
		return
	map_node.spawn_bullet(player_id, bullet_data)

remote func recive_new_player(player_id: int, player_name : String):
	map_node = $"/root/Main/Map"
	if !get_tree().get_rpc_sender_id() == 1:
		return
	if !player_id == get_tree().get_network_unique_id():
		map_node.create_player(player_id, player_name)
		
remote func recive_score_update(player_id: String, new_score: int):
	map_node = $"/root/Main/Map"
	if !get_tree().get_rpc_sender_id() == 1:
		return
	var score_name
	if player_id == str(get_tree().get_network_unique_id()):
		score_name = "LocalPlayer"
	else:
		score_name = player_id
	map_node.update_player_score(score_name, new_score)

func close():
	network.call_deferred("close_connection")
	print("[Transfer]: Disconnected")
