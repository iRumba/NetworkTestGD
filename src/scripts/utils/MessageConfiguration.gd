extends Object

class_name MessageConfiguration

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
