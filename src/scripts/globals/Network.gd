extends Node

var players: Dictionary = {}

func _ready():
	pass
	
func server_init(port: int) -> bool:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	
	if peer.get_connection_status() != MultiplayerPeer.CONNECTION_DISCONNECTED:
		multiplayer.multiplayer_peer = peer
		var processor = ServerProcessing.new()
		add_child(processor)
		return true
	else:
		return false
		
func client_init(host: String, port: int) -> bool:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(host, port)
	
	if peer.get_connection_status() != MultiplayerPeer.CONNECTION_DISCONNECTED:
		multiplayer.multiplayer_peer = peer
		var processor = ClientProcessing.new()
		add_child(processor)
		return true
	else:
		return false
		
func close_connection():
	if multiplayer.has_multiplayer_peer():
		multiplayer.multiplayer_peer.close()
	
