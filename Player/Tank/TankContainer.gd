extends Node

onready var tank
var player_name = "Player" # defined when spawning
var position = Vector2.ZERO


func _on_Tank_ready():
	tank = $"%Tank"
	tank.position = position
	tank.set_display_name(player_name)
