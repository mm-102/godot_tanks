extends Node

enum GAME_MODE{SINGLE, MULTI}
const menu_gui_tscn = preload("res://GUI/Menu.tscn")
const gui_tscn = preload("res://Player/Player_GUI/GUI.tscn")
const transfe_pck = preload("res://Singletons/Transfer.tscn")
const MODE_DICT = {
	GAME_MODE.SINGLE: preload("res://Singleplayer.tscn"),
	GAME_MODE.MULTI: preload("res://Multiplayer/Game/Multi_Game.tscn"),
}
var is_multiplayer = false

func game_mode(sel_mode: int, adress, player_nick):
	#[info] Transfer node have to be after main
	var mode_inst = MODE_DICT[sel_mode].instance()
	add_child(mode_inst)
	if sel_mode == GAME_MODE.SINGLE:
		get_node("/root/Main/PlayerGUILayer").set_visible(true)
	if sel_mode == GAME_MODE.MULTI:
		if get_node_or_null("/root/Transfer") != null:
			get_node("/root/Transfer").request_ready()
			return
		is_multiplayer = true
		mode_inst.local_player_name = player_nick
		var transfer_inst = transfe_pck.instance()
		transfer_inst.ip = adress
		get_node("/root").add_child(transfer_inst)

func exit_to_menu():
	if is_multiplayer:
		$"/root/Transfer".queue_free()
	#warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	
func end_of_battle(): #[Important!] How to name functions: According to time when its called, or what this function does?
	var mode_inst = MODE_DICT[GAME_MODE.MULTI].instance()
	add_child(mode_inst)
	$PlayerGUILayer.add_child(gui_tscn.instance())
