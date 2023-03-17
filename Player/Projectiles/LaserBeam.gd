extends Line2D


var s = GameSettings.Dynamic.Ammunition[3]
var player_path = NodePath("")
var point : Vector2 = Vector2.ZERO
var point_rotation = 0

onready var ray = $RayCast2D
onready var tween = $Tween

func setup(player : RigidBody2D):
	var laser_point = player.get_node("%BulletPoint")
	point = laser_point.global_position
	point_rotation = laser_point.global_rotation
	player_path = player.get_path()
	
func setup_multi(bullet_data : Dictionary):
	point = bullet_data.P
	point_rotation = bullet_data.R
	
func _on_Tween_tween_all_completed():
	var player = get_node_or_null(player_path)
	if !(player == null):
		player.ammo_left += 1
	queue_free()
	
func _ready():
	tween.interpolate_property(self, "width", width, s.MaxWidth, 0.2)
	tween.interpolate_property(self, "width", s.MaxWidth, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
	tween.start()
	
	cast_laser()

func cast_laser():
	global_position = point
	var length_left = s.Length
	
	clear_points()
	add_point(Vector2.ZERO)
	ray.position = Vector2.ZERO
#	ray.cast_to = (get_global_mouse_position() - global_position).normalized() * length_left
	ray.cast_to = Vector2.UP.rotated(point_rotation) * length_left
	ray.force_raycast_update()
	
	for _i in range(s.MaxBounces):	# limit bounces
		
		if !ray.is_colliding():
			add_point(ray.cast_to + ray.position)
			break
			
		var collider = ray.get_collider()
		var collision_point = ray.get_collision_point()
		var collision_normal = ray.get_collision_normal()
		
		add_point(to_local(ray.get_collision_point()))
		
		if collider.is_in_group("Players"):
			if !collider.is_in_group("Corpse") and !$"/root/Master".is_multiplayer:
				collider.die()
			break
		
		if collision_normal == Vector2.ZERO:
			break
		
		length_left -= ray.to_local(collision_point).length()
		ray.cast_to = ray.cast_to.bounce(collision_normal).normalized() * length_left
		ray.position = to_local(collision_point) + ray.cast_to.normalized()
		# move ray position a bit from collision point not to collide with the same point twice
		
		ray.force_raycast_update()
