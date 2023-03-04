extends PanelContainer

var time_left
onready var end_round_label = $TopLabel
onready var start_round_label = $"%MiddleLabel"
onready var start_round_background = $"%ColorRect"
onready var clock = $SecClock
onready var battle_start_timer = $BattleStartTimer
onready var t_clock_n = get_node(Dir.T_CLOCK)



func _ready():
	Transfer.connect("recive_battle_over_time", self, "_on_battle_over_time")
	start_round_background.hide()
	set_process(false)

func _process(delta):
	start_round_label.set_text(str(battle_start_timer.get_time_left()).left(4))

func start_battle_time(ms_to_new_game):
	var left_sec = (ms_to_new_game - t_clock_n.get_time())*0.001
	battle_start_timer.start(left_sec)
	set_process(true)
	start_round_background.show()

func _on_battle_over_time(time_to_end):
	end_round_label.set_modulate(Color.aqua)
	battle_time(time_to_end)

func battle_time(ms_to_new_game):
	print(t_clock_n.get_time(), "     NEW GAME: ", ms_to_new_game)
	var left_sec = (ms_to_new_game - t_clock_n.get_time())*0.001
	end_round_label.show()
	time_left = left_sec
	clock.start()
	if left_sec == INF:
		end_round_label.hide()
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
	#test
	get_tree().set_pause(false)
