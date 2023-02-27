extends PanelContainer

onready var scores_n = $Scores
onready var template_player_container_n = $Scores/Headers



func _input(event : InputEvent):
	if event.is_action_pressed("Scoreboard"):
		set_visible(true)
	if event.is_action_released("Scoreboard"):
		set_visible(false)
	

func add_scoreboard_player(player_id, data):
	var score = data.Score
	var nick = data.Nick
	var player_name_score = template_player_container_n.duplicate()
	player_name_score.name = str(player_id)
	if nick.empty():
		nick = "Player" + str(player_id)
	player_name_score.get_node("Nick").text = str(nick)# + ' : '
	player_name_score.get_node("Wins").text = str(score.Wins)# + ' : '
	player_name_score.get_node("Kills").text = str(score.Kills)
	scores_n.add_child(player_name_score)


func player_destroyed(destroyed_id, slayer_id):
	cross_player_nick(destroyed_id)
	if destroyed_id != int(slayer_id):
		add_kill_point(slayer_id)

func cross_player_nick(destroyed_id):
	var player_container_cross_line_n = scores_n.get_node_or_null(str(destroyed_id) + "/Nick/CrossLine")
	player_container_cross_line_n.set_visible(true)

func add_kill_point(slayer_id):
	var player_name_score = scores_n.get_node_or_null(str(slayer_id) + "/Kills")
	if player_name_score == null:
		return
	var kills = int(player_name_score.get_text())
	kills += 1
	scores_n.get_node(str(slayer_id) + "/Kills").set_text(str(kills))
	
