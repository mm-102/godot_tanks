extends TextureRect

const upgrade_tscn = preload("res://Singleplayer/GUI/Upgrade.tscn")
const upgrade_special_tscn = preload("res://Singleplayer/GUI/UpgradeSpecial.tscn")

onready var master_n = get_node(Dir.MASTER)
onready var upgrade_container = $"%UpgradeContainer"

func _ready():
	load_special_upgrades()
	load_upgrades()

func load_special_upgrades():
	var all_special_upgrades = GameSettings.SPECIAL_DEFAULT
	for upgrade_path in all_special_upgrades:
		var upgrade_inst = upgrade_special_tscn.instance()
		upgrade_inst.get_node("Name").set_modulate(Color.darkmagenta)
		var value = get_value_asterix(upgrade_path)
		upgrade_inst.connect("value_entered", self, "_on_value_entered")
		upgrade_inst.setup(upgrade_path, value)
		upgrade_container.add_child(upgrade_inst)
		
func load_upgrades():
	var all_upgrades = GameSettings.DEFAULT
	for upgrade_path in all_upgrades:
		var upgrade_inst = upgrade_tscn.instance()
		var value = get_value_asterix(upgrade_path)
		upgrade_inst.connect("value_entered", self, "_on_value_entered")
		upgrade_inst.setup(upgrade_path, value)
		upgrade_container.add_child(upgrade_inst)

func reset_upgrades_values():
	var all_upgrades = GameSettings.DEFAULT
	var i = 0 # gdscript doesn't have enumerate :(
	for value in all_upgrades.values():
		upgrade_container.get_child(i).set_value(value)
		i += 1
		
func get_value_asterix(upgrade_path : Array):
	var last_path_pice = upgrade_path.pop_back()
	var temp_dict = GameSettings.Dynamic
	for path_pice in upgrade_path:
		temp_dict = temp_dict[path_pice]
	upgrade_path.append(last_path_pice)
	return temp_dict[last_path_pice]
	

func _on_SettingsButton_toggled(button_pressed):
	var is_multiplayer = master_n.is_multiplayer
	if !(is_multiplayer): # just in case
		get_tree().paused = button_pressed
	set_visible(button_pressed)

func _on_value_entered(path : Array, new_value):
	var last_path_pice = path.pop_back()
	var temp_dict = GameSettings.Dynamic
	for pice in path:
		temp_dict = temp_dict[pice]
	path.append(last_path_pice)
	temp_dict[last_path_pice] = new_value
