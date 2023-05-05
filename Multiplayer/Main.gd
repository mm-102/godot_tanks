extends Node

const GAME_TSCN = preload("res://Multiplayer/Game/Game.tscn")
const GUI_TSCN = preload("res://Player/Player_GUI/GUI.tscn")

var local_player_name = ""
var local_player_color = Color.blue

onready var game_n = get_node(Dir.GAME)
onready var map_n = get_node(Dir.MAP)
onready var gui_n = get_node(Dir.GUI)
onready var gui_scoreboard_n = get_node(Dir.GUI_SCOREBOARD)
onready var gui_timer_n = get_node(Dir.GUI_TIMER)
onready var gui_events_n = get_node(Dir.GUI_EVENT_LOG)
onready var gui_all_upgrades_n = get_node(Dir.GUI_ALL_UPGRADES)



func _ready():
	pass

func _exit_tree():
	Transfer.close_connection()



func connection_succeeded():
	gui_n.set_visible(true)

func init_data(init_data):
	map_n.set_map_data(init_data.MapData)
	GameSettings.set_dynamic_settings(init_data.PlayerSData, init_data.SpecialUpgrades)
	gui_all_upgrades_n.add_points(init_data.PlayerSData)
	for player in init_data.PlayerSData:
		gui_scoreboard_n.add_scoreboard_player(player.ID, player)
		if player.ID == Transfer.my_id:
			game_n.self_initiation(player)
			continue
		game_n.create_template(player)
	game_n.set_corspses_data(init_data.PlayerSCorpses)
	game_n.set_bullets_data(init_data.BulletsStances)
	gui_timer_n._on_phase_recived(init_data.Phase)
	gui_all_upgrades_n._on_phase_recived(init_data.Phase)

func end_of_battle():
	gui_n.queue_free()
	game_n.queue_free()
	yield(game_n, "tree_exited")
	add_child(GAME_TSCN.instance())
	$GUILayer.add_child(GUI_TSCN.instance())
	_ready()

func add_world_stance(time, playerS_stance):
	game_n.add_world_stance(time, playerS_stance)

func spawn_bullet(player_id, bullet_data):
	game_n.spawn_bullet(player_id, bullet_data)

func player_shot_failed(player_id):
	game_n.player_shot_failed(player_id)

func player_charge(player_id, ammo_type):
	game_n.player_charge(player_id, ammo_type)

func update_bounce_bullet(bulletS_state, time):
	game_n.update_bounce_bullet(bulletS_state, time)

func change_player_turret(player_id, ammo_type):
	game_n.change_player_turret(player_id, ammo_type)

func player_destroyed(corpse_data, kill_event_data):
	var killer = get_node_or_null(Dir.PLAYERS + "/" + kill_event_data.KillerID)
	var killed = get_node_or_null(Dir.PLAYERS + "/" + kill_event_data.KilledID)
	if killer != null and killed != null and !kill_event_data.KillerID.empty() and !kill_event_data.KilledID.empty():
		gui_events_n.on_kill_event(killer.nick, killed.nick, kill_event_data.AT)
	else:
		killed = get_node_or_null(Dir.PLAYERS + "/" + str(corpse_data.ID))
		if killed != null:
			gui_events_n.on_kill_event("", killed.nick, NAN)
	gui_scoreboard_n.player_destroyed(corpse_data.ID, kill_event_data.KillerID)
	game_n.player_destroyed(corpse_data, kill_event_data.PName)

func hide():
	$Background.hide()

func show():
	$Background.show()
