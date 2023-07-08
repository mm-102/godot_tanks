extends VBoxContainer

func _ready():
	get_node(Dir.GAME + "/Spectator").connect("started_spectating", self, "_on_started_spectating")

func reason_decoder(reason):
	var reason_text = "unknown"
	if typeof(reason) == TYPE_INT:
		reason_text = "Game is full. You are in queue: " + str(reason)
	elif reason == "DuringGame":
		reason_text = "Game in progress."
	elif reason == "SelfDied":
		reason_text = "Player destroyed"
	$Reason.text = reason_text

func _on_started_spectating(reason):
	self.show()
	reason_decoder(reason)
	
