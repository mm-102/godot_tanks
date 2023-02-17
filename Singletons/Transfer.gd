extends Node


const PORT = 42521
var ip = null

onready var time_diff_timer_node = $"%TimeDiffTimer"
onready var clock_node = $"%Clock"
onready var main_n = $"/root/Main"
onready var game_n = $"/root/Main/Game"
onready var gui_n = $"/root/Main/PlayerGUILayer/GUI"
onready var gui_scoreboard_n = $"/root/Main/PlayerGUILayer/GUI/Scoreboard"
onready var gui_timer_n = $"/root/Main/PlayerGUILayer/GUI/BattleTime"
var network : NetworkedMultiplayerENet = null


#---------- SERVER CREATION ----------
func _enter_tree():
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
	get_node("/root/Main/PlayerGUILayer").set_visible(true)
	$"/root/Main/Menu".queue_free()

func _exit_tree():
	network.call_deferred("close_connection")
	print("[Transfer]: Disconnected")

#---- INIT DATA ----
func fetch_init_data():
	rpc_id(1, "recive_init_data", game_n.local_player_name)

#[info] Init data only allow to spectate mode
remote func recive_init_data(init_data):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	for player in init_data.PlayerSData:
		gui_scoreboard_n.add_scoreboard_player(player.ID, player)
		game_n.create_player(player)
	for corpse_data in init_data.PlayerSCorpses:
		game_n.create_corpse(corpse_data)
	game_n.get_node("Map").set_map_data(init_data.MapData)
	gui_timer_n.battle_time(init_data.TimeLeft)
	var spectator_camera : Camera2D = load("res://Player/Spectator/Spectator.tscn").instance()
	spectator_camera.current = true
	get_node("/root/Main/Game/Players").add_child(spectator_camera)

remote func recive_new_battle(new_game_data):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	yield(main_n.end_of_battle(), "completed")
	_ready()
	get_tree().set_pause(true)
	game_n.get_node("Map").set_map_data(new_game_data.MapData)
	for player_id in new_game_data.PlayerSData:
		gui_scoreboard_n.add_scoreboard_player(player_id, new_game_data.PlayerSData[player_id])
		if player_id == network.get_unique_id():
			game_n.self_initiation(new_game_data.PlayerSData[player_id])
			continue
		game_n.create_player(new_game_data.PlayerSData[player_id])
	gui_timer_n.start_battle_time(new_game_data.TimeToStartNewGame)
	#yield(get_tree().create_timer((new_game_data.TimeToStartNewGame - get_node(Paths.T_CLOCK).get_time())*0.001), "timeout")
	#get_tree().set_pause(false)

#---------- CORE GAME MECHANIC ---------

remote func recive_new_battle_time(left_sec):
	gui_timer_n.battle_time(left_sec)

remote func recive_new_player(player_id: int, nick : String, spawn_point):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	if !player_id == get_tree().get_network_unique_id():
		game_n.create_player(player_id, nick, spawn_point)

remote func recive_player_destroyed(corpse_data, slayer_id, projectile_name):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	game_n.player_destroyed(corpse_data, projectile_name)
	gui_scoreboard_n.player_destroyed(corpse_data.ID, slayer_id)

func fetch_stance(player_stance: Dictionary):
	rpc_unreliable_id(1, "recive_stance", player_stance)

remote func recive_world_stance(time, playerS_stance):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	game_n.add_world_stance(time, playerS_stance)

func fetch_shoot(player_stance, shoot_slot):
	rpc_unreliable_id(1, "recive_shoot", player_stance, shoot_slot)

remote func recive_shoot(player_id, bullet_data, spawn_time):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	game_n.spawn_bullet(player_id, bullet_data, spawn_time)

remote func recive_shoot_bounce_state(bulletS_state, time):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	game_n.update_bounce_bullet(bulletS_state, time)

remote func recive_score_update(player_id: String, new_score: int):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	var score_name
	if player_id == str(get_tree().get_network_unique_id()):
		score_name = "LocalPlayer"
	else:
		score_name = player_id
	game_n.update_player_score(score_name, new_score)
