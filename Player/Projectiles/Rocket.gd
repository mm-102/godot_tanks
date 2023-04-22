extends Projectile

var target = null
onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
var started_targeting = false

#var ammo_type = Ammunition.TYPES.ROCKET
#
func _init():
	s = GameSettings.Dynamic.Ammunition[1]

func _on_StartTargeting_timeout():
	started_targeting = true

func _integrate_forces(state):
	if !started_targeting:
		return
	for player in get_tree().get_nodes_in_group("Players"):
		if target == null:
			target = player
		if !is_instance_valid(target) or !target.is_inside_tree():
			target = null
			continue
		if !is_instance_valid(player):
			continue
		if player.global_position.distance_to(self.global_position) < \
				target.global_position.distance_to(self.global_position):
			target = player
	if is_instance_valid(target):
		navigation_agent.set_target_location(target.global_position)
		var move_direction = position.direction_to(navigation_agent.get_next_location())
		var velocity = move_direction * s.FollowSpeed
		set_linear_velocity(velocity) 
		navigation_agent.set_velocity(velocity)

func _physics_process(delta):
	if is_instance_valid(target):
		var distance =  min(global_position.distance_to(target.global_position), 500)
		$Sprite.get_material().set_shader_param("radius", distance)
		#$Sprite.get_material().set_shader_param("speed", (-0.03 * distance) + 20.0)
		var rot = navigation_agent.get_next_location().angle_to_point(position)
		rotation = lerp_angle(rotation, rot, delta * 8)
	else:
		rotation = linear_velocity.angle()
