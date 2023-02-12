extends PanelContainer

var time_left
onready var label = $Label
onready var clock = $SecClock




func battle_time(left_sec):
	show()
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
	label.set_text(str(mins+":"+secs))
