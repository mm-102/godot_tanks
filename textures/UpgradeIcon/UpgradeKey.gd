extends GDScript

const ICONS = {
	"BaseAmmoType": preload("res://textures/UpgradeIcon/reload-gun-barrel.svg"),
	"Type": preload("res://textures/UpgradeIcon/cluster-bomb.svg"),
	
	"Speed": preload("res://textures/UpgradeIcon/speedometer.svg"),
	"RotationSpeed": preload("res://textures/UpgradeIcon/rapidshare-arrow.svg"),
	"MaxAmmoTypes": preload("res://textures/UpgradeIcon/ammo-box.svg"),
	"BaseAmmoClipSize": preload("res://textures/UpgradeIcon/machine-gun-magazine.svg"),
	"AutoloadTimeMultiplier": preload("res://textures/UpgradeIcon/striking-arrows.svg"),
	"LifeTime": preload("res://textures/UpgradeIcon/sands-of-time.svg"),
	"Reload": preload("res://textures/UpgradeIcon/clockwise-rotation.svg"),
	"FollowSpeed": preload("res://textures/UpgradeIcon/flag-objective.svg"),
	"Count": preload("res://textures/UpgradeIcon/chaingun.svg"),
	"Scale": preload("res://textures/UpgradeIcon/resize.svg"),
	"LifetimeMultiplayer": preload("res://textures/UpgradeIcon/time-trap.svg"),
	"Length": preload("res://textures/UpgradeIcon/thrust-bend.svg"),
	"MaxWidth": preload("res://textures/UpgradeIcon/smash-arrows.svg"),
	"ChargeTime": preload("res://textures/UpgradeIcon/double-diaphragm.svg"),
}

static func get_image(attribute):
	if attribute == null:
		return
	if !ICONS.has(attribute):
		return preload("res://icon.png")
	return ICONS[attribute]
