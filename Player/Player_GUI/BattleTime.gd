extends PanelContainer

var time_left
onready var end_round_label = $TopLabel
onready var start_round_label = $"%MiddleLabel"
onready var start_round_background = $"%ColorRect"
onready var clock = $SecClock
onready var battle_start_timer = $BattleStartTimer



func _ready():
	start_round_background.hide()
	set_process(false)


func _process(delta):
	start_round_label.set_text(str(battle_start_timer.get_time_left()).left(4))
	


func start_battle_time(ms_to_new_game):
	var left_sec = (ms_to_new_game - get_node(Paths.T_CLOCK).get_time())*0.001
	battle_start_timer.start(left_sec)
	set_process(true)
	start_round_background.show()
	

func battle_time(left_sec):
	if left_sec == INF:
		clock.set_paused(true)
		return
	if left_sec == -1:
		clock.set_paused(false)
		return
	end_round_label.show()
	time_left = left_sec
	clock.start()
	_on_TimeLeftClock_timeout()

func proper_time_format(val)->String:
	if val < 0:
		return str("00")
	if val < 10:
		return str("0"+str(val))
	return str(val)

func _on_TimeLeftClock_timeout():
	time_left = time_left - 1
	var mins = proper_time_format(int(time_left) / 60)
	var secs = proper_time_format(int(time_left) % 60)
	end_round_label.set_text(str(mins+":"+secs))


func _on_BattleStartTimer_timeout():
	start_round_background.hide()
	set_process(false)
	get_tree().set_pause(false)
