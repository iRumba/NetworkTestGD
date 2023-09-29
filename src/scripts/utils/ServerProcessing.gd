extends Node

class_name ServerProcessing

var connector: Connector

var players: Dictionary = {}

func _ready() -> void:
	var message: LoginPlayer = Message.subscribe(LoginPlayer, _on_player_logged, true, true)
	
	_init_connector()

func _init_connector():
	connector = Connector.new()
	connector.Connected.connect(_on_connect)
	add_child(connector)

func _on_connect():
	connector.queue_free()
	connector = null
	get_tree().change_scene_to_packed(Resources.Screens.ServerMain)

func _on_player_logged(peer_id: int, login: LoginPlayer) -> LoginResult:
	var resp: LoginResult = Message.create(LoginResult)
	if !players.has(peer_id):
		resp.result = LoginResult.Results.ALREADY_LOGGED
	else:
		var player = Player.new()
		player.player_name = login.player_name
		players[peer_id] = player
		resp.result = LoginResult.Results.LOGGED_IN
		
	return resp
