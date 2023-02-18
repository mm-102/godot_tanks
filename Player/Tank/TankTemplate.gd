extends KinematicBody2D

var nick: String = ""
onready var wall = $Hitbox.duplicate(true)
onready var animation_player = $"%AnimationPlayer"
var visible_to_local_player = false
var stances: Array
onready var interpolation_factor = get_node(Dir.GAME).interpolation_factor



func setup(player_data):
	name = str(player_data.ID)
	if player_data.Nick.empty():
		nick = "Player" + str(player_data.ID)
	position = player_data.P
	set_display_name(player_data.Nick)

func add_package(stance):
	if stances.size() > 2:
		stances.remove(0)
	if stance != null:
		stances.append(stance)

func _physics_process(delta):
	if stances.size() > 1:
		interpolation() #render_time > world_stance_buffer[1].T

func interpolation():
	template_stance(\
			stances[-2], \
			stances[-1], \
			interpolation_factor)

func set_display_name(text):
	nick = text
	$"%NickLabel".text = text

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
	remove_from_group("Players")
	add_to_group("Corpse")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "explode":
		queue_free()


func _on_screen_entered():
	visible_to_local_player = true


func _on_screen_exited():
	visible_to_local_player = false
