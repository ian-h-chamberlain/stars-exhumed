class_name BattilefieldPlayer
extends FPSController3D

@export var input_back_action_name := "move_backward"
@export var input_forward_action_name := "move_forward"
@export var input_left_action_name := "move_left"
@export var input_right_action_name := "move_right"
@export var input_sprint_action_name := "move_sprint"
@export var input_jump_action_name := "move_jump"


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	setup()


func _physics_process(delta):
	var is_valid_input := Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED

	if is_valid_input:
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
	else:
		# NOTE: It is important to always call move() even if we have no inputs
		## to process, as we still need to calculate gravity and collisions.
		move(delta)


func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_head(event.relative)
