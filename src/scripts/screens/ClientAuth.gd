extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/VBoxContainer/LogIn.pressed.connect(login)
	$CenterContainer/VBoxContainer/Disconnect.pressed.connect(Network.close_connection)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func login():
	Message.subscribe_response(LoginPlayer, logged_in, true, false)
	var message: LoginPlayer = Message.create(LoginPlayer)
	message.player_name = $CenterContainer/VBoxContainer/PlayerName.text
	message.send()

func logged_in(login_result: LoginResult):
	get_tree().change_scene_to_packed(Resources.Screens.ClientMain)

func close_connection():
	Network.close_connection()
