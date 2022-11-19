extends RigidBody2D

const speed = 100
const rot_speed = 2
const bullet_speed = 200
const max_ammo = 5
const death_time = 20

const forward = "p_forward"
const backward = "p_backward"
const left = "p_left"
const right = "p_right"

var Bullet = preload("res://objects//bullet.tscn")
var Rocket = preload("res://objects/rocket.tscn") # work in progress

onready var start_pos = get_parent().position
onready var animation_player = $AnimationPlayer

var ammo_left = 5
var dead = false

onready var ammo_type = get_parent().ammo_type

func _ready():
	add_to_group("players")

func _integrate_forces(_state):
	var v = Vector2(0,0)
	v.y = int(Input.is_action_pressed(backward)) - int(Input.is_action_pressed(forward))
	
	var av = int(Input.is_action_pressed(right)) - int(Input.is_action_pressed(left))
	
	if v.y > 0:
		av = -av

	set_angular_velocity(av * rot_speed)
	set_linear_velocity(v.rotated(rotation) * speed)
	
	
	if Input.is_action_just_pressed("p_shoot"):
		
		if ammo_left > 0:
			ammo_left -= 1
			call_deferred("_shoot")
		
func _shoot():
	var b
	if ammo_type == "bullet":
		b = Bullet.instance()
	elif ammo_type == "rocket":
		b = Rocket.instance()
	else:
		return
	var rot = (start_pos + position).angle_to_point(get_global_mouse_position()) + PI
	
	var v = Vector2.RIGHT.rotated(rot)
	b.position = position + 50 * v
	b.get_child(0).rotation = rot
	b.get_child(0).set_linear_velocity(v * bullet_speed)
	get_parent().add_child(b)


func _on_base_body_entered(body):
	if not body.is_in_group("projectile"):
		return
	animation_player.play("explode")
	dead = true
	set_deferred("mode", RigidBody2D.MODE_STATIC)
	set_angular_velocity(0)
	set_linear_velocity(Vector2.ZERO)
	body.die()
	
	var timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start(death_time)
		
func _on_timer_timeout():
	get_parent().queue_free()
