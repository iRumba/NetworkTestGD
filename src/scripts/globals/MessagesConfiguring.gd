extends Node

func _ready() -> void:
	__configure()

func __configure():
	Message.register_message_type(LoginPlayer)
	Message.register_message_type(LoginResult)
	Message.register_response(LoginPlayer, LoginResult)
	pass
