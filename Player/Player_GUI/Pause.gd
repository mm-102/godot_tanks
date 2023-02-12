extends Node



func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		$PauseButton.set_pressed(!$PauseButton.is_pressed())

func _on_ExitToMenuButton_pressed():
	get_tree().paused = false
	get_node("/root/Main").exit_to_menu()

func _on_PauseButton_toggled(button_pressed):
	var is_multiplayer = get_node("/root/Main").is_multiplayer
	if !(is_multiplayer):
		get_tree().paused = button_pressed
	$PauseWindow.set_visible(button_pressed)
