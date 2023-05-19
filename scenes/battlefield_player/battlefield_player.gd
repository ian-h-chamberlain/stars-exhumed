class_name BattlefieldPlayer
extends FPSController3D

@export var input_back_action_name := "move_backward"
@export var input_forward_action_name := "move_forward"
@export var input_left_action_name := "move_left"
@export var input_right_action_name := "move_right"
@export var input_sprint_action_name := "move_sprint"
@export var input_jump_action_name := "move_jump"
@export var input_cast_action_name := "cast_spell"
@export var input_cancel_action_name := "cancel_spell"
@export var input_fire_action_name := "fire"

@export var spellcaster: Spellcaster
@export var projectile: PackedScene

@onready var _camera := get_viewport().get_camera_3d()


func _ready():
	_capture_mouse()
	spellcaster.spell_primed.connect(_capture_mouse)
	setup()


func _physics_process(delta):
	var is_valid_input := Input.mouse_mode == Input.MOUSE_MODE_CAPTURED

	if is_valid_input:
		_handle_fps_input(delta)
	else:
		# NOTE: It is important to always call move() even if we have no inputs
		## to process, as we still need to calculate gravity and collisions.
		move(delta)

		if Input.is_action_just_pressed(input_cancel_action_name):
			_capture_mouse()
			spellcaster.spell_cancelled.emit()


func _capture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _handle_fps_input(delta: float) -> void:
	var input_axis = Input.get_vector(
		input_back_action_name,
		input_forward_action_name,
		input_left_action_name,
		input_right_action_name
	)
	var input_jump = Input.is_action_just_pressed(input_jump_action_name)
	var input_sprint = Input.is_action_pressed(input_sprint_action_name)

	move(
		delta,
		input_axis,
		input_jump,
		false,
		input_sprint,
	)

	if Input.is_action_just_pressed(input_cast_action_name):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		var spell_circle := spellcaster.find_child("SpellCircle") as Control
		var mouse_pos: Vector2 = (
			spell_circle.global_position
			+ Vector2(spell_circle.size.x / 2.0, spell_circle.size.y / 2.0)
		)
		Input.warp_mouse(mouse_pos)

	if Input.is_action_just_pressed(input_fire_action_name):
		# if spellcaster.spell:
		spellcaster.spell_casted.emit()


func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_head(event.relative)


func _on_spellcaster_spell_casted():
	var new_projectile := projectile.instantiate() as SpellProjectile

	var fwd_direction := -_camera.global_transform.basis.z

	new_projectile.global_transform = global_transform
	new_projectile.travel_direction = fwd_direction

	get_parent().add_child(new_projectile)
