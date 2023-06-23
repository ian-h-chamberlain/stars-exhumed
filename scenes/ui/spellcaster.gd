class_name Spellcaster
extends Control

# In: when the user casts a primed spell
signal spell_casted

# Out: when the user cancels priming
signal spell_cancelled
# Out: when a spell is ready to be cast
signal spell_primed

@export var similarity_threshold: float = 0.2

@export var input_prime_action: StringName = "prime_spell"
@export var input_cancel_action: StringName = "cancel_spell"

@onready var _spell_circle := $SpellCircleContainer/SpellCircle as SpellCircle
@onready var _reticle := $Reticle as Reticle
@onready var _audio_player := $SpellcastAudioPlayer as SpellcastAudioPlayer

@onready var _cast_button := $SpellCircleContainer/Helpers/CastButton as Button
@onready var _cancel_button := $SpellCircleContainer/Helpers/CancelButton as Button

var _current_constellation: Array[Vector2] = []

# Terminology:
# 	- "prime" means to draw a constellation and equip a spell
# 	- "cast" means to actually emit the projectile for a spell
# 	- "cancel" means to abort the priming process. Once primed a spell can't
#		be cancelled.

enum State { PRIMING, PRIMED, NONE }
var _state := State.NONE:
	set = _set_state

var is_spell_primed: bool:
	get:
		return _state == State.PRIMED

@export var primed_text := "Fire [LMB]"
@export var priming_text := "Cast [E|RMB]"


func _set_state(new_state: State) -> void:
	_state = new_state
	if _state == State.PRIMED:
		_cancel_button.disabled = true
		_cast_button.text = primed_text

	else:
		_cancel_button.disabled = (_state == State.NONE)
		_cast_button.text = priming_text


func _ready() -> void:
	spell_casted.connect(_cast_spell)

	_spell_circle.constellation_updated.connect(_on_constellation_updated)

	_cast_button.text = priming_text
	# We could maybe use shortcuts instead of separate input actions, but whatever...
	_cast_button.pressed.connect(_attempt_prime)
	_cancel_button.pressed.connect(func(): _cancel_cast(false))


func _cancel_cast(failure: bool):
	if _state != State.PRIMING:
		return

	print("cancelling cast")

	_reticle.visible = false

	_audio_player.spell_cancelled.emit()
	_spell_circle.spell_cancelled.emit(failure)
	spell_cancelled.emit()

	_state = State.NONE


func _on_constellation_updated(cons: Array[Vector2]) -> void:
	_current_constellation = cons
	if len(cons) > 0:
		_state = State.PRIMING


func _prime_spell(cons: Constellation):
	_state = State.PRIMED

	_reticle.visible = true
	_audio_player.spell_primed.emit()
	_spell_circle.spell_primed.emit(cons)
	spell_primed.emit()


func _cast_spell():
	_reticle.visible = false
	_state = State.NONE

	_audio_player.spell_casted.emit()
	_spell_circle.spell_casted.emit()


# func _shortcut_input(event: InputEvent) -> void:
# 	if event.is_action_pressed(input_prime_action):
# 		accept_event()
# 		print("requested prime (shortcut_input)")
# 		_attempt_prime()

# 	if event.is_action_pressed(input_prime_action):
# 		print("requested prime (shortcut_input)")
# 		_attempt_prime()


func _gui_input(event: InputEvent) -> void:
	if _state == State.PRIMED:
		return

	if event.is_action_pressed(input_prime_action):
		accept_event()
		print("requested prime (gui_input)")
		_attempt_prime()


func _attempt_prime():
	if _state != State.PRIMING:
		print("not currently priming, not attempting anything")
		_state = State.PRIMING
		_uncapture_mouse()
		return

	for cons in PlayerProgress.constellations:
		if _matches_constellation(cons):
			print("got a match on constellation: ", cons)
			_prime_spell(cons)
			return

	_cancel_cast(true)


func _uncapture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# Unfortunately warp_mouse has no effect on web builds, so to make it
	# a consistent experience it seems best to avoid warping at all...

	#var spell_circle := spellcaster.find_child("SpellCircle") as Control
	#var mouse_pos: Vector2 = (
	#	spell_circle.global_position
	#	+ Vector2(spell_circle.size.x / 2.0, spell_circle.size.y / 2.0)
	#)
	#Input.warp_mouse(mouse_pos)


# TODO: test matching with larger constellations (4+ stars)
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
