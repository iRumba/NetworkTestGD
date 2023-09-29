extends Object

class_name LoginResult

enum Results {
	FAIL = 0,
	LOGGED_IN = 1,
	ALREADY_LOGGED = 2
}

var result: Results

func _init(r: Results) -> void:
	result = r
