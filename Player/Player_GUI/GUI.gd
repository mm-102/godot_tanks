extends Control


var current_type = Ammunition.TYPES.BULLET

const selection_color = "70ffff"
const base_color = "ffffff"

onready var Numbers = {
	Ammunition.TYPES.ROCKET : $"Ammunition/RocketCounter/Background/Number",
	Ammunition.TYPES.FRAG_BOMB : $"Ammunition/FragBombCounter/Background/Number"
}

onready var Backgrounds = {
	Ammunition.TYPES.BULLET : $"Ammunition/BulletCounter/Background",
	Ammunition.TYPES.ROCKET : $"Ammunition/RocketCounter/Background",
	Ammunition.TYPES.FRAG_BOMB : $"Ammunition/FragBombCounter/Background"
}

onready var scores_node = $"Scoreboard/Scores"
const name_score_tscn = preload("res://Player/Player_GUI/SBPlayer.tscn")


func _ready():
	Backgrounds[current_type].modulate = selection_color

func _input(event : InputEvent):
	# ---- pause ----
	if event.is_action_pressed("ui_cancel"):
		$PauseButton.pressed = !$PauseButton.pressed
	
# ---- display ammo ----
func _on_special_ammo_change(type, amount_left):
	Numbers[type].text = str(amount_left)

func _on_special_ammo_type_change(new_type):
	Backgrounds[current_type].modulate = base_color
	Backgrounds[new_type].modulate = selection_color
	
	current_type = new_type
	
	
# ---- pause ----

func _on_PauseButton_toggled(button_pressed):
	var is_multiplayer = get_tree().root.get_node("Main").is_multiplayer
	if !(is_multiplayer):
		get_tree().paused = button_pressed
	$Pause.visible = button_pressed

# ---- scoreboard ----

func add_scoreboard_player(player_id, data):
	var score = data.Score
	var nick = data.Nick
	var player_name_score = name_score_tscn.instance()
	player_name_score.name = str(player_id)
	player_name_score.get_node("Nick").text = str(nick) + ' : '
	player_name_score.get_node("Wins").text = str(score.Wins) + ' : '
	player_name_score.get_node("Kills").text = str(score.Kills)
	scores_node.add_child(player_name_score)

func clear_scores():
	for score in scores_node.get_children():
		if score.name == "Headers":
			continue
		score.queue_free()

func add_kill(player_id):
	var player_name_score = scores_node.get_node_or_null(str(player_id) + "/Kills")
	if player_name_score == null:
		return
	var kills = int(player_name_score.get_text())
	kills += 1
	scores_node.get_node(str(player_id) + "/Kills").set_text(str(kills))
	

func _on_new_scoreboard_player(name, nick):
	var player_name_score = name_score_tscn.instance()
	player_name_score.name = name
	player_name_score.get_node("Name").text = nick + ':'
	player_name_score.get_node("Score").text = "0"
	scores_node.add_child(player_name_score)

func _on_update_player_score(name, score=0):
	var player_name_score = scores_node.get_node_or_null(name)
	if player_name_score == null: return
	player_name_score.get_node("Score").text = str(score)
	

