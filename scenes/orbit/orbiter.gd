extends Node3D

## The maximum distance from the origin the controller can travel
@export var max_radius: float = 100


func _ready():
	$OrbitCamera.look_at(self.global_position)


func _process(_delta):
	set_position($OrbitController.global_position)

	if global_position.length() > max_radius:
		set_position(position.normalized() * max_radius)

	$OrbitController.set_position(Vector3.ZERO)
	$OrbitController.transform.basis = $OrbitCamera.transform.basis
