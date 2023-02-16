extends Projectile

var BULLET_LENGTH
var MAX_BOUNCES

onready var ray = $RayCast2D
onready var line = $Line2D

func _ready():
	set_params()

func set_params():
	SPEED = $"/root/Main/Settings".SETTINGS.LASER_BULLET_SPEED
	BULLET_LENGTH = $"/root/Main/Settings".SETTINGS.LASER_BULLET_LENGTH
	MAX_BOUNCES = $"/root/Main/Settings".SETTINGS.LASER_BULLET_LASER_MAX_BOUNCES

func _integrate_forces(state):
	var length_left = BULLET_LENGTH
	rotation = 0
	
	line.clear_points()
	line.add_point(Vector2.ZERO)
	
	ray.position = Vector2.ZERO
	ray.cast_to = -state.linear_velocity.normalized() * length_left
	ray.force_raycast_update()
	
	for i in range(MAX_BOUNCES):
		if !ray.is_colliding():
			line.add_point(ray.cast_to + ray.position)
			break
			
		var collider = ray.get_collider()
		var collision_point = ray.get_collision_point()
		var collision_normal = ray.get_collision_normal()
		
		line.add_point(to_local(ray.get_collision_point()))
		
		if collider.is_in_group("Players") or collider.is_in_group("Corpse"):
			break
		
		if collision_normal == Vector2.ZERO:
			break
		
		length_left -= ray.to_local(collision_point).length()
		ray.cast_to = ray.cast_to.bounce(collision_normal).normalized() * length_left
		ray.position = to_local(collision_point) + ray.cast_to.normalized()
		# move ray position a bit from collision point not to collide with the same point twice
		
		ray.force_raycast_update()
