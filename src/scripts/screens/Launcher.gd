extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/CenterContainer/Server.pressed.connect(launch_server)
	$HBoxContainer/CenterContainer2/Client.pressed.connect(launch_client)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func launch_server():
	get_tree().change_scene_to_packed(Resources.Screens.ServerInit)
	pass
	
func launch_client():
	get_tree().change_scene_to_packed(Resources.Screens.ClientInit)
	pass
