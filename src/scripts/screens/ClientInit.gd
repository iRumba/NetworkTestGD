extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/VBoxContainer/Join.pressed.connect(join)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func join():
	var address = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/Address.text
	var port = int($CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Port.text)
	Network.client_init(address, port)
