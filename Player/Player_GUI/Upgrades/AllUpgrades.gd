extends Control

const value_info_tscn = preload("res://Player/Player_GUI/Upgrades/ValuesInfo.tscn")
var upgrades_reference: Dictionary


func _ready():
	Transfer.connect("phase_recived", self, "_on_phase_recived")
	var i = 0
	var column = 1
	for upgrade_path in GameSettings.DEFAULT.keys():
		if i >= 9:
			i = 0
			column += 1
			assert(column < 6, "[AllUpgrades] Too much upgrades")
		i += 1
		var inst = value_info_tscn.instance()
		upgrades_reference[upgrade_path] = inst
		inst.init(upgrade_path)
		get_node("Holder/Column" + str(column)).add_child(inst)

func add_points(players_data):
	var all_upgrades = GameSettings.get_all_players_upgrades(players_data)
	for players_upgrades in all_upgrades:
		for upgrade_path in players_upgrades:
			var value = players_upgrades[upgrade_path] 
			value *= GameSettings.DEFAULT[upgrade_path] * GameSettings.VALUE_PER_POINT
			upgrades_reference[upgrade_path].add_value(value)


func _on_phase_recived(phase):
#	print(phase.Name)
	match phase.Name:
		"Prepare":
#			print(OS.get_system_time_msecs())
			show()
		"Battle":
#			print(OS.get_system_time_msecs())
			hide()

