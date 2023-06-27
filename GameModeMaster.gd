extends Node

enum GAME_MODE{SINGLE, MULTI}
const transfe_pck = preload("res://Singletons/Transfer.tscn")
const MODE_DICT = {
	GAME_MODE.SINGLE: preload("res://Singleplayer/Main.tscn"),
	GAME_MODE.MULTI: preload("res://Multiplayer/Main.tscn"),
}
var nick = ""
var player_color = ""
var is_multiplayer = false
var is_touch_screen = false 

func _ready():
	get_tree().paused = false
	is_touch_screen = JavaScript.eval("('ontouchstart' in window) || (navigator.maxTouchPoints > 0) || (navigator.msMaxTouchPoints > 0)",true)
	if is_touch_screen:
		OS.SCREEN_ORIENTATION_REVERSE_PORTRAIT


func game_mode(sel_mode: int):
	#[info] Transfer node have to be after main
	var mode_inst = MODE_DICT[sel_mode].instance()
	mode_inst.local_player_name = nick
	mode_inst.local_player_color = player_color
	if sel_mode == GAME_MODE.MULTI:
		mode_inst.hide()
		Transfer._ready()
		is_multiplayer = true
	add_child(mode_inst)

func old_version_info():
	$Menu.old_version_info()

func queue_free_menu():
	$Menu.queue_free()

func exit_to_menu():
	$Main.queue_free()
	get_tree().reload_current_scene()
