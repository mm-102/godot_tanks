extends Node


const PORT = 42521
var ip = null

onready var time_diff_timer_node = $"%TimeDiffTimer"
onready var clock_node = $"%Clock"
onready var game_n = $"/root/Main/Game"
var network : NetworkedMultiplayerENet = null


#---------- SERVER CREATION ----------
func _ready():
	_connect_to_server()

func _connect_to_server():
	network = NetworkedMultiplayerENet.new()
	var _err = network.connect("connection_failed", self, "_on_connection_failed")
	_err = network.connect("connection_succeeded", self, "_on_connection_succeeded")
	_err = network.connect("server_disconnected", self, "_server_disconnected")
	_err = network.create_client(ip, PORT)
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
	get_node("/root/Main/Player_Gui_Layer").set_visible(true)
	$"/root/Main/Menu".queue_free()

func _exit_tree():
	network.call_deferred("close_connection")
	print("[Transfer]: Disconnected")

#---- INIT DATA ----
func fetch_init_data():
	
	rpc_id(1, "recive_init_data", game_n.local_player_name)

remote func recive_init_data(init_data):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	game_n.self_initiation(init_data.SP)
	for player_template in init_data.PlayerSTemplateData:
		game_n.create_player(player_template.ID, player_template.PlayerName, player_template.SP)
		game_n.update_player_score(player_template.ID, player_template.Score)
	for corpse_data in init_data.PlayerSCorpses:
		game_n.create_corpse(corpse_data.Name, corpse_data.P, corpse_data.R)
	game_n.get_node("Map").set_mapset(init_data.MapSet)

#---------- CORE GAME MECHANIC ----------

remote func recive_new_player(player_id: int, player_name : String, spawn_point):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	if !player_id == get_tree().get_network_unique_id():
		game_n.create_player(player_id, player_name, spawn_point)

remote func recive_player_destroyed(player_id, position, rotation, projectile_name):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	if player_id == get_tree().get_network_unique_id():
		$"/root/Main".exit_to_menu()
		return
	game_n.player_destroyed(player_id, position, rotation, projectile_name)

func fetch_stance(player_stance: Dictionary):
	rpc_unreliable_id(1, "recive_stance", player_stance)

func fetch_shoot(player_stance, shoot_type):
	rpc_unreliable_id(1, "recive_shoot", player_stance, shoot_type)

remote func recive_world_stance(time, playerS_stance):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	game_n.add_world_stance(time, playerS_stance)

remote func recive_shoot(player_id, bullet_data):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	game_n.spawn_bullet(player_id, bullet_data)

remote func recive_score_update(player_id: String, new_score: int):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	var score_name
	if player_id == str(get_tree().get_network_unique_id()):
		score_name = "LocalPlayer"
	else:
		score_name = player_id
	game_n.update_player_score(score_name, new_score)
