extends Control
class_name Slot


var ammunition_clip_res: AmmunitionSlotObj = null setget set_ammunition_clip_res
func set_ammunition_clip_res(new):
	ammunition_clip_res = new
	ammunition_clip_res.connect("state_changed", self, "_on_ammunition_clip_res_state_changed")
	ammunition_clip_res.connect("changed", self, "_on_ammunition_clip_res_changed")
	if not self.is_inside_tree():
		yield(self, "ready")
	_on_ammunition_clip_res_changed()
	_on_ammunition_clip_res_state_changed(ammunition_clip_res.state)
	progress_bar.loading_time = ammunition_clip_res.reload_time
onready var slot_rect = $SlotRect
onready var progress_bar = $SlotRect/ProgressBar



func _ready():
	slot_rect.type = -1
	$TouchScreenButton.action = "p_slot_" + str(get_index())
	if ammunition_clip_res != null:
		_on_ammunition_clip_res_changed()
		if ammunition_clip_res.reload_time == 0:
			return
		var timer_value = (ammunition_clip_res.reload_time - ammunition_clip_res.timer.time_left) / ammunition_clip_res.reload_time
		progress_bar.loading_from_time(ammunition_clip_res.timer.time_left, timer_value)
		progress_bar.loading_time = ammunition_clip_res.reload_time

func set_type(type):
	$SlotRect.set_type(type)
	

func is_inside_visible(is_visible: bool):
	$SlotRect/TypeRect.visible = is_visible
	$Number.visible = is_visible


func _on_ammunition_clip_res_changed():
	slot_rect.set_type(ammunition_clip_res.ammo_type)
	slot_rect.set_amount_left_text(ammunition_clip_res.amount)

func _on_ammunition_clip_res_state_changed(state):
	progress_bar.set_state(state)
