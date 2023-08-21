extends Projectile

export var follow_speed = 100
export var stun_duration = 2
var target = null
var is_targeting = false
var anim_time = 0
onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D



func _init():
	self.linear_velocity = Vector2.RIGHT.rotated(rotation) * speed

func _on_StartTargeting_timeout():
	is_targeting = true



func _integrate_forces(state):
	if not is_targeting:
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
		var velocity = move_direction * follow_speed# * delta
		self.linear_velocity = velocity
		navigation_agent.set_velocity(velocity)



func _physics_process(delta):
	
	if is_instance_valid(target):
		var distance =  min(global_position.distance_to(target.global_position), 500)
		anim_time += delta * ((-0.03 * distance) + 20.0)
		$Sprite.get_material().set_shader_param("radius", distance)
		$Particles2D.process_material.set_shader_param("radius", distance)
		var rot = navigation_agent.get_next_location().angle_to_point(position)
		rotation = lerp_angle(rotation, rot, delta * 8)
	else:
		rotation = linear_velocity.angle()
		anim_time += delta * 7
	$Sprite.get_material().set_shader_param("current_time", anim_time)
	$Particles2D.process_material.set_shader_param("current_time", anim_time)


func stun():
	is_targeting = false
	target = null
	$StartTargeting.start(stun_duration)

func _on_Rocket_body_entered(body):
	if body is Projectile:
		stun()


func _on_StunDuration_timeout():
	is_targeting = true
