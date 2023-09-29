extends Message

class_name LoginPlayer

var player_name: String

func send():
	send_to(1)

static func instance() -> LoginPlayer:
	return LoginPlayer.new()

#func create_response() -> LoginPlayer:
#	return null
