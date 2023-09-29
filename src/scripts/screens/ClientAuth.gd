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
#	var login = PlayerLogin.new()
#	login.player_name = $CenterContainer/VBoxContainer/PlayerName.text
	var message: LoginPlayer = Message.create(LoginPlayer)
	message.player_name = $CenterContainer/VBoxContainer/PlayerName.text
	message.handle_response(logged_in, true, false)
	message.send()
#	Message.LoginResultMsg.instance().sign(logged_in, false, false)
#	Message.LoginPlayer.instance().send(login)

func logged_in(login_result: LoginResult):
	get_tree().change_scene_to_packed(Resources.Screens.ClientMain)

func close_connection():
	Network.close_connection()
