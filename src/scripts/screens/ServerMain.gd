extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/Terminate.pressed.connect(_on_terminate)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_terminate():
	Network.close_connection()
