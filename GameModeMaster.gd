extends Node

enum GAME_MODE{SINGLE, MULTI}
const transfe_pck = preload("res://Singletons/Transfer.tscn")
const MODE_DICT = {
	GAME_MODE.SINGLE: preload("res://Singleplayer/Main.tscn"),
	GAME_MODE.MULTI: preload("res://Multiplayer/Main.tscn"),
}
var is_multiplayer = false 

var rng = RandomNumberGenerator.new()

func _ready():
#	Transfer._ready()
	pass

func game_mode(sel_mode: int, adress, player_nick):
	#[info] Transfer node have to be after main
	var mode_inst = MODE_DICT[sel_mode].instance()
	mode_inst.local_player_name = player_nick
	rng.randomize()
	mode_inst.local_player_color = Color.from_hsv(rng.randf(), 1.0, 1.0) # temp
	if sel_mode == GAME_MODE.MULTI:
		Transfer._ready()
		is_multiplayer = true
		Transfer.ip = adress
	add_child(mode_inst)

func queue_free_menu():
	$Menu.queue_free()

func exit_to_menu():
	$Main.queue_free()
#	if is_multiplayer:
#		$"/root/Transfer".queue_free()
	#warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


