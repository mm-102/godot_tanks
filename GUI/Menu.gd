	extends Control

const ADRESS = {
	0: "127.0.0.1",
	1: "194.187.72.136",
}
onready var main_node = $"/root/Main"



func _on_SingleplayerButton_pressed():
	main_node.game_mode(0, null)
	queue_free()

func _on_MultiplayerButton_pressed():
	main_node.game_mode(1, ADRESS[$"%OptionButton".get_selected()])
	queue_free()
