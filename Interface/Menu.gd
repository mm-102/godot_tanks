extends Control

const ADRESS = {
	0: "127.0.0.1",
	1: "194.187.72.136",
}
onready var master_n = get_node(Dir.MASTER)
onready var multiplayer_button = $"%MultiplayerButton"
onready var multiplayer_refresh = $"%MultiplayerRefresh"



func _on_SingleplayerButton_pressed():
	master_n.game_mode(0, null, $"%PlayerNickInput".text)
	queue_free()

func _on_MultiplayerButton_pressed():
	master_n.game_mode(1, ADRESS[$"%OptionButton".get_selected()], $"%PlayerNickInput".text)
	multiplayer_button.set_disabled(true)
	multiplayer_refresh.start()

func _on_MultiplayerRefresh_timeout():
	multiplayer_button.set_disabled(false)

