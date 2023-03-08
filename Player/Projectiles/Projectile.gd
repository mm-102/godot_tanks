extends RigidBody2D
class_name Projectile

var s:Dictionary

var player_path = NodePath("")
var bullet_state_queue: Array
onready var append_timer_n = $AppendTimer




func setup(player : RigidBody2D):
	player_path = player.get_path()
	var point = player.get_node("%BulletPoint")
	position = point.global_position
	set_linear_velocity(Vector2.UP.rotated(point.global_rotation) * s.Speed)

func setup_multi(bullet_data : Dictionary):
	set_name(bullet_data.ID)
	position = bullet_data.P
	set_linear_velocity(bullet_data.V)


func _init():
	var append_timer = Timer.new()
	append_timer.name = "AppendTimer"
	append_timer.one_shot = true
	add_child(append_timer)

func _ready():
	if !$"/root/Master".is_multiplayer:
#		if player_path != NodePath(""):
#			linear_velocity *= SPEED
		connect("body_entered", self, "kill_on_singleplayer")



func _integrate_forces(state):
	if bullet_state_queue.empty() == true:
		return
	var bullet_state = bullet_state_queue.pop_front()
	var taransform = state.get_transform()
	taransform.origin = bullet_state.Pos
	set_linear_velocity(bullet_state.LV)
	bullet_state_queue.clear()
	state.set_transform(taransform)

func append_new_state(bullet_state, time_diff):
	append_timer_n.start(time_diff * 0.001)
	yield(append_timer_n, "timeout")
	bullet_state_queue.append(bullet_state)


func _on_LifeTime_timeout():
	die()

func die():
	var player = get_node_or_null(player_path)
	if !(player == null):
		player.ammo_left += 1
	queue_free()

func kill_on_singleplayer(body):
	if !body.is_in_group("Players"):	return
	body.die()
	die()
