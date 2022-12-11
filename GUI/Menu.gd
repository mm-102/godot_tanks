	extends Control

const ADRESS = {
	0: "127.0.0.1",
	1: "194.187.72.136",
}
onready var main_node = $"/root/Main"



func _on_SingleplayerButton_pressed():
	main_node.game_mode(0, null)
	queue_free()

func _on_MultiplayerButton_pressed():
	main_node.game_mode(1, ADRESS[$"%OptionButton".get_selected()])
	queue_free()


func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	var err = $HTTPRequest.request("https://api.ipify.org/?format=json")
	if err != 0:
		var err_comm ="Ipify non connected: " + str(err)
		$"%PublicIPButton".set_text(err_comm)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
#	$"%PublicIPButton".set_text(str(json.result["ip"]))
	$HTTPRequest.queue_free()
