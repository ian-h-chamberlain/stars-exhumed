class_name ConstellationBuilder
extends Node3D

signal constellation_added

# The starfield from which to pull stars as part of the constellation.
@export var starfield: StarfieldGenerator

# The max number of stars allowed in a constellation
@export var max_stars: int = 5

var _current_constellation := Constellation.new()


func _ready() -> void:
	for i in range(len(starfield.stars)):
		var star := starfield.stars[i]
		star.connect("clicked", _on_Star_clicked.bind(i))
		star.connect("right_clicked", _on_Star_right_clicked.bind(i))


func _on_Star_clicked(selected: bool, idx: int) -> void:
	if selected:
		_add_star(idx)
	else:
		_current_constellation.pop_star()
		_select_last_star()

	print("current cons: ", _current_constellation)


func _on_Star_right_clicked(idx: int) -> void:
	_add_star(idx)
	_get_last_star().selected = false
	_current_constellation.finish(get_viewport().get_camera_3d())

	# TODO some separate button etc to "accept" constellation and commit it
	# to the player databank. For now just add unconditionally

	PlayerProgress.add_constellation(_current_constellation)
	constellation_added.emit()

	_current_constellation = Constellation.new()


func _process(_delta: float) -> void:
	_draw_constellation(_current_constellation)

	for cons in PlayerProgress.constellations:
		_draw_constellation(cons)


func _draw_constellation(cons: Constellation):
	for i in range(cons.length - 1):
		var from := cons.stars[i]
		var from_star := starfield.stars[from]

		var to := cons.stars[i + 1]
		var to_star := starfield.stars[to]

		# TODO: avoid debug drawing and use a real mesh or something
		DebugDraw.draw_line(from_star.global_position, to_star.global_position, Color.WHITE)


func _add_star(idx: int) -> void:
	var last_star = _get_last_star()

	var added := _current_constellation.add_star(idx)
	if not added:
		starfield.stars[idx].selected = false
		_select_last_star()
		return

	if last_star:
		last_star.selected = false


func _select_last_star() -> void:
	var star = _get_last_star()
	if star:
		star.selected = true


func _get_last_star():
	var idx = _current_constellation.peek()
	if idx != null:
		return starfield.stars[idx]

	return null
