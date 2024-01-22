extends Resource
class_name AmmunitionSlotObj

signal state_changed(state)

enum STATES{NOT_SELECTED, LOADING, LOADED}

export(Ammunition.TYPES) var ammo_type = -1 setget set_ammo_type
func set_ammo_type(new):
	ammo_type = new
	emit_changed()
export(STATES) var state: int = false setget set_state
func set_state(new):
	state = new
	emit_signal("state_changed", state)
	emit_changed()
export(int) var amount = -1 setget set_amount
func set_amount(new):
	if amount == 0\
			and new > 0:
		start_loading()
	amount = new
	emit_changed()
export(int) var reload_time = 0 
var timer: Timer = Timer.new()



func _init():
	timer.one_shot = true
	AmmunitionSlotTimers.add_child(timer)
	timer.connect("timeout", self, "_on_timeout")


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		timer.queue_free()

func make_shot(shooted):
	set_amount(amount - shooted)
	if amount <= 0:
		set_state(STATES.NOT_SELECTED)
	else:
		start_loading()


func start_loading():
	set_state(STATES.LOADING)
	timer.start(reload_time)


func finish_loading():
	if not timer.is_stopped():
		timer.stop()
	set_state(STATES.LOADED)


func _on_timeout():
	finish_loading()
