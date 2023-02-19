extends PanelContainer

onready var master_n = get_node(Dir.MASTER)


func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		$PauseButton.set_pressed(!$PauseButton.is_pressed())

func _on_ExitToMenuButton_pressed():
	get_tree().paused = false
	master_n.exit_to_menu()

func _on_PauseButton_toggled(button_pressed):
	var is_multiplayer = master_n.is_multiplayer
	if !(is_multiplayer):
		get_tree().paused = button_pressed
	set_visible(button_pressed)
