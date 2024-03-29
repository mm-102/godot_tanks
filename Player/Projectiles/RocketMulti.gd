extends Projectile

onready var stances = get_node(Dir.GAME).current_world_stances
onready var game_n = get_node(Dir.GAME)
onready var hitbox = $"%CollisionShape2D"


func _init():
	$StartTargeting.free()
	set_mode(MODE_KINEMATIC)

func _process(_delta):
	if stances.size() >= 2 and stances[-1].RocketsStance.has(name) and stances[-2].RocketsStance.has(name):
		interpolation()

func setup_multi(bullet_data : Dictionary):
	.setup_multi(bullet_data)

func interpolation():
	var previous_stance = stances[-2].RocketsStance[name]
	var next_stance = stances[-1].RocketsStance[name]
	var interpolation_factor = game_n.interpolation_factor()
	template_stance(\
			previous_stance, \
			next_stance, \
			interpolation_factor)

func template_stance(previous_stance, next_stance, interpolation_factor):
	var _position = lerp(previous_stance.P, next_stance.P, interpolation_factor)
	var _rotation = lerp_angle(previous_stance.R, next_stance.R, interpolation_factor)
	var _owner_modulate = lerp(previous_stance.OC, next_stance.OC, interpolation_factor)
	var _target_modulate = lerp(previous_stance.TC, next_stance.TC, interpolation_factor)
	set_position(_position)
	set_rotation(_rotation)
	$Sprite.modulate = _owner_modulate
	$Particles2D.modulate = _target_modulate
