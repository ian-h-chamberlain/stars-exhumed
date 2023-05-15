"""
Simple helper to force the camera to look at the point being orbited on load.
"""

extends Node


func _ready():
	var camera = get_parent()
	var orbit_point = camera.get_parent()
	camera.look_at(orbit_point.global_position)
