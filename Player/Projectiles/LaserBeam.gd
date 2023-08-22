extends Line2D

const MAX_WIDTH = 8
const MAX_LENGHT = 5000
export var max_bounces = 4
var point : Vector2 = Vector2.ZERO
var point_rotation = 0
var is_multiplayer = false

var shooter
onready var ray = $RayCast2D
onready var tween = $Tween

func setup(data: ShootableSetupData):
	self.position = data.position
	self.rotation = data.rotation
	shooter = data.shooter
#	var laser_point = player.get_node("%BulletPoint")
#	point = laser_point.global_position
#	point_rotation = laser_point.global_rotation
#	player_path = player.get_path()

func setup_multi(bullet_data : Dictionary):
	point = bullet_data.P
	point_rotation = bullet_data.R

func _ready():
	self.width = 0
	tween.interpolate_property(self, "width", 0, MAX_WIDTH, 0.1)
	tween.interpolate_property(self, "width", MAX_WIDTH, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	tween.start()
	init_laser()
	

func init_laser():
	self.clear_points()
	self.add_point(Vector2.ZERO)
	ray.position = Vector2.ZERO
	ray.cast_to = Vector2.UP* MAX_LENGHT
	ray.force_raycast_update()
	
	cast_laser()

func cast_laser():
	for _i in range(max_bounces):
		if not ray.is_colliding():
			add_point(ray.cast_to + ray.position)
			return
			
		var collider = ray.get_collider()
		var collision_point = ray.get_collision_point()
		var collision_normal = ray.get_collision_normal()
		
		self.add_point(to_local(collision_point))
		
		if collider.is_in_group("Players"):
			collider.die()
			break
		
		if collision_normal == Vector2.ZERO:
			break
		
		ray.cast_to = ray.cast_to.bounce(collision_normal).normalized() * MAX_LENGHT
		ray.position = to_local(collision_point) + ray.cast_to.normalized()
		ray.force_raycast_update()
		


func _on_AudioStreamPlayer2D_finished():
	queue_free()
