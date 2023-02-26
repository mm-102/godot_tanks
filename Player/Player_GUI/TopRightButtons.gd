extends HBoxContainer


var current_selection = ""

# make sure there is only 1 option selected at once
func _on_button_toggled(button_pressed, button_name=""):
	if !button_pressed:
		current_selection = ""
		return
	if !current_selection.empty():
		get_node(current_selection).pressed = false
	current_selection = button_name
