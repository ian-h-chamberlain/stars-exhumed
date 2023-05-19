class_name ConstellationBuilder
extends Node3D

signal constellation_added

# The starfield from which to pull stars as part of the constellation.
@export var starfield: StarfieldGenerator

# The max number of stars allowed in a constellation
@export var max_stars: int = 5

var current_constellation := Constellation.new()


func _ready() -> void:
	for i in range(len(starfield.stars)):
		var star := starfield.stars[i]
		star.connect("clicked", _on_Star_clicked.bind(i))
		star.connect("right_clicked", _on_Star_right_clicked.bind(i))


func _on_Star_clicked(selected: bool, idx: int) -> void:
	if selected:
		_add_star(idx)
	else:
		current_constellation.pop_star()
		_select_last_star()

	print("current cons: ", current_constellation)


func _on_Star_right_clicked(idx: int) -> void:
	_add_star(idx)
	_get_last_star().selected = false
	current_constellation.finish(get_viewport().get_camera_3d(), starfield)

	# TODO maybe some separate button etc to "accept" constellation and commit it
	# to the player databank. For now just add unconditionally

	PlayerProgress.add_constellation(current_constellation)
	constellation_added.emit()

	current_constellation = Constellation.new()


func _add_star(idx: int) -> void:
	var last_star = _get_last_star()

	var too_full := len(current_constellation.stars) >= max_stars
	var added := not too_full and current_constellation.add_star(idx)
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
	var idx = current_constellation.peek()
	if idx != null:
		return starfield.stars[idx]

	return null
