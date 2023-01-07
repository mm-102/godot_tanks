	extends Control

const ADRESS = {
	0: "127.0.0.1",
	1: "194.187.72.136",
}
onready var main_node = $"/root/Main"



func _ready():
	#warning-ignore:return_value_discarded
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")


func _on_SingleplayerButton_pressed():
	main_node.game_mode(0, null, $"%PlayerNickInput".text)
	queue_free()

func _on_MultiplayerButton_pressed():
	main_node.game_mode(1, ADRESS[$"%OptionButton".get_selected()], $"%PlayerNickInput".text)
	# freed only on conneciton


func _on_request_completed(_result, _response_code, _headers, body):
	if _result != 0:
		return
	var json = JSON.parse(body.get_string_from_utf8())
	if json.result.has("ip"):
		$"%PublicIPButton".set_text(str(json.result["ip"]))
		$HTTPRequest.queue_free()


func _on_PublicIPButton_pressed():
	#warning-ignore:return_value_discarded
	if has_node("HTTPRequest"):
		$HTTPRequest.cancel_request()
		$"%PublicIPButton".set_text("...")
		var err = $HTTPRequest.request("https://api.ipify.org/?format=json")
		if err != 0:
			var err_comm ="Ipify non connected: " + str(err)
			$"%PublicIPButton".set_text(err_comm)
	else:
		OS.set_clipboard($Background/PublicIPButton.text)
