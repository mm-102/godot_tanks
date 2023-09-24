extends Node2D

export(Ammunition.TYPES) var turret_type
export(PackedScene) var shootable_tscn
var is_reloading = true
var shooter: Tank = null setget set_shooter
func set_shooter(new):
	shooter = new
	color = shooter.color
var color: Color = Color.white
onready var spawn_point = $RotateAtMouse/ProjectileSpawnPoint
onready var turret_transform = $RotateAtMouse
onready var gun_checker = $RotateAtMouse/GunInsideWallChecker
var ammunition_clip_res: AmmunitionSlotObj = null setget set_ammunition_clip_res
func set_ammunition_clip_res(new):
	ammunition_clip_res = new
	if ammunition_clip_res:
		start_reloading()
	else:
		is_reloading = false



func _ready():
	$Reload.connect("timeout", self, "_on_reloaded")
	
func _unhandled_input(event):
	if event.is_action_pressed("p_shoot") and not is_reloading:
		if not ammunition_clip_res:
			call_deferred("shoot")
			return
		
		if ammunition_clip_res.amount > 0:
			ammunition_clip_res.amount -= 1
			if ammunition_clip_res.amount != 0:
				start_reloading()
			else:
				no_ammo()
			call_deferred("shoot")
#		if GameSettings.Dynamic.Ammunition[special_ammo[ammo_slot].type].has("ChargeTime"):
#			call_deferred("_charge_shoot")
#			return

func _exit_tree():
	is_reloading = true

func start_reloading():
	is_reloading = true
	$Reload.start(ammunition_clip_res.reload_time)
	ammunition_clip_res.state = AmmunitionSlotObj.STATES.LOADING
	

func _on_reloaded():
	ammunition_clip_res.state = AmmunitionSlotObj.STATES.LOADED
	is_reloading = false

func no_ammo():
	is_reloading = true
	ammunition_clip_res.state = AmmunitionSlotObj.STATES.NOT_SELECTED

func get_turret_global_rotation() -> float:
	return $RotateAtMouse.global_rotation

func shoot():
	if gun_checker.is_gun_inside_wall():
		return
	
	var bullet_inst = shootable_tscn.instance()
	var shootable_data = ShootableSetupData.new()
	shootable_data.position = spawn_point.global_position
	shootable_data.rotation = turret_transform.global_rotation + PI * 0.5
	shootable_data.shooter = shooter
	shootable_data.color = color
	bullet_inst.setup(shootable_data)
	get_tree().get_root().add_child(bullet_inst)
	#shot_successful()
