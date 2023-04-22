extends Node2D

const tank_tscn = preload("res://Player/Tank/Tank.tscn")
const gui_tscn = preload("res://Singleplayer/GUI/GUI.tscn")
onready var player = $Tank

func _ready():
	var local_player_name = get_node(Dir.MAIN).local_player_name
	if local_player_name.empty():
		local_player_name = "You"
	player.set_display_name(local_player_name)


func _on_Tank_self_player_died(_pos):
	get_node("../GUILayer/GUI").queue_free()
	yield(get_tree(), "idle_frame")
	var gui_inst = gui_tscn.instance()
	get_node("../GUILayer").add_child(gui_inst)
	var tank_inst = tank_tscn.instance()
	tank_inst.connect("self_player_died", self, "_on_Tank_self_player_died")
	tank_inst.set_global_position(Vector2(1967, 1488))
	add_child(tank_inst)
	get_tree().paused = false

