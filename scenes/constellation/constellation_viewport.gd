class_name ConstellationViewport
extends SubViewport

@onready var _camera: Camera3D = get_parent().get_viewport().get_camera_3d()

var _viewport_cam: Camera3D


func _ready():
	_viewport_cam = _camera.duplicate()
	_viewport_cam.make_current()
	add_child(_viewport_cam)

	add_child($"../DrawConstellation".duplicate())


func _process(_delta):
	_viewport_cam.global_transform = _camera.global_transform
