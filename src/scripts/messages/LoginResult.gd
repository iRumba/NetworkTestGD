extends Message

class_name LoginResult

enum Results {
	FAIL = 0,
	LOGGED_IN = 1,
	ALREADY_LOGGED = 2
}

var result: Results
