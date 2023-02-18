extends Line2D

var LASER_LENGTH
var MAX_BOUNCES

onready var ray = $RayCast2D
onready var tween = $Tween

var player_path = NodePath("")
var point : Vector2 = Vector2.ZERO
var point_rotation = 0

func set_params():
	LASER_LENGTH = $"/root/Master/Settings".SETTINGS.LASER_BEAM_LENGTH
	MAX_BOUNCES = $"/root/Master/Settings".SETTINGS.LASER_BEAM_MAX_BOUNCES

func setup(player : RigidBody2D):
	var laser_point = player.get_node("%LaserPoint")
	point = laser_point.global_position
	point_rotation = laser_point.global_rotation
	player_path = player.get_path()
	
func setup_multiplayer(bullet_data : Dictionary):
	point = bullet_data.SP
	point_rotation = bullet_data.R
	
func _on_Tween_tween_all_completed():
	var player = get_node_or_null(player_path)
	if !(player == null):
		player.ammo_left += 1
	queue_free()
	
func _ready():
	set_params()
	var MAX_WIDTH = $"/root/Master/Settings".SETTINGS.LASER_BEAM_MAX_WIDTH
	tween.interpolate_property(self, "width", width, MAX_WIDTH, 0.2)
	tween.interpolate_property(self, "width", MAX_WIDTH, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
	tween.start()
	
	cast_laser()

func cast_laser():
	global_position = point
	var length_left = LASER_LENGTH
	
	clear_points()
	add_point(Vector2.ZERO)
	ray.position = Vector2.ZERO
#	ray.cast_to = (get_global_mouse_position() - global_position).normalized() * length_left
	ray.cast_to = Vector2.UP.rotated(point_rotation) * length_left
	ray.force_raycast_update()
	
	for i in range(MAX_BOUNCES):	# limit bounces
		
		if !ray.is_colliding():
			add_point(ray.cast_to + ray.position)
			break
			
		var collider = ray.get_collider()
		var collision_point = ray.get_collision_point()
		var collision_normal = ray.get_collision_normal()
		
		add_point(to_local(ray.get_collision_point()))
		
		if collider.is_in_group("Players") or collider.is_in_group("Corpse"):
			break
		
		if collision_normal == Vector2.ZERO:
			break
		
		length_left -= ray.to_local(collision_point).length()
		ray.cast_to = ray.cast_to.bounce(collision_normal).normalized() * length_left
		ray.position = to_local(collision_point) + ray.cast_to.normalized()
		# move ray position a bit from collision point not to collide with the same point twice
		
		ray.force_raycast_update()
