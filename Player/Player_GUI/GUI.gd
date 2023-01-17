extends MarginContainer


var current_type = Ammunition.TYPES.BULLET

const selection_color = "70ffff"
const base_color = "ffffff"

onready var Numbers = {
	Ammunition.TYPES.ROCKET : $"Ammunition/RocketCounter/Background/Number",
	Ammunition.TYPES.FRAG_BOMB : $"Ammunition/FragBombCounter/Background/Number",
	Ammunition.TYPES.LASER : $"Ammunition/LaserCounter/Background/Number"
}

onready var Backgrounds = {
	Ammunition.TYPES.BULLET : $"Ammunition/BulletCounter/Background",
	Ammunition.TYPES.ROCKET : $"Ammunition/RocketCounter/Background",
	Ammunition.TYPES.FRAG_BOMB : $"Ammunition/FragBombCounter/Background",
	Ammunition.TYPES.LASER : $"Ammunition/LaserCounter/Background"
}

onready var scores_node = $"Scoreboard/Scores"
const name_score_tscn = preload("res://Player/Player_GUI/NameScore.tscn")


func _ready():
	Backgrounds[current_type].modulate = selection_color

# ---- display ammo ----
func _on_special_ammo_change(type, amount_left):
	Numbers[type].text = str(amount_left)

func _on_special_ammo_type_change(new_type):
	Backgrounds[current_type].modulate = base_color
	Backgrounds[new_type].modulate = selection_color
	
	current_type = new_type
	
# ---- pause ----
func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		$PauseButton.pressed = !$PauseButton.pressed

func _on_PauseButton_toggled(button_pressed):
	var is_multiplayer = get_tree().root.get_node("Main").is_multiplayer
	if !(is_multiplayer):
		get_tree().paused = button_pressed
		
	$Pause.visible = button_pressed

# ---- scoreboard ----

func _on_new_scoreboard_player(name, player_name):
	var player_name_score = name_score_tscn.instance()
	player_name_score.name = name
	player_name_score.get_node("Name").text = player_name + ':'
	player_name_score.get_node("Score").text = "0"
	scores_node.add_child(player_name_score)

func _on_delete_scoreboard_player(name):
	var player_name_score = scores_node.get_node_or_null(name)
	if player_name_score == null: return
	player_name_score.queue_free()

func _on_update_player_score(name, score=0):
	var player_name_score = scores_node.get_node_or_null(name)
	if player_name_score == null: return
	player_name_score.get_node("Score").text = str(score)
	

