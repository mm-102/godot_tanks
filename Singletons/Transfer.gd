extends Node

signal recive_player_possible_upgrades(data)
signal recive_battle_over_time(time_to_end)

const PORT = 42521
var ip = null
var my_id = null

onready var time_diff_timer_node = $"%TimeDiffTimer"
onready var clock_node = $"%Clock"
onready var master_n = get_node(Dir.MASTER)
onready var main_n 

#var network : NetworkedMultiplayerENet = null
var network : WebSocketClient = null
var is_connected = false

func get_time():
	return clock_node.get_time()

func _process(_delta):
	if network != null:
		network.poll()

#---------- SERVER CREATION ----------
func _connect_to_server():
	network = WebSocketClient.new()
	var _err = network.connect("connection_failed", self, "_on_connection_failed")
	_err = network.connect("connection_succeeded", self, "_on_connection_succeeded")
	_err = network.connect("server_close_request", self, "_server_close_request")
	_err = network.connect("server_disconnected", self, "_server_disconnected")
	_err = network.connect("connection_closed", self, "_connection_closed")
	_err = network.connect("connection_error", self, "_connection_error")
	_err = network.connect_to_url("ws://"+ip+":"+str(PORT), PoolStringArray(), true)
	get_tree().set_network_peer(network)
	set_process(true)
	print("[Transfer]: Connecting to server...")

func _connection_error():
	print("[Transfer]: Connection lost")
	master_n.exit_to_menu()

func _server_close_request(_is_clean, smth):
	print("[Transfer]: Connection lost")
	master_n.exit_to_menu()

func _server_disconnected():
	print("[Transfer]: Connection lost")
	master_n.exit_to_menu()

func _on_connection_failed():
	print("[Transfer]: Faild to connect")
	if is_connected and is_instance_valid(master_n):
		print("[Transfer]: ... Connection lost")
		master_n.exit_to_menu()


func _on_connection_succeeded():
	print("[Transfer]: Succesfully connected.")
	is_connected = true
	_ready()
	master_n.game_mode(1)
	main_n = get_node(Dir.MAIN)
	my_id = network.get_unique_id()
	fetch_init_data()

func close_connection():
	time_diff_timer_node.stop()
#	network.close_connection()
	network.disconnect_from_host()
	print("[Transfer]: Disconnected")

#---- INIT DATA ----
func fetch_init_data():
	rpc_id(1, "recive_init_data", master_n.nick, master_n.player_color, Functions.get_version(), OS.get_ticks_msec())

remote func recive_old_version_info(available_versions):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	print("[Transfer]: Connection droped: Old version.")
	master_n.old_version_info()
	master_n.get_node("Main").queue_free()
	close_connection()

#[info] Init data only allow to spectate mode
remote func recive_data_during_game(init_data):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	master_n.get_node("Main").show()
	main_n.connection_succeeded()
	time_diff_timer_node.start()
	master_n.queue_free_menu()
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
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.battle_time(left_sec)

remote func recive_battle_over_time(time_to_end):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	get_tree().set_pause(true)
	emit_signal("recive_battle_over_time", time_to_end)
	

remote func recive_player_destroyed(corpse_data, kill_event_data):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.player_destroyed(corpse_data, kill_event_data)
	
remote func recive_ammobox_destroyed(name):
	get_node(Dir.GAME).ammobox_destroyed(name)

func fetch_stance(player_stance: Dictionary):
	rpc_unreliable_id(1, "recive_stance", player_stance)


remote func recive_world_stance(_time, playerS_stance):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.add_world_stance(_time, playerS_stance)

func fetch_shoot(player_stance, ammo_type):
	rpc_id(1, "recive_shoot", player_stance, ammo_type)

func fetch_charge_shoot(ammo_type):
	rpc_id(1, "recive_charge_shoot", ammo_type)

remote func recive_shoot(player_id, bullet_data):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.spawn_bullet(player_id, bullet_data)

remote func recive_shoot_fail(player_id):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.player_shot_failed(player_id)

remote func recive_player_charge(player_id, ammo_type):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.player_charge(player_id, ammo_type)

func fetch_change_ammo_type(ammo_type):
	rpc_id(1, "recive_ammo_type_change", ammo_type)

remote func recive_turret_change(player_id, ammo_type):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.change_player_turret(player_id, ammo_type)

remote func recive_shoot_bounce_state(bulletS_state, _time):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	main_n.update_bounce_bullet(bulletS_state, _time)

#------------Upgrades-------------
remote func recive_player_possible_upgrades(data):
	if !get_tree().get_rpc_sender_id() == 1:
		return
	emit_signal("recive_player_possible_upgrades", data)

func fetch_player_possible_upgrades(player_choosen_upgrades):
	rpc_id(1, "recive_upgrade", player_choosen_upgrades)
