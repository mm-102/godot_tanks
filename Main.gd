extends Node

enum GAME_MODE{SINGLE, MULTI}
const transfe_pck = preload("res://Singletons/Transfer.tscn")
const MODE_DICT = {
	GAME_MODE.SINGLE: preload("res://Singleplayer.tscn"),
	GAME_MODE.MULTI: preload("res://Multiplayer.tscn"),
}
var is_multiplayer = false


func game_mode(sel_mode: int, adress):
	var mode_inst = MODE_DICT[sel_mode].instance()
	if sel_mode == GAME_MODE.MULTI:
		is_multiplayer = true
		var transfer_inst = transfe_pck.instance()
		transfer_inst.ip = adress
		get_node("/root").add_child(transfer_inst)
	add_child(mode_inst)