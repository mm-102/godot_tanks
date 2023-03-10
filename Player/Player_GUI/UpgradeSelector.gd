extends PanelContainer

const upgrade_tscn = preload("res://Player/Player_GUI/Upgrade.tscn")
var choosen_upgrades: Dictionary
var state = null
onready var upgrade_container = $"%UpgradeContainer"
onready var points_left = $"%PointsLeft"
onready var label_self_destroyed = $"%LabelSelfDestroyed"
onready var background = $"%Background"

func _ready():
	Transfer.connect("recive_player_possible_upgrades", self, "show_upgrades")
	#show_upgrades({"State": "SelfDestroyed", "Points": 2, "Upgrades": [["Tank", "Speed"]]})


func show_upgrades(data):
	if data.State == null:
		points_left.text = str(int(points_left.get_text()) + data.AdditionalPoint)
		show()
		if state == "Normal":
			disable_buttons(false)
		if state == "SelfDestroyed":
			disable_buttons(true)
		return
	points_left.text = str(data.Points)
	state = data.State
	for upgrade_info in data.Upgrades:
		var inst = upgrade_tscn.instance()
		inst.connect("upgrade_selected", self, "_on_upgrade_selected")
		inst.init(upgrade_info)
		upgrade_container.add_child(inst)
	match data.State:
		"Normal":
			background.get_stylebox("panel").set_bg_color(Color(0,0.2,1,0.3))
			pass
		"SelfDestroyed":
			background.get_stylebox("panel").set_bg_color(Color(0.1,0.1,0.1,0.8))
			label_self_destroyed.show()
			disable_buttons(true)
		"Winner":
			background.get_stylebox("panel").set_bg_color(Color(0.5,0.2,0.8,0.3))
	if data.Points == 0:
		disable_buttons(true)
	show()

func _on_upgrade_selected(upgrade):
	points_left.text = str(int(points_left.text) - 1)
	if !choosen_upgrades.has(upgrade):
		choosen_upgrades[upgrade] = 1
	else:
		choosen_upgrades[upgrade] += 1
	if points_left.text == "0":
		disable_buttons(true)
		Transfer.fetch_player_possible_upgrades(choosen_upgrades)

func disable_buttons(value):
	for upgrade in upgrade_container.get_children():
		upgrade.disable(value)
	
