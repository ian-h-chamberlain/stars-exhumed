extends Node2D
class_name Highlight

## Draw a circle around a given object, when this node is visible.

@export var radius: float = 7.0

## Width of the line in ??? units
@export var width: float = 1.0
## Number of points used to construct the circle
@export var points: int = 50

## The color of the circle when th
@export var selected_color: Color = Color.RED
@export var hover_color: Color = Color.BLUE

enum State { SELECTED, HOVERED, OFF }
## The selected state of the highlight circle
@export var state: State = State.OFF

@onready var _camera = get_viewport().get_camera_3d()


func _draw():
	var world_pos = get_parent().global_position
	var screen_pos = _camera.unproject_position(world_pos)

	if _camera.is_position_behind(world_pos):
		return

	var color = Color()

	match state:
		State.SELECTED:
			color = selected_color
		State.HOVERED:
			color = hover_color
		_:
			return

	draw_arc(screen_pos, radius, 0, TAU, points, color, width, true)


func _process(_delta):
	queue_redraw()
