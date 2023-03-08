extends TextureRect

const upgrade_tscn = preload("res://Singleplayer/GUI/Upgrade.tscn")

onready var master_n = get_node(Dir.MASTER)
onready var upgrade_container = $UpgradeContainer

func _ready():
	load_upgrades()

func load_upgrades():
	var all_upgrades = GameSettings.STATIC
	for upgrade_path in all_upgrades:
		var upgrade_inst = upgrade_tscn.instance()
		var value = get_value_asterix(upgrade_path)
		upgrade_inst.connect("text_entered", self, "_on_text_entered")
		upgrade_inst.setup(upgrade_path, value)
		upgrade_container.add_child(upgrade_inst)

func get_value_asterix(upgrade_path):
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

func _on_text_entered(path, new_value):
	var last_path_pice = path.pop_back()
	var temp_dict = GameSettings.Dynamic
	for pice in path:
		temp_dict = temp_dict[pice]
	path.append(last_path_pice)
	temp_dict[last_path_pice] = int(new_value)
