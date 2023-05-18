class_name SpellCircle
extends TextureRect

signal spell_cancelled
signal spell_primed
signal spell_casted

@export var star_radius: float = 2.0
@export var star_color: Color = Color.PALE_GREEN
@export var line_color: Color = Color.PALE_GREEN
@export var line_width: float = 0.5

@export var similarity_threshold: float = 0.9

var _current_constellation: Array[Vector2] = []
var _is_primed: bool = false

@onready var _current_spell = $MarginContainer/CurrentSpell as TextureRect


func _ready():
	connect("gui_input", _on_gui_input)
	spell_casted.connect(_on_spell_casted)


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

	if _is_primed:
		return

	match event.button_index:
		MOUSE_BUTTON_LEFT:
			print("got mouse click at ", event.position)
			_current_constellation.push_back(event.position)
		MOUSE_BUTTON_RIGHT:
			print("got right click at ", event.position)
			_attempt_cast()
		_:
			return

	print("casting constellation: ", _current_constellation)
	queue_redraw()


func _attempt_cast():
	for cons in PlayerProgress.constellations:
		if _matches_constellation(cons):
			print("got a match on constellation: ", cons)
			_perform_cast(cons)
			return true

	return null


func _matches_constellation(cons: Constellation):
	return true


func _perform_cast(cons: Constellation):
	_is_primed = true
	spell_primed.emit(cons)

	_current_spell.texture = cons.texture
	_current_spell.visible = true

	_current_constellation.clear()


func _on_spell_casted():
	_is_primed = false
	_current_spell.visible = false
