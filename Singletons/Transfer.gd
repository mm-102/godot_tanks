extends Node


const PORT = 42521
var ip = null

const MAP_PATH_OUT = "/root/Main/Map"
onready var time_diff_timer_node = $"%TimeDiffTimer"
onready var clock_node = $"%Clock"



#---------- SERVER CREATION ----------
func _ready():
	_connect_to_server()

func _connect_to_server():
	var network = NetworkedMultiplayerENet.new()
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("server_disconnected", self, "_server_disconnected")
	network.create_client(ip, PORT)
	get_tree().set_network_peer(network)
	print("[Transfer]: Connecting to server...")

func _server_disconnected():
	print("[Transfer]: Connection lost")

func _on_connection_failed():
	print("[Transfer]: Faild to connect")

func _on_connection_succeeded():
	print("[Transfer]: Succesfully connected")
	fetch_init_data()
	clock_node.determine_begining_time_diff()
	time_diff_timer_node.start()

#---------- XXX ----------
func fetch_init_data():
	rpc_id(1, "recive_init_data")
remote func recive_init_data():
	get_node(MAP_PATH_OUT).init_player()

func fetch_stance(player_stance: Dictionary):
	rpc_unreliable_id(1, "recive_stance", player_stance)
func fetch_shoot(player_stance, shoot_type):
	rpc_unreliable_id(1, "recive_shoot", player_stance, shoot_type)


