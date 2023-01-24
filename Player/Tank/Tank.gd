extends RigidBody2D

export(Ammunition.TYPES) var ammo_type = Ammunition.TYPES.BULLET
var ammo_slot = 0

const SPEED = 100
const ROTATION_SPEED = 2
const BULLET_SPEED = 200
const MAX_AMMO = 50
const CORPSE_LIFE_TIME = 20
const BASE_AMMO_TYPE = Ammunition.TYPES.BULLET
const MAX_AMMO_TYPES = 3 # including default bullet


signal special_ammo_change(type, amount_left)
signal special_ammo_type_change(new_type)

var ammo_left = MAX_AMMO
#var special_ammo = {
#	Ammunition.TYPES.BULLET : INF,
#	Ammunition.TYPES.ROCKET : 0,
#	Ammunition.TYPES.FRAG_BOMB : 0,
#	Ammunition.TYPES.LASER : INF
#}
var special_ammo = [
	 {"type" : ammo_type, "amount" : INF}
]
#var dead = false
# Defined in code
var player_stance: Dictionary 
var nick = "You"
var laser_path = NodePath("")

onready var is_multiplayer = $"/root/Main".is_multiplayer
#var projectiles_tscn = {
#	AMMO_TYPES.BULLET: preload("res://Player/Projectiles/Bullet.tscn"),
#	AMMO_TYPES.ROCKET: preload("res://Player/Projectiles/Rocket.tscn"),
#	AMMO_TYPES.FRAG_BOMB: preload("res://Player/Projectiles/FragBomb.tscn")
#}
onready var animation_player = $"%AnimationPlayer"
onready var turret_node =  $"%Turret"
onready var bullet_point_node = $"%BulletPoint"
onready var laset_point_node = $"%LaserPoint"
onready var gun_ray_cast_node = $"%GunRayCast"
onready var camera2d_n = $"%Camera2D"



func set_display_name(text):
	nick = text
	$"%NickLabel".text = text

func _ready():
	#warning-ignore:return_value_discarded
	connect("special_ammo_change",get_node("/root/Main/PlayerGUILayer/GUI"),"_on_special_ammo_change")
	#warning-ignore:return_value_discarded
	connect("special_ammo_type_change",get_node("/root/Main/PlayerGUILayer/GUI"),"_on_special_ammo_type_change")
#	get_node(Paths.MAP_N).connect("map_rect", self, "set_camera_limit")
	set_camera_limit()
	gun_ray_cast_node.cast_to = bullet_point_node.position
	gun_ray_cast_node.add_exception(self)

func set_camera_limit():
	var map_rect = get_node(Paths.MAP_N).get_map_boundaries()
	if map_rect == null:
		print("[Tank]: Get map rect too quick. Consider signal method.")
		return
	camera2d_n.limit_left = map_rect.Pos.x
	camera2d_n.limit_top = map_rect.Pos.y
	camera2d_n.limit_right = map_rect.End.x
	camera2d_n.limit_bottom = map_rect.End.y
	print(map_rect.End)

func pick_up_ammo_box(type):
	var picked = false
	var type_slot = {}
	for slot in special_ammo.size():
		type_slot[special_ammo[slot].type] = slot
	if type_slot.has(type):
		special_ammo[type_slot[type]].amount += 1
		picked = true
	elif special_ammo.size() < MAX_AMMO_TYPES:
		special_ammo.push_back({"type" : int(type), "amount" : 1})
		type_slot[special_ammo[-1].type] = -1
		picked = true
	if picked:
		emit_signal("special_ammo_change", type, special_ammo[type_slot[type]].amount)
	return picked

func _integrate_forces(_state):
	if Input.is_action_just_pressed("p_slot_0"):
		ammo_slot = 0
		emit_signal("special_ammo_type_change", ammo_slot)
	
	if Input.is_action_just_pressed("p_slot_1"):
		if special_ammo.size() > 1:
			ammo_slot = 1
			emit_signal("special_ammo_type_change", ammo_slot)
	
	if Input.is_action_just_pressed("p_slot_2"):
		if special_ammo.size() > 2:
			ammo_slot = 2
			emit_signal("special_ammo_type_change", ammo_slot)
	
	if Input.is_action_just_pressed("p_slot_3"):
		if special_ammo.size() > 3:
			ammo_slot = 3
			emit_signal("special_ammo_type_change", ammo_slot)
	
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
#	if Input.is_action_just_pressed("p_shoot"):
#		call_deferred("p_shoot")
#		print("tank")

func _unhandled_input(event):	#prevent shooting while clicking on gui		maybe all player input should go here?
	if event.is_action_pressed("p_shoot"):
		call_deferred("_shoot")

func _shoot():
	if ammo_left <= 0:
		return
	
	gun_ray_cast_node.enabled = true
	gun_ray_cast_node.force_raycast_update()
	if gun_ray_cast_node.is_colliding() and !gun_ray_cast_node.get_collider().is_in_group("Players"):
		print(gun_ray_cast_node.get_collider())
		gun_ray_cast_node.enabled = false
		return
	gun_ray_cast_node.enabled = false
		
	special_ammo[ammo_slot].amount -= 1
	ammo_left -= 1
	player_stance = {
		"T": OS.get_ticks_msec(),
		"P": position,
		"R": rotation,
		"TR": turret_node.global_rotation,
	}
	if is_multiplayer:
		$"/root/Transfer".fetch_shoot(player_stance, ammo_slot)
		
	else:
		var bullet_inst = Ammunition.get_tscn(special_ammo[ammo_slot].type).instance()
		bullet_inst.setup(self)
		get_node("/root/Main/Game/Projectiles").add_child(bullet_inst)
	
	emit_signal("special_ammo_change", special_ammo[ammo_slot].type, special_ammo[ammo_slot].amount)
	if special_ammo[ammo_slot].amount <= 0:
		special_ammo.pop_at(ammo_slot)
		ammo_slot = 0


func _on_base_body_entered(body):
	if !body.is_in_group("Projectiles") or is_multiplayer:
		return
	body.die()
	die()
	

func die():
	queue_free()
#	remove_from_group("Players")
#	add_to_group("Corpse")
#	$AudioStreamPlayer2D.play()
#	animation_player.play("explode")
#	set_deferred("mode", RigidBody2D.MODE_STATIC)
#	set_angular_velocity(0)
#	set_linear_velocity(Vector2.ZERO)
#
#	var timer = Timer.new()
#	timer.connect("timeout", self, "_on_timer_timeout")
#	add_child(timer)
#	timer.start(CORPSE_LIFE_TIME)
	
	var spectator_camera : Camera2D = load("res://Player/Spectator/Spectator.tscn").instance()
	spectator_camera.global_position = global_position
	spectator_camera.current = true
	get_node("/root/Main/Game/Players").add_child(spectator_camera)
func _on_timer_timeout():
	queue_free()
