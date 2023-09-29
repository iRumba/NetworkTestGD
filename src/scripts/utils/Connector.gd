extends Node

class_name Connector

signal Connected()

func _process(_delta: float) -> void:
	if !multiplayer.has_multiplayer_peer():
		return
	
	if multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		Connected.emit()
		self.process_mode = Node.PROCESS_MODE_DISABLED
