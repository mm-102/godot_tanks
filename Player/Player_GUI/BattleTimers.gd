extends PanelContainer

var time_left
onready var end_round_label = $TopLabel
onready var start_round_label = $"%MiddleLabel"
onready var start_round_background = $"%ColorRect"
onready var clock = $SecClock
onready var battle_start_timer = $BattleStartTimer
onready var t_clock_n = get_node(Dir.T_CLOCK)



func _ready():
	Transfer.connect("phase_recived", self, "_on_phase_recived")
	start_round_background.hide()
	set_process(false)

func _process(delta):
	start_round_label.set_text(str(battle_start_timer.get_time_left()).left(4))

func _on_phase_recived(phase):
	match phase.Name:
		"Prepare":
			start_battle_time(phase.ClosingTick)
		"Battle":
			_on_battle_over_time(phase.ClosingTick)
		"Upgrade":
			end_round_label.set_modulate(Color.aqua)
			get_tree().set_pause(true)
			_on_battle_over_time(phase.ClosingTick)

func start_battle_time(closing_tick):
	var left_sec = (closing_tick - t_clock_n.get_time())*0.001
	battle_start_timer.start(left_sec)
	set_process(true)
	start_round_background.show()

func _on_battle_over_time(closing_tick):
	var left_sec = (closing_tick - t_clock_n.get_time())*0.001
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
	get_tree().set_pause(false)
