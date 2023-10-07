extends Projectile

var bouncey_sounds=[
	preload("res://Sound2.3/Projectiles/Laser Bullet Gun/Laser_bullet_bounce_1.wav"),
	preload("res://Sound2.3/Projectiles/Laser Bullet Gun/Laser_bullet_bounce_2.wav"), 
	preload("res://Sound2.3/Projectiles/Laser Bullet Gun/Laser_bullet_bounce_3.wav")
]
var bouncey_sounds_counter = 0
onready var ray = $RayCast2D
onready var line = $Line2D
#var ammo_type = Ammunition.TYPES.LASER_BULLET
#
func _init():
	s = GameSettings.Dynamic.Ammunition[4]

func _integrate_forces(state):
	update_bounce(state)
	
	var length_left = s.Length
	rotation = 0
	
	line.clear_points()
	line.add_point(Vector2.ZERO)
	
	ray.position = Vector2.ZERO
	ray.cast_to = -state.linear_velocity.normalized() * length_left
	ray.force_raycast_update()
	
	for i in range(s.MaxBounces):
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


func _on_LaserBullet_body_entered(body):
	$SFX_Bounce_1.play()
	$SFX_Bounce_1.stream = bouncey_sounds[bouncey_sounds_counter]
	bouncey_sounds_counter = bouncey_sounds_counter + 1
	if bouncey_sounds_counter > 2:
		bouncey_sounds_counter = 0
	pass # Replace with function body.
