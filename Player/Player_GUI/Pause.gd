extends TextureRect


func _on_ExitToMenuButton_pressed():
	get_tree().paused = false
	get_tree().root.get_node("Main").exit_to_menu()
