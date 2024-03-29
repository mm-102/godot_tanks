class_name GameSettings

const AT = Ammunition.TYPES
const MAX_UPGRADES = 3
const VALUE_PER_POINT = 0.1



static func get_all_players_upgrades(players_data):
	var upgrades: Array = []
	for player_data in players_data:
		upgrades.append(player_data.Upgrades)
	return upgrades

static func set_dynamic_settings(players_data, current_special_upgrades):
	for path in DEFAULT:
		set_base_value(path, DEFAULT[path])
	for path in SPECIAL_DEFAULT:
		set_base_value(path, SPECIAL_DEFAULT[path])
	var all_upgrades = get_all_players_upgrades(players_data)
	for players_upgrades in all_upgrades:
		for path in players_upgrades:
			var value = players_upgrades[path] 
			value *= DEFAULT[path] * VALUE_PER_POINT
			add_value(path, value)
	for path in current_special_upgrades:
		var value = current_special_upgrades[path].Val
		set_base_value(path, value)

static func set_base_value(path, value):
	var last = path.pop_back()
	var temp_dict = Dynamic
	for step in path:
		temp_dict = temp_dict[step]
	path.append(last)
	assert(temp_dict.has(last), str("[GameSettings] ", path, " doesn't have ", last, " value"))
	temp_dict[last] = value

static func add_value(path, value):
	var last = path.pop_back()
	var temp_dict = Dynamic
	for step in path:
		temp_dict = temp_dict[step]
	path.append(last)
	temp_dict[last] += value


const SPECIAL_DEFAULT = {
	["Tank", "BaseAmmoType"]:  Ammunition.TYPES.BULLET,
	["Ammunition", AT.FRAG_BOMB, "Frag", "Type"]: AT.BULLET,
#	["Visibility"]: true,
#	["Camera", "CloseRange"]: false,
}

const DEFAULT = {
	["Tank", "Speed"]: 120.0,
	["Tank", "RotationSpeed"]: 2.0,
	["Tank", "MaxAmmoTypes"]: 3,
	["Tank", "BaseAmmoClipSize"]: 4,
	["Tank", "AutoloadTimeMultiplier"]: 2,
	
	["Wreck", "LifeTime"]: 20,
	
	["Ammunition", AT.BULLET, "Speed"]: 200,
	["Ammunition", AT.BULLET, "Reload"]: 1,
	["Ammunition", AT.BULLET, "LifeTime"]: 10,
	
	["Ammunition", AT.ROCKET, "Speed"]: 100,
	["Ammunition", AT.ROCKET, "FollowSpeed"]: 150,
	["Ammunition", AT.ROCKET, "Reload"]: 5,
	["Ammunition", AT.ROCKET, "LifeTime"]: 8,
	
	["Ammunition", AT.FRAG_BOMB, "Speed"]: 200,
	["Ammunition", AT.FRAG_BOMB, "Count"]: 10,
	["Ammunition", AT.FRAG_BOMB, "Reload"]: 3,
	["Ammunition", AT.FRAG_BOMB, "LifeTime"]: 5,
	
	["Ammunition", AT.FRAG_BOMB, "Frag", "Speed"]: 0.7,
	["Ammunition", AT.FRAG_BOMB, "Frag", "Scale"]: 0.5,
	["Ammunition", AT.FRAG_BOMB, "Frag", "LifetimeMultiplayer"]: 0.08,
	
	["Ammunition", AT.LASER, "Length"]: 2000,
	["Ammunition", AT.LASER, "MaxBounces"]: 5,
	["Ammunition", AT.LASER, "MaxWidth"]: 5,
	["Ammunition", AT.LASER, "Reload"]: 6,
	["Ammunition", AT.LASER, "ChargeTime"]: 1.5,
	
	["Ammunition", AT.LASER_BULLET, "Speed"]: 300,
	["Ammunition", AT.LASER_BULLET, "Length"]: 50,
	["Ammunition", AT.LASER_BULLET, "MaxBounces"]: 15,
	["Ammunition", AT.LASER_BULLET, "Reload"]: 2,
	["Ammunition", AT.LASER_BULLET, "LifeTime"]: 6,
	
	["Ammunition", AT.FIREBALL, "Speed"]: 200,
	["Ammunition", AT.FIREBALL, "Reload"]: 5,
	["Ammunition", AT.FIREBALL, "LifeTime"]: 5,
}


const Dynamic = {	
	"Tank": {
		"Speed" : null,
		"RotationSpeed" : null,
		"BaseAmmoType" : null,
		"MaxAmmoTypes" : null, # including default bullet
		"BaseAmmoClipSize" : null,
		"AutoloadTimeMultiplier" : null,
	},
	"Wreck": {
		"LifeTime" : null,
	},
	"Ammunition":{
		AT.BULLET:{
			"Speed" : null,
			"Reload" : null,
			"LifeTime": null,
		},
		AT.ROCKET: {
			"Speed" : null,
			"FollowSpeed" : null,
			"Reload" : null,
			"LifeTime": null,
		},
		AT.FRAG_BOMB: {
			"Speed" : null,
			"Count" : null,
			"Reload" : null,
			"LifeTime": null,
			"Frag":{
				"Speed" : null,
				"Scale" : null,
				"LifetimeMultiplayer" : null,
				"Type" : null,
			},
		},
		AT.LASER:{
			"Length" : null,
			"MaxBounces" : null,
			"MaxWidth" : null,
			"Reload" : null,
			"ChargeTime" : null,
			"LifeTime": null,
		},
		AT.LASER_BULLET:{
			"Speed" : null,
			"Length" : null,
			"MaxBounces" : null,
			"Reload" : null,
			"LifeTime": null,
		},
		AT.FIREBALL:{
			"Speed" : null,
			"Reload" : null,
			"LifeTime": null,
		},
	},
}

const STATIC = {
	"CAMERA": {
		"INGAME": {
			"ZOOM_SPEED" : 0.3,
			"MAX_ZOOM_IN" : Vector2(0.1, 0.1),
			"MAX_ZOOM_OUT" : Vector2(2, 2),
		},
		"SPECTATOR": {
			"ZOOM_SPEED" : 0.3,
			"MOVE_SPEED" : 50,
			"MAX_ZOOM_IN" : Vector2(0.1, 0.1),
			"MAX_ZOOM_OUT" : Vector2(100, 100),
		},
	},
	"INDICATORS": {
		"MAX_COUNT" : 5,
		"ARROW_MARGIN" : 20,
	},
}
