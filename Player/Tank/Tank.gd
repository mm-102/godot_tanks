extends RigidBody2D

signal special_ammo_event(type, amount_left)

const tank_wreck = preload("res://Player/Tank/TankWreck.tscn")
#const laser_charge_tscn = preload("res://Player/Particles/ChargeLaserBeamParticles.tscn")

var ammo_slot = 0

var RNG = RandomNumberGenerator.new()
var old_sound=4


var ammo_left = GameSettings.Dynamic.Tank.MaxAmmo
var special_ammo

# Defined in code
var player_stance: Dictionary 
var nick = "You"
var color = Color.blue
var laser_path = NodePath("")

var slot_locked = false # used to lock slot changing
var shooting_locked =  false # used to lock shooting

var s = GameSettings.Dynamic.Tank

onready var main_n = get_node(Dir.MAIN)
onready var transfer_n = get_node(Dir.TRANSFER)
onready var players_n = get_node(Dir.PLAYERS)
onready var projectiles_n = get_node(Dir.PROJECTILES)
onready var is_multiplayer = $"/root/Master".is_multiplayer

onready var animation_player = $"%AnimationPlayer"
onready var turret_node =  $"%Turret"
onready var bullet_point_node = $"%BulletPoint"
onready var gun_ray_cast_node = $"%GunRayCast"
onready var camera2d_n = $"%Camera2D"
onready var reload_timer_n = $ReloadTimer


func set_display_name(text):
	nick = text
	$"%NickLabel".text = text
	
func set_turret_type(type):
	$Turret.frame = type

func _ready():
	#warning-ignore:return_value_discarded
	connect("special_ammo_event",get_node(Dir.GUI_AMMUNITION),"on_special_ammo_event")
	gun_ray_cast_node.cast_to = bullet_point_node.position
	gun_ray_cast_node.add_exception(self)
	$Turret.self_modulate = main_n.local_player_color
	$Sprite.self_modulate = main_n.local_player_color
	color = main_n.local_player_color
	emit_signal("special_ammo_event", "pick_up" , [s.BaseAmmoType, INF])
	set_turret_type(s.BaseAmmoType)
	special_ammo = [
	 {"type" : s.BaseAmmoType, "amount" : INF}
	]


func setup_multi(player_data, local_player_name):
	ammo_left = s.MaxAmmo
	set_name(str(player_data.ID))
	set_position(player_data.P)
	if local_player_name.empty():
		local_player_name = "You"
	set_display_name(local_player_name)
	


func pick_up_ammo_box(type):
	if type == s.BaseAmmoType:
		return false
	
	var picked = false
	var type_slot = {}
	for slot in special_ammo.size():
		type_slot[special_ammo[slot].type] = slot
	if type_slot.has(type):
		special_ammo[type_slot[type]].amount += 1
		picked = true
	elif special_ammo.size() < s.MaxAmmoTypes:
		special_ammo.push_back({"type" : int(type), "amount" : 1})
		type_slot[special_ammo[-1].type] = -1
		picked = true
	get_method_list()
	if picked:
		# [improve] This event 'pick_up' var may be done by constant ".PICK_UP with enum in global file
		emit_signal("special_ammo_event", "pick_up" , [type, special_ammo[type_slot[type]].amount])
	return picked

func _integrate_forces(_state):
	var velocity = Vector2.ZERO
	velocity.y = int(Input.is_action_pressed("p_backward")) - int(Input.is_action_pressed("p_forward"))
	var direction = int(Input.is_action_pressed("p_right")) - int(Input.is_action_pressed("p_left"))
	if velocity.y > 0:
		direction = -direction
	if is_multiplayer:
		player_stance = {
			"T": OS.get_ticks_msec(),
			"P": position,
			"R": rotation,
			"TR": turret_node.global_rotation,
		}
		transfer_n.fetch_stance(player_stance)
	set_angular_velocity(direction * s.RotationSpeed)
	set_linear_velocity(velocity.rotated(rotation) * s.Speed)
	if velocity.y or direction !=0:
		if $ruch1.playing == false and $ruch2.playing== false and $ruch3.playing == false and $ruch4.playing == false:
			RNG.randomize()
			var sound = RNG.randi_range(1,4)
			while old_sound == sound:
				RNG.randomize()
				sound = RNG.randi_range(1,4)
			old_sound=sound
			if sound==1:
				$ruch1.play()
			if sound==2:
				$ruch2.play()
			if sound==3:
				$ruch3.play()
			else:
				$ruch4.play()
				
