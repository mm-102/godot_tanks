extends Projectile

const MAX_WIDTH = 8
const MAX_LENGHT = 30
export var max_bounces = 4
var point : Vector2 = Vector2.ZERO
var point_rotation = 0

onready var ray = $RayCast2D
onready var line = $Line2D


func _integrate_forces(state):
	update_bounce(state)
	rotation = 0
	var length_left = MAX_LENGHT
	line.clear_points()
	line.add_point(Vector2.ZERO)
	
	ray.position = Vector2.ZERO
	ray.cast_to = -state.linear_velocity.normalized() * length_left
	ray.force_raycast_update()
	
	for i in range(max_bounces):
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
