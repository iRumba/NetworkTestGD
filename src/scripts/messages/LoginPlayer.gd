extends Message

class_name LoginPlayer

var player_name: String

func send():
	super.send_to(1)
	
func send_to(peer_id: int):
	push_error("Use send instead")
