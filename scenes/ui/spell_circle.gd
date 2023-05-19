class_name SpellCircle
extends TextureRect

signal spell_cancelled
signal spell_primed
signal spell_casted

@export var star_radius: float = 2.0
@export var star_color: Color = Color.PALE_GREEN
@export var line_color: Color = Color.PALE_GREEN
@export var line_width: float = 0.5

@export var cast_glow: Color = Color.GREEN
@export var fail_glow: Color = Color.RED

@export var similarity_threshold: float = 0.2

var is_casting: bool:
	get:
		return not _current_constellation.is_empty()

# skip the first once since it's always 0 and would bring down the avg
var _current_constellation: Array[Vector2] = []
var _is_primed: bool = false

@onready var _current_spell = $MarginContainer/CurrentSpell as TextureRect
@onready var _timer = $Timer as Timer

const GLOW_COLOR := "glow_color"


func _ready():
	connect("gui_input", _on_gui_input)
	spell_casted.connect(_on_spell_casted)
	spell_cancelled.connect(_on_spell_cancelled)
	_timer.timeout.connect(_reset_material)


func _draw() -> void:
	if len(_current_constellation) > 0:
		draw_circle(_current_constellation[0], star_radius, star_color)

	for i in range(len(_current_constellation) - 1):
		var prev_pos := _current_constellation[i]
		var cur_pos := _current_constellation[i + 1]

		draw_circle(cur_pos, star_radius, star_color)
		draw_line(prev_pos, cur_pos, line_color, line_width, true)


func _on_spell_casted():
	_is_primed = false
	_current_spell.visible = false


func _on_spell_cancelled():
	_current_constellation.clear()
	queue_redraw()


func _reset_material():
	material.set_shader_parameter(GLOW_COLOR, Color.BLACK)


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

	queue_redraw()


func _attempt_cast():
	for cons in PlayerProgress.constellations:
		if _matches_constellation(cons):
			print("got a match on constellation: ", cons)
			_perform_cast(cons)
			return

	$"../SpellcastAudioPlayer".spell_failed.emit()
	material.set_shader_parameter(GLOW_COLOR, fail_glow)
	_timer.start()


func _matches_constellation(cons: Constellation):
	if len(cons.stars) != len(_current_constellation):
		return false

	var current = _current_constellation.map(func(px_pos): return Vector2(px_pos) / size)

	var offset = current[0] - cons.screen_stars[0]

	# attempt to overlay just by lining up the first elements together
	current = current.map(func(pos): return pos - offset)

	print("comparing ", cons.screen_stars, " and ", current)

	var difference := 0.0
	# skip the first once since it's always 0 and would bring down the avg
	for i in len(cons.stars) - 1:
		var lhs_dir = cons.screen_stars[i + 1] - cons.screen_stars[i - 1]
		var rhs_dir = current[i + 1] - current[i - 1]

		var point_diff = (rhs_dir - lhs_dir).length()
		print("point diff: ", point_diff)
		difference += point_diff

	difference /= len(cons.stars)

	print("difference was ", difference)

	return difference < similarity_threshold


func _perform_cast(cons: Constellation):
	_is_primed = true
	spell_primed.emit(cons)

	_current_spell.texture = cons.texture
	_current_spell.visible = true

	print("casting spell: ", _current_constellation)

	material.set_shader_parameter(GLOW_COLOR, cast_glow)
	_timer.start()

	_current_constellation.clear()

	queue_redraw()
