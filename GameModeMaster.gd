extends Node

enum GAME_MODE{SINGLE, MULTI}
const transfe_pck = preload("res://Singletons/Transfer.tscn")
const MODE_DICT = {
	GAME_MODE.SINGLE: preload("res://Singleplayer.tscn"),
	GAME_MODE.MULTI: preload("res://Multiplayer/Main.tscn"),
}
var is_multiplayer = false 

var rng = RandomNumberGenerator.new()

func _ready():
	Transfer._ready()

func game_mode(sel_mode: int, adress, player_nick):
	#[info] Transfer node have to be after main
	var mode_inst = MODE_DICT[sel_mode].instance()
	if sel_mode == GAME_MODE.SINGLE:
		get_node("/root/Main/PlayerGUILayer").set_visible(true)
	if sel_mode == GAME_MODE.MULTI:
		mode_inst.local_player_name = player_nick
		rng.randomize()
		mode_inst.local_player_color = Color.from_hsv(rng.randf(), 1.0, 1.0) # temp
		is_multiplayer = true
		Transfer.ip = adress
	add_child(mode_inst)
#		if get_node_or_null("/root/Transfer") != null:
#			get_node("/root/Transfer").request_ready()
#			return
#		var transfer_inst = transfe_pck.instance()
#		get_node("/root").add_child(transfer_inst)

func queue_free_menu():
	$Menu.queue_free()

func exit_to_menu():
	$Main.queue_free()
#	if is_multiplayer:
#		$"/root/Transfer".queue_free()
	#warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


