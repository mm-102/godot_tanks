extends PanelContainer

const upgrade_tscn = preload("res://Player/Player_GUI/Upgrade.tscn")
var choosen_upgrades: Dictionary
onready var upgrade_container = $"%UpgradeContainer"
onready var points_left = $"%PointsLeft"


func _ready():
	Transfer.connect("recive_player_possible_upgrades", self, "show_upgrades")

func show_upgrades(upgrades, points, self_destroyed):
	points_left.text = str(points)
	if self_destroyed:
		points_left.text = points_left.text + " (Self-destroyed. No points)"
	for upgrade_info in upgrades:
		var inst = upgrade_tscn.instance()
		inst.connect("upgrade_selected", self, "_on_upgrade_selected")
		inst.init(upgrade_info)
		upgrade_container.add_child(inst)
	if points != 0 and !self_destroyed:
		disable_buttons(false)
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
	
