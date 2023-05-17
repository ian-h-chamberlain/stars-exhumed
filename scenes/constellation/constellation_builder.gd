extends Node3D

# The starfield from which to pull stars as part of the constellation.
@export var starfield: StarfieldGenerator

# The max number of stars allowed in a constellation
@export var max_stars: int = 5

var _current_constellation: Array[int] = []


func _ready() -> void:
	for i in range(len(starfield.stars)):
		var star := starfield.stars[i]
		star.connect("clicked", _on_Star_clicked.bind(i))


func _on_Star_clicked(selected: bool, idx: int) -> void:
	if selected:
		_add_star(idx)
	else:
		_current_constellation.pop_back()
		_select_last_star()

	print("constellation is ", _current_constellation)


func _process(_delta: float) -> void:
	for i in range(len(_current_constellation) - 1):
		var from := _current_constellation[i]
		var from_star := starfield.stars[from]
		var to := _current_constellation[i + 1]
		var to_star := starfield.stars[to]
		DebugDraw.draw_arrow_line(
			from_star.global_position, to_star.global_position, Color.FUCHSIA, 10, true
		)


func _add_star(idx: int) -> void:
	if idx in _current_constellation or len(_current_constellation) >= max_stars:
		starfield.stars[idx].selected = false
		_select_last_star()
		return

	var star = _get_last_star()
	if star:
		star.selected = false

	_current_constellation.push_back(idx)


func _select_last_star() -> void:
	var star = _get_last_star()
	if star:
		star.selected = true


func _get_last_star():
	if len(_current_constellation) > 0:
		return starfield.stars[_current_constellation.back()]

	return null
