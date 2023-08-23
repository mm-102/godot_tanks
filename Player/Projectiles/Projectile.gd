extends RigidBody2D
class_name Projectile

#var s:Dictionary

var player_path = NodePath("")
var bullet_state_queue: Array
var left_time = 0
onready var append_timer_n = $AppendTimer
onready var life_timer = $LifeTime
export var scalable: Array 


export(float) var speed:float = 200
export(float) var life_time:float = 10
var shooter = null
var is_multiplayer = false

export var frag_speed_multiplier = 0.7
export var frag_lifetime_multiplier = 0.5
export var frag_scale_multiplier = 0.5



func setup(data: ShootableSetupData, is_frag = false):
	if is_frag:
		make_frag()
	self.position = data.position
	self.set_linear_velocity(Vector2.UP.rotated(data.rotation) * speed)
	shooter = data.shooter

func make_frag():
	speed *= frag_speed_multiplier
	life_time *= frag_lifetime_multiplier
	for node_path in scalable:
		get_node(node_path).scale *= frag_scale_multiplier

func setup_multi(bullet_data : Dictionary):
	set_name(bullet_data.ID)
	position = bullet_data.P
	set_linear_velocity(bullet_data.V)
	left_time = (bullet_data.DT - Transfer.get_time()) * 0.001


func _ready():
	$LifeTime.start(life_time)
	if is_multiplayer:
		pass
#		if player_path != NodePath(""):
#			linear_velocity *= SPEED
	else:
		var _err = connect("body_entered", self, "kill_on_singleplayer")
		



func _init():
	var append_timer = Timer.new()
	append_timer.name = "AppendTimer"
	append_timer.one_shot = true
	add_child(append_timer)


func _integrate_forces(state):
	update_bounce(state)

func update_bounce(state):
	if bullet_state_queue.empty() == true:
		return
	if bullet_state_queue[0].ST > Transfer.get_time():
		return
	var bullet_state = bullet_state_queue.pop_front()
	var taransform = state.get_transform()
	taransform.origin = bullet_state.Pos
	set_linear_velocity(bullet_state.LV)
	state.set_transform(taransform)

func append_new_state(bullet_state):
	bullet_state_queue.append(bullet_state)


func _on_LifeTime_timeout():
	die()

func die():
	queue_free()

func kill_on_singleplayer(body):
	if not body.is_in_group("Players"):
		return
	body.die()
	die()
