extends Node

const GAME_TSCN = preload("res://Multiplayer/Game/Game.tscn")
const GUI_TSCN = preload("res://Player/Player_GUI/GUI.tscn")

var local_player_name = ""

onready var game_n = get_node(Dir.GAME)
onready var map_n = get_node(Dir.MAP)
onready var gui_n = get_node(Dir.GUI)
onready var gui_scoreboard_n = get_node(Dir.GUI_SCOREBOARD)
onready var gui_timer_n = get_node(Dir.GUI_TIMER)



func _enter_tree():
	Transfer._connect_to_server()

func _exit_tree():
	Transfer.close_connection()

func connection_succeeded():
	gui_n.set_visible(true)

func init_data(init_data):
	map_n.set_map_data(init_data.MapData)
	for player in init_data.PlayerSData:
		gui_scoreboard_n.add_scoreboard_player(player.ID, player)
		if player.ID == Transfer.my_id:
			game_n.self_initiation(player)
			continue
		game_n.create_template(player)
	game_n.set_corspses_data(init_data.PlayerSCorpses)
	if init_data.has("TimeLeft"):
		gui_timer_n.battle_time(init_data.TimeLeft)
	if init_data.has("TimeToStartNewGame"):
		gui_timer_n.start_battle_time(init_data.TimeToStartNewGame)

func end_of_battle():
	gui_n.queue_free()
	game_n.queue_free()
	yield(game_n, "tree_exited")
	add_child(GAME_TSCN.instance())
	$GUILayer.add_child(GUI_TSCN.instance())
	_ready()

func add_world_stance(time, playerS_stance):
	game_n.add_world_stance(time, playerS_stance)

func battle_time(left_sec):
	gui_timer_n.battle_time(left_sec)

func spawn_bullet(player_id, bullet_data, spawn_time):
	game_n.spawn_bullet(player_id, bullet_data, spawn_time)

func update_bounce_bullet(bulletS_state, time):
	game_n.update_bounce_bullet(bulletS_state, time)

func player_destroyed(corpse_data, slayer_id, projectile_name):
	game_n.player_destroyed(corpse_data, projectile_name)
	gui_scoreboard_n.player_destroyed(corpse_data.ID, slayer_id)
