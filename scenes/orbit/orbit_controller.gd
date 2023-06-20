class_name OrbitController
extends CharacterController3D
# A point in space that a camera orbits around.

# The point can be moved with WASDQE for 6DOF and the mouse can be used to orbit the point.

@export var input_back_action_name := "move_backward"
@export var input_forward_action_name := "move_forward"
@export var input_left_action_name := "move_left"
@export var input_right_action_name := "move_right"
@export var input_up_action_name := "move_up"
@export var input_down_action_name := "move_down"


func _ready():
	setup()


func _physics_process(delta):
	var input_axis = Input.get_vector(
		input_back_action_name,
		input_forward_action_name,
		input_left_action_name,
		input_right_action_name
	)
	var input_up = Input.is_action_pressed(input_up_action_name)
	var input_down = Input.is_action_pressed(input_down_action_name)

	move(delta, input_axis, false, false, false, input_down, input_up)



var _mouse_pressed := false

func input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_mouse_pressed = event.pressed
			if not _mouse_pressed:
				Input.set_default_cursor_shape()

	if event is InputEventMouseMotion:
		if _mouse_pressed:
			Input.set_default_cursor_shape(Input.CURSOR_DRAG)
