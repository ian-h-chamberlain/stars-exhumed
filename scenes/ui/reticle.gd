class_name Reticle
extends Control

@export var radius: float = 5.0:
	set(r):
		radius = r
		queue_redraw()

@export var width: float = 1.0:
	set(w):
		width = w
		queue_redraw()

@export var color: Color = Color.RED:
	set(c):
		color = c
		queue_redraw()

@export var point_count: int = 25:
	set(p):
		point_count = p
		queue_redraw()


func _draw():
	draw_arc(Vector2.ZERO, radius, 0, TAU, point_count, color, width, true)
