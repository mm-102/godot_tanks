extends Node2D

export(NodePath) onready var end_point = get_node(end_point) as Node2D
onready var ray = $RayCast2D



func is_gun_inside_wall():
	ray.cast_to = end_point.global_position
	ray.force_raycast_update()
	
	if not ray.is_colliding():
		return false
	
	var collider = ray.get_collider()
	if collider.has_method("highlight"):
		call_highlight(ray, collider)
	return true


func call_highlight(ray, collider):
	var collider_position = ray.get_collision_point()
	var angle = self.position.angle_to_point(ray.cast_to) 
	var offset = Vector2.RIGHT.rotated(angle) * 0.1
	collider.highlight(collider_position + offset)
