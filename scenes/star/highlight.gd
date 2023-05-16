extends Node2D
class_name Highlight

## Draw a circle around a given object, when this node is visible.

## The radius of the circle to draw in pixels
@export var radius: float = 10.0
## Width of the line in ??? units
@export var width: float = 1.0
## Number of points used to construct the circle
@export var points: int = 25

## The color of the circle when th
@export var selected_color: Color = Color.RED
@export var hover_color: Color = Color.BLUE

enum State { SELECTED, HOVERED, OFF }
## The selected state of the highlight circle
@export var state: State = State.OFF

@onready var camera = get_viewport().get_camera_3d()


func _draw():
	var world_pos = get_parent().global_position
	var screen_pos = camera.unproject_position(world_pos)

	if not camera.is_position_behind(world_pos) and state != State.OFF:
		var color = Color()

		if state == State.SELECTED:
			color = selected_color
		elif state == State.HOVERED:
			color = hover_color

		draw_arc(screen_pos, radius, 0, TAU, points, color, width, true)


func _process(_delta):
	if not camera.is_position_behind(get_parent().global_position):
		queue_redraw()