func _input(event):
	if slot_locked:
		return
	for i in range(10):
		if i >= special_ammo.size():
			break
		if event.is_action_pressed("p_slot_"+str(i)):
			if ammo_slot == i:
				return
			var reload_time = GameSettings.Dynamic.Ammunition[special_ammo[i].type].Reload
			var reload_of_prev_ammo = GameSettings.Dynamic.Ammunition[special_ammo[ammo_slot].type].Reload
			ammo_slot = i
			if !shooting_locked:
				reload_time = max(0.5, reload_time - (reload_of_prev_ammo / 2))
			emit_signal("special_ammo_event", "change_selection", [ammo_slot, reload_time])
			reload_timer_n.start(reload_time)
			shooting_locked = true
			set_turret_type(special_ammo[ammo_slot].type)
			if is_multiplayer:
				transfer_n.fetch_change_ammo_type(special_ammo[ammo_slot].type)
			break

func _unhandled_input(event):	#prevent shooting while clicking on gui		maybe all player input should go here?
	if shooting_locked:
		return
	if event.is_action_pressed("p_shoot"):
		if GameSettings.Dynamic.Ammunition[special_ammo[ammo_slot].type].has("ChargeTime"):
			call_deferred("_charge_shoot")
			return
		call_deferred("_shoot")
		
func _gun_instde_wall() -> bool:
	gun_ray_cast_node.enabled = true
	gun_ray_cast_node.force_raycast_update()
	if gun_ray_cast_node.is_colliding() and !gun_ray_cast_node.get_collider().is_in_group("Players"):
		gun_ray_cast_node.enabled = false
		return true
	gun_ray_cast_node.enabled = false
	return false
	
func _update_slots_after_shoot():
	emit_signal("special_ammo_event", "shoot", [special_ammo[ammo_slot].type, special_ammo[ammo_slot].amount])
	if special_ammo[ammo_slot].amount <= 0:
		special_ammo.pop_at(ammo_slot)
		ammo_slot = 0
		set_turret_type(special_ammo[0].type)

# multiplayer only
func charge(ammo_type): # make universal when more types will need charging
	var particles_tscn = Ammunition.get_charge_particles_tscn(ammo_type)
	if particles_tscn == null:
		return
	var particles = particles_tscn.instance()
	bullet_point_node.add_child(particles)
	particles.start(GameSettings.Dynamic.Ammunition[ammo_type].ChargeTime)

func _charge_shoot(): # make universal when more types will need charging
	if ammo_left <= 0:
		return
	slot_locked = true
	shooting_locked = true
	var type = special_ammo[ammo_slot].type
	
	if is_multiplayer:
		transfer_n.fetch_charge_shoot(type)
		return
		
	var particles_tscn = Ammunition.get_charge_particles_tscn(type)
	if particles_tscn == null:
		shot_failed()
		return
	var particles = particles_tscn.instance()
	bullet_point_node.add_child(particles)
	var charge_time = GameSettings.Dynamic.Ammunition[type].ChargeTime
	particles.start(charge_time)
	var timer = Timer.new()
	timer.one_shot = true
	timer.connect("timeout", self, "_shoot")
	add_child(timer)
	timer.start(charge_time)

func _shoot():
	if ammo_left <= 0:
		return
		
	# ---- ray cast prevent shooting into wall ----
	if _gun_instde_wall():
		return
	
	# ---- main shooting ----
	shooting_locked = true
	slot_locked = true
	if is_multiplayer:
		player_stance = {
			"T": OS.get_ticks_msec(),
			"P": position,
			"R": rotation,
			"TR": turret_node.global_rotation,
		}
		transfer_n.fetch_shoot(player_stance, special_ammo[ammo_slot].type)
		
	else:
		var bullet_inst = Ammunition.get_tscn(special_ammo[ammo_slot].type).instance()
		bullet_inst.setup(self)
		projectiles_n.add_child(bullet_inst)
		shot_successful()
	

func shot_successful():
	special_ammo[ammo_slot].amount -= 1
	ammo_left -= 1
	_update_slots_after_shoot()
	slot_locked = false
	reload_timer_n.start(GameSettings.Dynamic.Ammunition[special_ammo[ammo_slot].type].Reload)

func shot_failed():
	slot_locked = false
	shooting_locked = false

func reload_complete():
	shooting_locked = false

func die():
	queue_free()
	
	if !is_multiplayer:
		var wreck = tank_wreck.instance()
		wreck.name = "Tank"
		wreck.position = position
		wreck.rotation = rotation
		wreck.color = color
		wreck.life_time = INF # [info] <----- From tank instance
		get_node(Dir.GAME + "/Objects").call_deferred("add_child", wreck)
	
	var spectator_camera : Camera2D = load("res://Player/Spectator/Spectator.tscn").instance()
	spectator_camera.global_position = global_position
	spectator_camera.current = true
	players_n.add_child(spectator_camera)

func _on_timer_timeout():
	queue_free()
