extends Node

var _messages_callbacks: Dictionary = {}


func __on_receive(message: int, callback: Callable):
	if callback.get_bound_arguments_count() > 1:
		printerr("Callback function must have 0 or 1 arguments")
		return
	if !_messages_callbacks.has(message):
		var new_arr: Array[Callable] = []
		_messages_callbacks[message] = new_arr
	
	var callbacks: Array[Callable] = _messages_callbacks[message]
	
	callbacks.append(callback)
	
#@rpc("any_peer")
#func __response(message: int)

@rpc("any_peer")
func __send(message: int, data: Dictionary):
	#var message = Message.MessageInfo.unpack(packed_message)
	if !_messages_callbacks.has(message):
		return
		
	var callbacks: Array[Callable] = _messages_callbacks[message]
	for callback in callbacks:
		var sender = multiplayer.get_remote_sender_id()
		var res = callback.call(sender, data)
		
	pass
