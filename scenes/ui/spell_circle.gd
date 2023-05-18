class_name SpellCircle
extends TextureRect

signal spell_cancelled
signal spell_casted

@export var star_radius: float = 2.0
@export var star_color: Color = Color.PALE_GREEN
@export var line_color: Color = Color.PALE_GREEN
@export var line_width: float = 0.5

var _current_constellation: Array[Vector2] = []


func _ready():
	connect("gui_input", _on_gui_input)


func _draw() -> void:
	if len(_current_constellation) > 0:
		draw_circle(_current_constellation[0], star_radius, star_color)

	for i in range(len(_current_constellation) - 1):
		var prev_pos := _current_constellation[i]
		var cur_pos := _current_constellation[i + 1]

		draw_circle(cur_pos, star_radius, star_color)
		draw_line(prev_pos, cur_pos, line_color, line_width, true)


func _on_gui_input(e: InputEvent) -> void:
	var event := e as InputEventMouseButton
	if not event or not event.pressed:
		return

	match event.button_index:
		MOUSE_BUTTON_LEFT:
			print("got mouse click at ", event.position)
			_current_constellation.push_back(event.position)
		MOUSE_BUTTON_RIGHT:
			print("got right click at ", event.position)
			get_parent().spell_casted.emit(_current_constellation)
			# TODO: some kind of animation to show what spell we casted, I guess?
			_current_constellation.clear()
		_:
			return

	print("current constellation: ", _current_constellation)

	queue_redraw()
