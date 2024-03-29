extends Node

const INTERPOLATION_OFFSET = 100
var client_clock: int setget ,get_time
var latency: int
var latency_arr: Array
var time_difference: int


func get_time():
	return client_clock

func _physics_process(_delta: float) -> void:
	client_clock = OS.get_ticks_msec() + time_difference - INTERPOLATION_OFFSET

remote func return_begining_time_diff(server_time, client_time):
	if get_tree().get_rpc_sender_id() != 1:
		return
	latency = (OS.get_ticks_msec() - client_time) * 0.5
	time_difference = server_time - OS.get_ticks_msec() + latency
	client_clock = OS.get_ticks_msec() + time_difference - INTERPOLATION_OFFSET

func _on_TimeDiffTimer_timeout():
	rpc_id(1, "rec_determine_time_diff", OS.get_ticks_msec())

remote func return_time_diff(server_time, client_time):
	if get_tree().get_rpc_sender_id() != 1:
		return
	latency_arr.append((OS.get_ticks_msec() - client_time) * 0.5)
	if latency_arr.size() == 7:
		var total_latency = 0
		latency_arr.sort()
		var mid_point = latency_arr[3]
		for i in range(latency_arr.size() -1, -1, -1):
			if latency_arr[i] > (2 * mid_point) and latency_arr[i] > 20:
				latency_arr.remove(i)
			else:
				total_latency += latency_arr[i]
		latency = total_latency / latency_arr.size()
		time_difference = server_time - OS.get_ticks_msec() + latency
		latency_arr.clear()
#		print("Client: ", client_clock, " | Server: ", server_time, " | Time diff: ", server_time - client_clock)
		


