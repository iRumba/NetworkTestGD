extends Node

var _messages_callbacks: Dictionary = {}
var _responses_callbacks: Dictionary = {}

enum Errors {
	HANDLER_DOES_NOT_EXISTS = 0,
	HANDLER_FAILED = 1,
	INVALID_DATA
}

class ErrorResponse extends Object:
	var error: Errors
	var message: String

func configure_response(message: int, callback: Callable):
	if _responses_callbacks.has(message):
		printerr("Message " + str(message) + " already has response handler")
		return
		
	_responses_callbacks[message] = callback

func configure_handle(message: int, callback: Callable):
	if _messages_callbacks.has(message):
		printerr("Message " + str(message) + " already has handler")
		return
		
	_messages_callbacks[message] = callback
	
@rpc("any_peer")
func response(message: int, data: Dictionary):
	var sender = multiplayer.get_remote_sender_id()
		
	if !_responses_callbacks.has(message):
		var err = ErrorResponse.new()
		err.error = Errors.HANDLER_DOES_NOT_EXISTS
		printerr("Peer ", sender, " send response to message ", message, "but it not handled")
		
	else:	
		var callback: Callable = _responses_callbacks[message]
		callback.call(sender, data)

@rpc("any_peer")
func send(message: int, data: Dictionary):	
	var sender = multiplayer.get_remote_sender_id()
		
	if !_messages_callbacks.has(message):
		printerr("Peer ", sender, " send not handled message ", message)
		
	else:	
		var callback: Callable = _messages_callbacks[message]
		callback.call(sender, data)
	pass
