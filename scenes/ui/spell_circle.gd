class_name SpellCircle
extends TextureRect

signal spell_casted
signal spell_cancelled(failure: bool)
signal spell_primed(cons: Constellation)
signal constellation_updated(cons: Array[Vector2])

@export var star_radius: float = 2.0
@export var star_color: Color = Color.PALE_GREEN
@export var line_color: Color = Color.PALE_GREEN
@export var line_width: float = 0.5

@export var cast_glow: Color = Color.GREEN
@export var fail_glow: Color = Color.RED

var _shader_time: float = 0

@onready var _current_spell = $MarginContainer/CurrentSpell as TextureRect
@onready var _timer = $Timer as Timer

const GLOW_COLOR := "glow_color"

var _current_constellation: Array[Vector2] = []


func _ready():
	spell_casted.connect(_on_spell_casted)
	spell_cancelled.connect(_on_spell_cancelled)
	spell_primed.connect(_on_spell_primed)

	_timer.timeout.connect(_reset_material)


func _process(delta: float):
	material.set_shader_parameter("time", _shader_time)
	_shader_time += delta


func _draw() -> void:
	if len(_current_constellation) > 0:
		draw_circle(_current_constellation[0], star_radius, star_color)

	for i in range(len(_current_constellation) - 1):
		var prev_pos := _current_constellation[i]
		var cur_pos := _current_constellation[i + 1]

		draw_circle(cur_pos, star_radius, star_color)
		draw_line(prev_pos, cur_pos, line_color, line_width, true)


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("pick_star"):
		accept_event()
		print("got pick_star at ", event.position)
		_current_constellation.push_back(event.position)
		_update_constellation(_current_constellation)


func _on_spell_casted():
	_current_spell.visible = false
	_update_constellation([])
	_reset_material()


func _on_spell_cancelled(failure: bool):
	_current_spell.visible = false
	_update_constellation([])

	if failure:
		_set_material(fail_glow)
	else:
		_reset_material()


func _update_constellation(cons: Array[Vector2]) -> void:
	print("updating constellation ", cons)
	_current_constellation = cons
	constellation_updated.emit(cons)
	queue_redraw()


func _on_spell_primed(cons: Constellation) -> void:
	_current_spell.visible = true
	_current_spell.texture = cons.texture
	_update_constellation([])
	_set_material(cast_glow)


func _set_material(color: Color):
	material.set_shader_parameter(GLOW_COLOR, color)
	_shader_time = 0
	_timer.start()
	queue_redraw()


func _reset_material():
	material.set_shader_parameter(GLOW_COLOR, Color.BLACK)
