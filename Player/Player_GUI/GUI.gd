extends Control


var current_slot = Ammunition.TYPES.BULLET

const selection_color = "70ffff"
const base_color = "ffffff"

const counters_tscn = {
	Ammunition.TYPES.ROCKET : preload("res://Player/Player_GUI/RocketCounter.tscn"),
	Ammunition.TYPES.FRAG_BOMB : preload("res://Player/Player_GUI/FragBombCounter.tscn"),
	Ammunition.TYPES.LASER : preload("res://Player/Player_GUI/LaserCounter.tscn"),
	Ammunition.TYPES.LASER_BULLET : preload("res://Player/Player_GUI/LaserBulletCounter.tscn"),
	Ammunition.TYPES.FIREBALL : preload("res://Player/Player_GUI/FireballCounter.tscn")
}

const name_score_tscn = preload("res://Player/Player_GUI/SBPlayer.tscn")
onready var scores_node = $"Scoreboard/Scores"

var time_left
onready var battle_timer = $"BattleTimeUpdate"
onready var battle_time_label = $"BattleTimeUpdate/TimerLabel"


func _ready():
	$Ammunition.get_child(current_slot).get_node("Background").modulate = selection_color

func _input(event : InputEvent):
	# ---- pause ----
	if event.is_action_pressed("ui_cancel"):
		$PauseButton.pressed = !$PauseButton.pressed
	
# ---- display ammo ----
func _on_special_ammo_change(type, amount_left):
	if $Ammunition.has_node(str(type)):
		if amount_left <= 0:
			_on_special_ammo_type_change(0)
			$Ammunition.get_node(str(type)).queue_free()
			return
		if amount_left != INF:
			$Ammunition.get_node(str(type) + "/Background/Number").text = str(amount_left)
		return
	var new_counter = counters_tscn[type].instance()
	new_counter.get_node("Background/Number").text = str(amount_left)
	new_counter.name = str(type)
	$Ammunition.add_child(new_counter)


func _on_special_ammo_type_change(new_slot):
	if $Ammunition.get_child_count() > current_slot:
		$Ammunition.get_child(current_slot).get_node("Background").modulate = base_color
	$Ammunition.get_child(new_slot).get_node("Background").modulate = selection_color
	current_slot = new_slot
	
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
	player_name_score.get_node("Nick").text = str(nick)# + ' : '
	player_name_score.get_node("Wins").text = str(score.Wins)# + ' : '
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

# ------- battle time -------
func battle_time(left_sec):
	battle_time_label.show()
	time_left = left_sec
	battle_timer.start()
	_on_BattleTimeUpdate_timeout()

func proper_time_format(val)->String:
	if val < 0:
		return str("00")
	if val < 10:
		return str("0"+str(val))
	return str(val)

func _on_BattleTimeUpdate_timeout():
	time_left = time_left - 1
	var mins = proper_time_format(int(time_left) / 60)
	var secs = proper_time_format(int(time_left) % 60)
	battle_time_label.set_text(str(mins+":"+secs))
