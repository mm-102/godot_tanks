extends PanelContainer

const upgrade_tscn = preload("res://Player/Player_GUI/Upgrades/Upgrade.tscn")
export (bool) var show_all_upgrades = false
var choosen_upgrades: Dictionary
var state = null
onready var upgrade_container = $"%UpgradeContainer"
onready var points_left = $"%PointsLeft"
onready var label_self_destroyed = $"%LabelSelfDestroyed"
onready var background = $"%Background"
onready var title = $"%Title"
onready var label_points = $"%LabelPoints"



func _ready():
	Transfer.connect("recive_player_possible_upgrades", self, "show_upgrades")
	if show_all_upgrades:
		show_all_upgrades()

func show_all_upgrades():
	var i = 0
	for upgrade in GameSettings.DEFAULT:
		show_upgrades({"State": "Normal", "Points": 2, "Upgrades": [upgrade]})
		i += 1

func show_upgrades(data):
	if data.State == null:
		points_left.text = str(int(points_left.get_text()) + data.AdditionalPoint)
		show()
		if state == "Normal":
			disable_buttons(false)
		if state == "SelfDestroyed":
			disable_buttons(true)
		return
	state = data.State
	points_left.text = str(data.Points)
	for upgrade_info in data.Upgrades:
		var inst = upgrade_tscn.instance()
		inst.connect("upgrade_selected", self, "_on_upgrade_selected")
		var data1 = upgrade_info.duplicate()
		if typeof(data.Upgrades) == TYPE_DICTIONARY:
			data1.append(data.Upgrades[upgrade_info])
		inst.init(data1, state)
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
			title.set_text("Choose a special upgrade for")
			label_points.set_text("Duration of upgrade (rounds): ")
			background.get_stylebox("panel").set_bg_color(Color(0.5,0.2,0.8,0.3))
	if data.Points == 0:
		disable_buttons(true)
	show()

func _on_upgrade_selected(upgrade):
	if state == "Winner":
		disable_buttons(true)
		var value = upgrade.pop_back()
		var dict = {upgrade: value}
		Transfer.fetch_player_possible_upgrades(dict)
		_on_Button_pressed()
		return
	points_left.text = str(int(points_left.text) - 1)
	if !choosen_upgrades.has(upgrade):
		choosen_upgrades[upgrade] = 1
	else:
		choosen_upgrades[upgrade] += 1
	if points_left.text == "0":
		disable_buttons(true)
		Transfer.fetch_player_possible_upgrades(choosen_upgrades)
		_on_Button_pressed()

func disable_buttons(value):
	for upgrade in upgrade_container.get_children():
		upgrade.disable(value)
	

func _on_Button_pressed():
	self.hide()
	Transfer.fetch_update_acknowledge()
	
