extends Projectile

onready var stances = get_node(Dir.GAME).current_world_stances
onready var game_n = get_node(Dir.GAME)
onready var hitbox = $"%CollisionShape2D"


func _init():
	set_mode(MODE_KINEMATIC)

func _physics_process(delta):
	if stances[-1].RocketsStance.has(name) and stances[-2].RocketsStance.has(name):
		interpolation()

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
	set_position(_position)
	$Sprite.set_rotation(_rotation)
