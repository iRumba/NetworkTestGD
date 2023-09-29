extends Object

class_name Message

#enum Messages {
#	NOTHING = 0,
#	LOGIN_PLAYER = 1,
#	YOU_LOGGED_IN = 2,
#	ALLREADY_LOGGED_IN = 3
#}

#var message_type: Messages

## key is int message identifier and value is type of message that extends Message
static func register_message_type(type):
	MessageConfiguration.add_message(type)
	
static func register_response(type, response_type):
	MessageConfiguration.add_response(type, response_type)
	
static func create_response_of(inst: Message) -> Message:
	return MessageConfiguration.get_response_type(inst.get_script()).new()
	
static func create(type) -> Message:
	if !MessageConfiguration.is_registered(type):
		printerr("Message type ", type.resource_path, " not registered")
		return null
	
	var inst = type.new()
	
	return inst

static func get_id_by_instance(inst) -> int:
	return MessageConfiguration.get_id(inst.get_script())
	
static func create_by_id(id: int):
	if !MessageConfiguration.has_id(id):
		printerr("Message type id ", id, " not registered")
		return null
		
	var inst = MessageConfiguration.get_message_type(id).new()
	
	return inst

#class MessageInfo extends Object:
#	var message: Messages
#	var _data: Dictionary
#
#	func _init(m: Messages):
#		message = m
#
#	func set_data(d):
#		_data = inst_to_dict(d)
#
#	func get_data():
#		if _data == null:
#			return null
#
#		return dict_to_inst(_data)
#
#	func pack() -> Dictionary:
#		return inst_to_dict(self)
#
#	static func unpack(packed: Dictionary) -> MessageInfo:
#		return dict_to_inst(packed)

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
	
func handle_message(callback: Callable, need_data: bool = false, need_peer: bool = false):
	var message_id: int = __get_message_id()
	if !MessageConfiguration.has_id(message_id):
		printerr("Message not registered")
		return
	
	Exchange.configure_handle(message_id, create_message_callback(callback, need_data, need_peer))
	
func handle_response(handler: Callable, need_data: bool = false, need_peer: bool = false):
	var message_id: int = __get_message_id()
	if !MessageConfiguration.has_id(message_id):
		printerr("Message not registered")
		return
		
	if !MessageConfiguration.has_response(self.get_script()):
		printerr("Response not registered")
		return
		
	var resp_message_type = MessageConfiguration.get_response_type(self.get_script())
	var resp_message_id = MessageConfiguration.get_id(resp_message_type)
	
	Exchange.configure_handle(resp_message_id, create_message_callback(handler, need_data, need_peer))
	
func create_response_callback(callback: Callable, need_data: bool, need_peer: bool) -> Callable:
	return func(peer_id: int, msg: Dictionary):
		var c = callback
		var message = deserialize(msg)
		
		if message is Exchange.ErrorResponse:
			c = create_error_callback(peer_id, message)
		else:
			if need_data:
				c = c.bind(message)
			
			if need_peer:
				c = c.bind(peer_id)
			
		var res = c.call()
		
		if res is Message:
			res.send_to(peer_id)
		
func create_error_callback(peer_id: int, error: Exchange.ErrorResponse) -> Callable:
	return func():
		printerr("Message: ", get_script().resource_path, " Peer: ", peer_id, " Error: ", Exchange.Errors.keys()[error.error], " Message: ", error.message)
	
func create_message_callback(callback: Callable, need_data: bool, need_peer: bool) -> Callable:
	return func(peer_id: int, msg: Dictionary):
		var c = callback
		if need_data:
			c = c.bind(deserialize(msg))
		
		if need_peer:
			c = c.bind(peer_id)
			
		var res = c.call()
		
		if res is Message:
			res.send_to(peer_id)
	
func serialize() -> Dictionary:
	return inst_to_dict(self)
	
func deserialize(dict: Dictionary) -> Message:
	var msg = dict_to_inst(dict)
	return msg
	
func __get_message_id() -> int:
	return get_id_by_instance(self)
	
func create_response() -> Message:
	return create_response_of(self)
	
static func instance():
	push_error("Not implemented")
	printerr("Call instance on class extends Message")
	
class MessageConfiguration extends Object:
	# key is int message identifier and value is type of message that extends Message
	# for example { 1: MyMessage, 2: OtherMessage }
	static var types_by_ids: Dictionary = {}
	
	static var ids_by_types: Dictionary = {}
	static var responses_types: Dictionary = {}
	
	static func add_message(type):
		if is_registered(type):
			printerr("Message type ", type.resource_path, " already registered")
			return
			
		var index = ids_by_types.size()
			
		types_by_ids[index] = type
		ids_by_types[type] = index
		
	static func add_response(type, response_type):
		if !is_registered(type):
			printerr("Message type ", type.resource_path, " not registered")
			return
			
		if !is_registered(response_type):
			printerr("Message type ", response_type.resource_path, " not registered")
			return
			
		if responses_types.has(type):
			printerr("Response for message type ", type.resource_path, " already registered")
			return
			
		responses_types[type] = response_type

	static func get_message_type(id: int):
		if !is_registered(id):
			printerr("Message with id ", id, " not found")
			return
		
		return types_by_ids[id]
	
	static func get_response_type(type):
		if !responses_types.has(type):
			printerr("Response for message type ", type.resource_path, " already registered")
			return
			
		return responses_types[type]
		
	static func is_registered(type) -> bool:
		return ids_by_types.has(type)
		
	static func has_id(id: int) -> bool:
		return types_by_ids.has(id)
		
	static func has_response(type) -> bool:
		return responses_types.has(type)
		
	static func get_id(type) -> int:
		return ids_by_types[type]
			
#class LoginResultMsg extends Message:
#	func send():
#		printerr("Use send_to istead of send")
#
#	func __get_message() -> Messages:
#		return Messages.ALLREADY_LOGGED_IN
#
#	static func instance() -> LoginResultMsg:
#		return LoginResultMsg.new()
