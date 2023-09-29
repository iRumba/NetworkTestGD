extends Control

var d: Dictionary
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var a = B.new()
	var script: GDScript = A
	print(is_instance_of(a, script))
	
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
	
class A extends Object:
	func foo():
		print("foo")
	pass
	
class B extends A:
	static func bar():
		print("bar")
