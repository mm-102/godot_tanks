extends RigidBody2D

export(Ammunition.TYPES) var ammo_type
var ammo_slot = 0
var SPEED
var ROTATION_SPEED
var MAX_AMMO
var CORPSE_LIFE_TIME
var BASE_AMMO_TYPE
var MAX_AMMO_TYPES


signal special_ammo_event(type, amount_left)

var ammo_left
var special_ammo = [
	 {"type" : ammo_type, "amount" : INF}
]

# Defined in code
var player_stance: Dictionary 
var nick = "You"
var laser_path = NodePath("")

onready var transfer_n = get_node(Dir.TRANSFER)
onready var players_n = get_node(Dir.PLAYERS)
onready var projectiles_n = get_node(Dir.PROJECTILES)
onready var is_multiplayer = $"/root/Master".is_multiplayer

onready var animation_player = $"%AnimationPlayer"
onready var turret_node =  $"%Turret"
onready var bullet_point_node = $"%BulletPoint"
onready var laset_point_node = $"%LaserPoint"
onready var gun_ray_cast_node = $"%GunRayCast"
onready var camera2d_n = $"%Camera2D"

func apply_settings():
	var settings = $"/root/Master/Settings".SETTINGS
	ammo_left = settings.PLAYER_MAX_AMMO
	ammo_slot = settings.PLAYER_BASE_AMMO_TYPE
	SPEED = settings.PLAYER_SPEED
	ROTATION_SPEED = settings.PLAYER_ROTATION_SPEED
	MAX_AMMO = settings.PLAYER_MAX_AMMO
	CORPSE_LIFE_TIME = settings.CORPSE_LIFE_TIME
	BASE_AMMO_TYPE = settings.PLAYER_BASE_AMMO_TYPE
	MAX_AMMO_TYPES = settings.PLAYER_MAX_AMMO_TYPES

func set_display_name(text):
	nick = text
	$"%NickLabel".text = text

func _ready():
	#warning-ignore:return_value_discarded
	connect("special_ammo_event",get_node(Dir.GUI_AMMUNITION),"on_special_ammo_event")
	$"/root/Master/Settings".connect("apply_changes", self, "apply_settings")
	apply_settings()
	gun_ray_cast_node.cast_to = bullet_point_node.position
	gun_ray_cast_node.add_exception(self)


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
	get_method_list()
	if picked:
		# [improve] This event 'pick_up' var may be done by constant ".PICK_UP with enum in global file
		emit_signal("special_ammo_event", "pick_up" , type, special_ammo[type_slot[type]].amount)
	return picked

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
		transfer_n.fetch_stance(player_stance)
	set_angular_velocity(direction * ROTATION_SPEED)
	set_linear_velocity(velocity.rotated(rotation) * SPEED)

func _input(event):
	if event.is_action_pressed("p_slot_0"):
		ammo_slot = 0
	if event.is_action_pressed("p_slot_1"):
		if special_ammo.size() > 1:
			ammo_slot = 1
	if event.is_action_pressed("p_slot_2"):
		if special_ammo.size() > 2:
			ammo_slot = 2
	if event.is_action_pressed("p_slot_3"):
		if special_ammo.size() > 3:
			ammo_slot = 3

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
		transfer_n.fetch_shoot(player_stance, ammo_slot)
		
	else:
		var bullet_inst = Ammunition.get_tscn(special_ammo[ammo_slot].type).instance()
		bullet_inst.setup(self)
		projectiles_n.add_child(bullet_inst)
	
	emit_signal("special_ammo_event", "shoot", special_ammo[ammo_slot].type, special_ammo[ammo_slot].amount)
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
	players_n.add_child(spectator_camera)

func _on_timer_timeout():
	queue_free()
