extends KinematicBody2D
onready var wall = $Hitbox.duplicate(true)
onready var animation_player = $"%AnimationPlayer"


func template_stance(previous_stance, next_stance, interpolation_factor):
	var _position = lerp(previous_stance.P, next_stance.P, interpolation_factor)
	var _rotation = lerp_angle(previous_stance.R, next_stance.R, interpolation_factor)
	var _turret_rotation = lerp_angle(previous_stance.TR, next_stance.TR, interpolation_factor)
	set_position(_position)
	$Hitbox.set_rotation(_rotation)
	$Turret.set_rotation(_turret_rotation)

func get_hitbox():
	return wall

func die():
	$Hitbox.set_disabled(true)
	animation_player.play("explode")


func _on_AnimationPlayer_animation_finished(anim_name):
	print("[TankTemplate]: finished of animation player, name: "+anim_name)
	queue_free()
