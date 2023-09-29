extends Node

class_name ClientProcessing

var connector: Connector

func _ready() -> void:
	multiplayer.server_disconnected.connect(_on_disconnect)
	_init_connector()
	
func _init_connector():
	connector = Connector.new()
	connector.Connected.connect(_on_connect)
	add_child(connector)
	
func _on_connect():
	connector.queue_free()
	connector = null
	get_tree().change_scene_to_packed(Resources.Screens.ClientAuth)
	
func _on_disconnect():
	get_tree().change_scene_to_packed(Resources.Screens.ClientInit)
	queue_free()
