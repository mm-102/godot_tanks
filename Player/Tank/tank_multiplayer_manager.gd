extends Node

export(NodePath) onready var tank_node = get_node(tank_node) as KinematicBody2D
export(NodePath) onready var rotor_node = get_node(rotor_node) as Node2D
export(NodePath) onready var turret_rotor_node = get_node(turret_rotor_node) as Node2D
var is_multiplayer = false



func _ready():
	if is_multiplayer:
		$SendTimer.start()

func create_stance() -> Dictionary:
	var stance = {
		"T": OS.get_ticks_msec(),
		"P": tank_node.position,
		"R": rotor_node.rotation,
		"TR": turret_rotor_node.get_turret_rotation(),
	}
	return stance

func send_data():
	var stance = create_stance()
	Transfer.fetch_stance(stance)

func _on_SendTimer_timeout():
	send_data()
