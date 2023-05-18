extends Node2D

@export var line_width: float = 2
@export var line_color: Color = Color.WHITE
@export var builder: ConstellationBuilder

@onready var _camera := get_viewport().get_camera_3d()


func _process(_delta):
	queue_redraw()


func _draw():
	var current = builder.current_constellation
	_draw_constellation(current)

	for cons in PlayerProgress.constellations:
		_draw_constellation(cons)


func _draw_constellation(cons: Constellation):
	var starfield: StarfieldGenerator = builder.starfield

	for i in range(cons.length - 1):
		var from := cons.stars[i]
		var from_star := starfield.stars[from]
		var from_pos := _camera.unproject_position(from_star.global_position)

		var to := cons.stars[i + 1]
		var to_star := starfield.stars[to]
		var to_pos := _camera.unproject_position(to_star.global_position)

		# Yikes, this kinda breaks when one star is off-camera
		if (
			_camera.is_position_behind(from_star.global_position)
			and _camera.is_position_behind(to_star.global_position)
		):
			continue

		draw_line(from_pos, to_pos, line_color, line_width, true)
