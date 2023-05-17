class_name Constellation
extends Node

# The indices of the stars in this constellation, in order.
var stars: Array[int] = []:
	get:
		return stars

# Whether the constellation is "set" or not.
var is_valid: bool = false:
	get:
		return _camera_transform != Transform3D()

# How many stars are in this constellation.
var length: int = 0:
	get:
		return len(stars)

# The transform of the camera when the constellation was recorded.
var _camera_transform: Transform3D = Transform3D()


func _to_string() -> String:
	return "Constellation(%s)" % [stars]


# Returns whether the star was added or not
func add_star(idx: int) -> bool:
	if idx in stars:
		return false

	stars.push_back(idx)
	return true

func pop_star():
	if length > 0:
		return stars.pop_back()

	return null


func peek():
	if length > 0:
		return stars.back()

	return null


func finish(camera: Camera3D) -> void:
	self._camera_transform = camera.global_transform
