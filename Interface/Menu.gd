extends Control

const ADRESS = {
	0: "127.0.0.1",
	1: "194.187.72.136",
}
var config = ConfigFile.new()
onready var master_n = get_node(Dir.MASTER)
onready var multiplayer_button = $"%MultiplayerButton"
onready var multiplayer_refresh = $"%MultiplayerRefresh"
onready var version_n = $"%Version"

var rng = RandomNumberGenerator.new()


func _ready():
	set_init_data()
	set_version(Functions.get_version())

func set_init_data():
	var err = config.load("user://initial_data.cfg")
	if err != OK:
		return
	var menu_data = config.get_section_keys("Menu")
	$"%PlayerNickInput".text = config.get_value("Menu", "Nick")
	$"%OptionButton"._select_int(int(config.get_value("Menu", "SelectInt")))
	

func set_version(version):
	if version == null:
		version_n.set_text("debug")
		return
	var text_v = "v" + str(version)
	version_n.set_text(text_v)

func old_version_info():
	version_n.add_color_override("font_color", Color(1,0,0))
	multiplayer_refresh.stop()
	multiplayer_button.disabled = true
	$OldVersionInfo.show()


func _on_SingleplayerButton_pressed():
	master_n.nick = $"%PlayerNickInput".text
	master_n.game_mode(0)
	save_data($"%PlayerNickInput".text, $"%OptionButton".get_selected())
	queue_free()


func _on_MultiplayerButton_pressed():
	master_n.nick = $"%PlayerNickInput".text
	rng.randomize()
	master_n.player_color = Color.from_hsv(rng.randf(), 1.0, 1.0) # temp
	Transfer.ip = ADRESS[int($"%OptionButton".get_selected())]
	Transfer._connect_to_server()
	save_data($"%PlayerNickInput".text, $"%OptionButton".get_selected())
	multiplayer_button.set_disabled(true)
	multiplayer_refresh.start()

func _on_MultiplayerRefresh_timeout():
	multiplayer_button.set_disabled(false)

func save_data(nick, select_int):
	# Store some values.
	config.set_value("Menu", "Nick", nick)
	config.set_value("Menu", "SelectInt", select_int)

	# Save it to a file (overwrite if already exists).
	config.save("user://initial_data.cfg")
	
