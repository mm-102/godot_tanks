extends Node


const PORT = 42521
var ip = null
var my_id = null
var main_n 

onready var time_diff_timer_node = $"%TimeDiffTimer"
onready var clock_node = $"%Clock"
onready var master_n = get_node(Dir.MASTER)

var network : NetworkedMultiplayerENet = null


#---------- SERVER CREATION ----------
func _connect_to_server():
	main_n = get_node(Dir.MAIN)
	network = NetworkedMultiplayerENet.new()
	var _err = network.connect("connection_failed", self, "_on_connection_failed")
	_err = network.connect("connection_succeeded", self, "_on_connection_succeeded")
	_err = network.connect("server_disconnected", self, "_server_disconnected")
	_err = network.create_client(ip, PORT)
	get_tree().set_network_peer(network)
	print("[Transfer]: Connecting to server...")

func _server_disconnected():
	print("[Transfer]: Connection lost")
	master_n.exit_to_menu()

func _on_connection_failed():
	print("[Transfer]: Faild to connect")

func _on_connection_succeeded():
	print("[Transfer]: Succesfully connected")
	my_id = network.get_unique_id()
	main_n.connection_succeeded()
	fetch_init_data()
	clock_node.determine_begining_time_diff()
	time_diff_timer_node.start()
	master_n.queue_free_menu()

func close_connection():
	time_diff_timer_node.stop()
	network.close_connection()
	print("[Transfer]: Disconnected")

#---- INIT DATA ----
func fetch_init_data():
	rpc_id(1, "recive_init_data", main_n.local_player_name)

#[info] Init data only allow to spectate mode
remote func recive_data_during_game(init_data):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.init_data(init_data)
	var spectator_camera : Camera2D = load("res://Player/Spectator/Spectator.tscn").instance()
	spectator_camera.current = true
	main_n.add_child(spectator_camera)
	
remote func recive_new_battle(init_data):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	yield(main_n.end_of_battle(), "completed")
	_ready()
	get_tree().set_pause(true)
	main_n.init_data(init_data)

#---------- CORE GAME MECHANIC ---------

remote func recive_new_battle_time(left_sec):
	main_n.battle_time(left_sec)

remote func recive_player_destroyed(corpse_data, slayer_id, projectile_name):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.player_destroyed(corpse_data, slayer_id, projectile_name)

func fetch_stance(player_stance: Dictionary):
	rpc_unreliable_id(1, "recive_stance", player_stance)

remote func recive_world_stance(time, playerS_stance):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.add_world_stance(time, playerS_stance)

func fetch_shoot(player_stance, shoot_slot):
	rpc_unreliable_id(1, "recive_shoot", player_stance, shoot_slot)

remote func recive_shoot(player_id, bullet_data, spawn_time):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.spawn_bullet(player_id, bullet_data, spawn_time)

remote func recive_shoot_bounce_state(bulletS_state, time):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.update_bounce_bullet(bulletS_state, time)
