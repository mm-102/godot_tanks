extends RigidBody2D

export(Ammunition.TYPES) var ammo_type = Ammunition.TYPES.BULLET

const SPEED = 100
const ROTATION_SPEED = 2
const BULLET_SPEED = 200
const MAX_AMMO = 5
const DEATH_TIME = 20
const BASE_AMMO_TYPE = Ammunition.TYPES.BULLET

signal special_ammo_change(type, amount_left)

var ammo_left = MAX_AMMO
var special_ammo = {
	Ammunition.TYPES.ROCKET : 0,
	Ammunition.TYPES.FRAG_BOMB : 0
}
var dead = false
# Defined in code
var player_stance: Dictionary 

onready var is_multiplayer = $"/root/Main".is_multiplayer
#var projectiles_tscn = {
#	AMMO_TYPES.BULLET: preload("res://Player/Projectiles/Bullet.tscn"),
#	AMMO_TYPES.ROCKET: preload("res://Player/Projectiles/Rocket.tscn"),
#	AMMO_TYPES.FRAG_BOMB: preload("res://Player/Projectiles/FragBomb.tscn")
#}
onready var animation_player = $"%AnimationPlayer"
onready var turret_node =  $"%Turret"
onready var bullet_point_node = $"%BulletPoint"


func _ready():
	connect("special_ammo_change",get_node("/root/Main/Player_Gui_Layer/GUI"),"_on_special_ammo_change")

func _integrate_forces(_state):
	var velocity = Vector2.ZERO
	velocity.y = int(Input.is_action_pressed("p_backward")) - int(Input.is_action_pressed("p_forward"))
	var direction = int(Input.is_action_pressed("p_right")) - int(Input.is_action_pressed("p_left"))
	if velocity.y > 0:
		direction = -direction
	player_stance = {
		"T": OS.get_ticks_msec(),
		"P": position,
		"R": rotation,
		"TR": turret_node.global_rotation,
	}
	if is_multiplayer:
		$"/root/Transfer".fetch_stance(player_stance)
	set_angular_velocity(direction * ROTATION_SPEED)
	set_linear_velocity(velocity.rotated(rotation) * SPEED)
	if Input.is_action_just_pressed("p_shoot"):
		call_deferred("_shoot")



func _shoot():
	if ammo_left <= 0:
		return
	if ammo_type == BASE_AMMO_TYPE or special_ammo[ammo_type] <= 0:
		ammo_type = BASE_AMMO_TYPE
	else:
		special_ammo[ammo_type] -= 1
		emit_signal("special_ammo_change", ammo_type, special_ammo[ammo_type])
	ammo_left -= 1
	if is_multiplayer:
		$"/root/Transfer".fetch_shoot(player_stance, ammo_type)
	var bullet_inst = Ammunition.get_tscn(ammo_type).instance()
	var rot = turret_node.global_rotation
	var velocity = Vector2.UP.rotated(rot)
	bullet_inst.position = bullet_point_node.global_position
	bullet_inst.player_path = get_path()
	bullet_inst.set_linear_velocity(velocity * BULLET_SPEED)
	get_node("/root/Main/Map/Projectiles").add_child(bullet_inst)

func _on_base_body_entered(body):
	if !body.is_in_group("Projectiles"):
		return
	dead = true
	animation_player.play("explode")
	set_deferred("mode", RigidBody2D.MODE_STATIC)
	set_angular_velocity(0)
	set_linear_velocity(Vector2.ZERO)
	body.die()
	
	var timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start(DEATH_TIME)


func _on_timer_timeout():
	queue_free()
