extends Node3D


func _ready():
	$OrbitCamera.look_at(self.global_position)


func _process(_delta):
	set_position($OrbitController.global_position)
	$OrbitController.set_position(Vector3.ZERO)
	$OrbitController.transform.basis = $OrbitCamera.transform.basis
