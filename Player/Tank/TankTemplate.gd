extends KinematicBody2D

const laser_charge_tscn = preload("res://Player/Particles/ChargeLaserBeamParticles.tscn")

var nick: String = ""
var color: Color = Color.blue
var visible_to_local_player = false
onready var stances = get_node(Dir.GAME).current_world_stances
onready var player_id = int(name)
onready var game_n = get_node(Dir.GAME)


func setup(player_data):
	name = str(player_data.ID)
	if player_data.Nick.empty():
		nick = "Player" + str(player_data.ID)
	position = player_data.P
	set_display_name(player_data.Nick)
	color = player_data.Color
	$"Hitbox/Sprite".self_modulate = player_data.Color
	$Turret.self_modulate = player_data.Color
	set_turret_type(GameSettings.Dynamic.Tank.BaseAmmoType)

func charge(ammo_type): # make universal when more types will need charging
	if ammo_type == Ammunition.TYPES.LASER:
		var particles = laser_charge_tscn.instance()
		$"%BulletPoint".add_child(particles)
		particles.start(1.5) # make a setting for that

func shoot_particles():
	$"%ShootParticles".emitting = true

func _physics_process(delta):
	if stances.size() >= 2 and stances[-1].PlayersStance.has(player_id) and stances[-2].PlayersStance.has(player_id):
		interpolation()

func interpolation():
	var previous_stance = stances[-2].PlayersStance[player_id]
	var next_stance = stances[-1].PlayersStance[player_id]
	var interpolation_factor = game_n.interpolation_factor()
	template_stance(\
			previous_stance, \
			next_stance, \
			interpolation_factor)

func set_display_name(text):
	nick = text
	$"%NickLabel".text = text

func set_turret_type(type):
	$Turret.frame = type

func template_stance(previous_stance, next_stance, interpolation_factor):
	var _position = lerp(previous_stance.P, next_stance.P, interpolation_factor)
	var _rotation = lerp_angle(previous_stance.R, next_stance.R, interpolation_factor)
	var _turret_rotation = lerp_angle(previous_stance.TR, next_stance.TR, interpolation_factor)
	set_position(_position)
	$Hitbox.set_rotation(_rotation)
	$Turret.set_rotation(_turret_rotation)


func die():
	queue_free()


func _on_screen_entered():
	visible_to_local_player = true


func _on_screen_exited():
	visible_to_local_player = false
