extends Object

class_name Message
	
static func create_response_for(inst: Message) -> Message:
	return MessageConfiguration.get_response_type(inst.get_script()).new()
	
static func has_response(type) -> bool:
	return MessageConfiguration.has_response(type)
	
static func create(type) -> Message:
	if !MessageConfiguration.is_registered(type):
		printerr("Message type ", type.resource_path, " not registered")
		return null
	
	var inst = type.new()
	
	return inst

static func get_id_by_instance(inst: Message) -> int:
	return get_id_by_type(inst.get_script())

static func get_id_by_type(type) -> int:
	return MessageConfiguration.get_id(type)
	
static func is_registered_type(type) -> bool:
	return MessageConfiguration.is_registered(type)
	
static func get_response_message_id(type) -> int:
	var resp_type = MessageConfiguration.get_response_type(type)
	return MessageConfiguration.get_id(resp_type)
	
static func subscribe(type, callback: Callable, need_data: bool = false, need_peer: bool = false):
	if !is_registered_type(type):
		printerr("Message not registered")
		return
		
	var message_id: int = get_id_by_type(type)
	
	Exchange.configure_handle(message_id, __create_callback(type, callback, need_data, need_peer))
	
static func subscribe_response(type, handler: Callable, need_data: bool = false, need_peer: bool = false):
	if !is_registered_type(type):
		printerr("Message not registered")
		return
		
	if !has_response(type):
		printerr("Response not registered")
		return		
		
	var resp_message_id = get_response_message_id(type)
	
	Exchange.configure_handle(resp_message_id, __create_callback(type, handler, need_data, need_peer))
	
static func __create_callback(type, callback: Callable, need_data: bool, need_peer: bool) -> Callable:
	return func(peer_id: int, msg: Dictionary):
		
		var message = __deserialize(msg)
		
		if message is Exchange.ErrorResponse:
			__create_error_callback(type, peer_id, message).call()
			
		else:
			var c = callback
			
			if need_data:
				c = c.bind(message)
			
			if need_peer:
				c = c.bind(peer_id)
				
			var res = c.call()
			
			if res is Message:
				res.send_to(peer_id)
				
static func __create_error_callback(type, peer_id: int, error: Exchange.ErrorResponse) -> Callable:
	return func():
		printerr("Message: ", type.resource_path, " Peer: ", peer_id, " Error: ", Exchange.Errors.keys()[error.error], " Message: ", error.message)
		
static func __deserialize(dict: Dictionary):
	var msg = dict_to_inst(dict)
	return msg

func send():
	var data = serialize()
	if data == null:
		return
	
	Exchange.send.rpc(__get_message_id(), data)
	pass

func send_to(peer_id: int):
	var data = serialize()
	if data == null:
		return
		
	Exchange.send.rpc_id(peer_id, __get_message_id(), data)
	pass
	
func serialize() -> Dictionary:
	return inst_to_dict(self)
	
func __get_message_id() -> int:
	return get_id_by_instance(self)
	
func create_response() -> Message:
	return create_response_for(self)
	
static func instance():
	push_error("Not implemented")
	printerr("Call instance on class extends Message")
