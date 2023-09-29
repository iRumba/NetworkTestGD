extends Node

func _ready() -> void:
	__configure_messages()

func __configure_messages():
	MessageConfiguration.add_message(LoginPlayer)
	MessageConfiguration.add_message(LoginResult)
	MessageConfiguration.add_message(LogoutPlayer)
	
	MessageConfiguration.add_response(LoginPlayer, LoginResult)
	pass
