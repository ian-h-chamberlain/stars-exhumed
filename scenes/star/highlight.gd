extends Node2D
class_name Highlight

## Draw a circle around a given object, when this node is visible.

## The minimum radius of the circle to draw in pixels
@export var min_radius: float = 7.0
## The  maximum radius of the circle to draw in pixels
@export var max_radius: float = 750.0
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

@onready var camera = get_viewport().get_camera_3d()


func _draw():
	var world_pos = get_parent().global_position
	var screen_pos = camera.unproject_position(world_pos)

	if camera.is_position_behind(world_pos):
		return

	var color = Color()

	match state:
		State.SELECTED:
			color = selected_color
		State.HOVERED:
			color = hover_color
		_:
			return

	var distance = (camera.global_position - world_pos).length()
	# Scale up for stars that are closer to the camera. Sheesh this took way too
	# long to find the right curve for....
	var radius = clamp(
		2000 / distance,
		min_radius,
		max_radius,
	)

	print("distance ", distance, " radius ", radius)

	draw_arc(screen_pos, radius, 0, TAU, points, color, width, true)


func _process(_delta):
	queue_redraw()
