class_name GameSettingsOLD

const AT = Ammunition.TYPES
const MAX_UPGRADES = 3
const VALUE_PER_POINT = 0.1



static func set_dynamic_settings(players_data):
	for path in STATIC:
		var last = path.pop_back()
		var temp_dict = Dynamic
		for step in path:
			temp_dict = temp_dict[step]
		path.append(last)
		temp_dict[last] = STATIC[path]
	var all_upgrades = get_all_players_upgrades(players_data)
	for players_upgrades in all_upgrades:
		for upgrade in players_upgrades:
			var temp_dict = Dynamic
			var temp_orginal_dict = STATIC[upgrade]
			var i = 0
			for path_step in upgrade:
				i += 1
				if i == upgrade.size():
					temp_dict[path_step] += players_upgrades[upgrade] * \
							temp_orginal_dict * \
							VALUE_PER_POINT
					break
				temp_dict = temp_dict[path_step]

static func get_all_players_upgrades(players_data):
	var upgrades: Array = []
	for player_data in players_data:
		upgrades.append(player_data.Upgrades)
	return upgrades



const STATIC = {
	["Tank", "Speed"]: 100.0,
	["Tank", "RotationSpeed"]: 2.0,
	["Tank", "MaxAmmo"]: 5,
	["Tank", "BaseAmmoType"]:  AT.BULLET,
	["Tank", "MaxAmmoTypes"]: 3,

	["Wreck", "LifeTime"]: 20,

	["Ammunition", AT.BULLET, "Speed"]: 200,

	["Ammunition", AT.ROCKET, "Speed"]: 200,
	["Ammunition", AT.ROCKET, "FollowSpeed"]: 150,

	["Ammunition", AT.FRAG_BOMB, "Speed"]: 200,
	["Ammunition", AT.FRAG_BOMB, "Count"]: 30,

	["Ammunition", AT.FRAG_BOMB, "Frag", "Speed"]: 150,
	["Ammunition", AT.FRAG_BOMB, "Frag", "Scale"]: 0.5,
	["Ammunition", AT.FRAG_BOMB, "Frag", "LifetimeMultiplayer"]: 0.2,
	["Ammunition", AT.FRAG_BOMB, "Frag", "Type"]: AT.BULLET,

	["Ammunition", AT.LASER, "Length"]: 2000,
	["Ammunition", AT.LASER, "MaxBounces"]: 15,
	["Ammunition", AT.LASER, "MaxWidth"]: 5,

	["Ammunition", AT.LASER_BULLET, "Speed"]: 200,
	["Ammunition", AT.LASER_BULLET, "Length"]: 50,
	["Ammunition", AT.LASER_BULLET, "MaxBounces"]: 15,

	["Ammunition", AT.FIREBALL, "Speed"]: 200,
}


const Dynamic = {
	"Tank": {
		"Speed" : null,
		"RotationSpeed" : null,
		"MaxAmmo" : null,
		"BaseAmmoType" : null,
		"MaxAmmoTypes" : null, # including default bullet
	},
	"Wreck": {
		"LifeTime" : null,
	},
	"Ammunition":{
		AT.BULLET:{
			"Speed" : null,
		},
		AT.ROCKET: {
			"Speed" : null,
			"FollowSpeed" : null,
		},
		AT.FRAG_BOMB: {
			"Speed" : null,
			"Count" : null,
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
		},
		AT.LASER_BULLET:{
			"Speed" : null,
			"Length" : null,
			"MaxBounces" : null,
		},
		AT.FIREBALL:{
			"Speed" : null,
	},
	}
}

const CAMERA = {
	"ZOOM_SPEED" : 0.3,
	"MAX_ZOOM_IN" : Vector2(0.1, 0.1),
	"MAX_ZOOM_OUT" : Vector2(2, 2),
}

const SPECATOR = {
	"CAMERA":{
		"ZOOM_SPEED" : 0.3,
		"MOVE_SPEED" : 50,
		"MAX_ZOOM_IN" : Vector2(0.1, 0.1),
		"MAX_ZOOM_OUT" : Vector2(100, 100),
	}
}

const INDICATORS = {
	"MAX_COUNT" : 5,
	"ARROW_MARGIN" : 20,
}
