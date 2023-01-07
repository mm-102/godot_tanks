extends Node

onready var tank
var player_name = "Player" # defined when spawning

	
func template_stance(previous_stance, next_stance, interpolation_factor):
	tank.template_stance(previous_stance, next_stance, interpolation_factor)

func get_hitbox():
	return tank.get_hitbox()

func die():
	tank.die()


func _on_Tank_ready():
	tank = $"%Tank"
	tank.set_display_name(player_name)
