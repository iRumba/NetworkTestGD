extends Object

class_name Message

enum Messages {
	NOTHING = 0,
	LOGIN_PLAYER = 1,
	YOU_LOGGED_IN = 2,
	ALLREADY_LOGGED_IN = 3
}

class MessageInfo extends Object:
	var message: Messages
	var _data: Dictionary
	
	func _init(m: Messages):
		message = m
		
	func set_data(d):
		_data = inst_to_dict(d)
		
	func get_data():
		if _data == null:
			return null
			
		return dict_to_inst(_data)
		
	func pack() -> Dictionary:
		return inst_to_dict(self)
		
	static func unpack(packed: Dictionary) -> MessageInfo:
		return dict_to_inst(packed)

func __send_message(data):
	pass

func send(data):
	var message = prepare_message(data)
	if message == null:
		return
	
	Exchange.__send.rpc(message.message, message.pack())
	pass
	
func send_to(peer_id: int, data):
	var message = prepare_message(data)
	if message == null:
		return
		
	Exchange.__send.rpc_id(peer_id, message.message, message.pack())
	pass
	
func sign(callback: Callable, need_data: bool = false, need_peer: bool = false):
	var message_type: Messages = __get_message()
	if message_type == Messages.NOTHING:
		printerr("Please, call this function from concrete class that extends Message")
		return
	
	Exchange.__on_receive(message_type, create_message_callback(callback, need_data, need_peer))
	
func create_message_callback(callback: Callable, need_data: bool, need_peer: bool) -> Callable:
	return func(peer_id: int, msg: Dictionary):
		var c = callback
		if need_data:
			var message = Message.MessageInfo.unpack(msg)
			c = c.bind(message.get_data())
		
		if need_peer:
			c = c.bind(peer_id)
			
		c.call()
	
func prepare_message(data) -> MessageInfo:
	var message_type = __get_message()
	
	if message_type == Messages.NOTHING:
		printerr("Please, call this function from concrete class that extends Message")
		return null
	
	var mi = MessageInfo.new(message_type)
	mi.set_data(data)
	return mi
	
func __get_message() -> Messages:
	return Messages.NOTHING
	
static func instance():
	printerr("Call instance on class extends Message")
	
class LoginPlayer extends Message:
	func send(data: PlayerLogin):
		send_to(1, data)
		
	func __get_message() -> Messages:
		return Messages.LOGIN_PLAYER

	static func instance() -> LoginPlayer:
		return LoginPlayer.new()
		
class YouLoggedIn extends Message:
	func send(data):
		printerr("Use send_to istead of send")
		
	func __get_message() -> Messages:
		return Messages.YOU_LOGGED_IN

	static func instance() -> YouLoggedIn:
		return YouLoggedIn.new()

class AlreadyLoggedIn extends Message:
	func send(data):
		printerr("Use send_to istead of send")
		
	func __get_message() -> Messages:
		return Messages.ALLREADY_LOGGED_IN

	static func instance() -> AlreadyLoggedIn:
		return AlreadyLoggedIn.new()

class LoginResultMsg extends Message:
	func send(data):
		printerr("Use send_to istead of send")
		
	func __get_message() -> Messages:
		return Messages.ALLREADY_LOGGED_IN

	static func instance() -> LoginResultMsg:
		return LoginResultMsg.new()
