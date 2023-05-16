extends Node2D
class_name Highlight

## Draw a circle around a given object, when this node is visible.

## The radius of the circle to draw in pixels
@export var radius: float = 10.0
## Width of the line in ??? units
@export var width: float = 1.0
## Number of points used to construct the circle
@export var points: int = 25
## The color of the circle
@export var color: Color = Color.RED

@onready var camera = get_viewport().get_camera_3d()


func _draw():
	var world_pos = get_parent().global_position
	var screen_pos = camera.unproject_position(world_pos)

	if not camera.is_position_behind(world_pos):
		draw_arc(screen_pos, radius, 0, TAU, points, color, width, true)


func _process(_delta):
	if not camera.is_position_behind(get_parent().global_position):
		queue_redraw()
