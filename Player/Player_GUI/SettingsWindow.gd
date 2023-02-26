extends TextureRect


onready var master_n = get_node(Dir.MASTER)


func _on_SettingsButton_toggled(button_pressed):
	var is_multiplayer = master_n.is_multiplayer
	if !(is_multiplayer): # just in case
		get_tree().paused = button_pressed
	set_visible(button_pressed)
