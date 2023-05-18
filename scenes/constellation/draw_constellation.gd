extends Node3D

@export var line_color: Color = Color.WHITE
@export var builder: ConstellationBuilder

@onready var _draw3d := $Draw3D as Draw3D


func _process(_delta):
	_draw3d.clear()

	var current = builder.current_constellation
	_draw_constellation(current)

	for cons in PlayerProgress.constellations:
		_draw_constellation(cons)


func _draw_constellation(cons: Constellation):
	var starfield: StarfieldGenerator = builder.starfield

	for i in range(cons.length - 1):
		var vertices := cons.stars.map(func(i: int): return starfield.stars[i].global_position)

		_draw3d.draw_line(vertices, line_color)
