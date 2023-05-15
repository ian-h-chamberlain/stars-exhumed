extends CharacterController3D
class_name OrbitPoint

## A point in space that a camera orbits around. The point can be moved with
## WASDQE for 6DOF and the mouse can be used to orbit the point.

## The camera that will be looking at this orbit point.
@onready var camera: Camera3D = get_node(NodePath("TrackballCamera"))

@export var input_back_action_name := "move_backward"
@export var input_forward_action_name := "move_forward"
@export var input_left_action_name := "move_left"
@export var input_right_action_name := "move_right"
@export var input_sprint_action_name := "move_sprint"
@export var input_up_action_name := "move_up"
@export var input_down_action_name := "move_down"


func _ready():
	camera.look_at(self.global_position)
	setup()


func _physics_process(delta):
	var input_axis = Input.get_vector(
		input_back_action_name,
		input_forward_action_name,
		input_left_action_name,
		input_right_action_name
	)
	var input_jump = Input.is_action_just_pressed(input_up_action_name)
	var input_crouch = Input.is_action_pressed(input_down_action_name)
	var input_sprint = Input.is_action_pressed(input_sprint_action_name)
	var input_swim_down = Input.is_action_pressed(input_down_action_name)
	var input_swim_up = Input.is_action_pressed(input_up_action_name)

	move(delta, input_axis, input_jump, input_crouch, input_sprint, input_swim_down, input_swim_up)
