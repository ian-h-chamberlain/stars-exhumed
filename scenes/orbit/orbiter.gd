extends Node3D

## The maximum distance from the origin the controller can travel
@export var max_radius: float = 100

@onready var _controller: Node3D = $OrbitController


func _process(_delta):
	if _controller.global_position.length() > max_radius:
		_controller.global_position = _controller.global_position.normalized() * max_radius
