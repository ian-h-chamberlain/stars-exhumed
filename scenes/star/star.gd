class_name Star
extends MeshInstance3D

## A clickable star object used to construct constellations

# Emitted when this star is (un)selected by the player clicking it.
# Emits true if selected or false if unselected

signal clicked
signal right_clicked

## The minimum scale of the collider
@export var min_collider_scale: float = 7.0
## The  maximum radius of the collider
@export var max_collider_scale: float = 750.0

@export var selected: bool = false:
	set(sel):
		selected = sel
		$Highlight.state = Highlight.State.SELECTED if sel else Highlight.State.OFF

@onready var camera = get_viewport().get_camera_3d()


func _ready():
	var collision_body := $StaticBody
	collision_body.connect("input_event", _on_StaticBody_input_event)
	collision_body.connect("mouse_entered", _on_StaticBody_mouse_entered)
	collision_body.connect("mouse_exited", _on_StaticBody_mouse_exited)


func _process(_delta):
	var distance = (camera.global_position - global_position).length()

	# Scale up for stars that are closer to the camera. Sheesh this took way too
	# long to find the right curve for....
	var collider_scale = clamp(
		2000 / distance,
		min_collider_scale,
		max_collider_scale,
	)

	$Highlight.radius = collider_scale

	# To match the screen-space scale, we have to project back from screen space
	# to world space, using an arbitrary axis to get our scale. This is slightly
	# imperfect but should be close enough I think?
	var center = camera.project_position(Vector2.ZERO, distance)
	var sphere_point = camera.project_position(Vector2.RIGHT * collider_scale, distance)
	$StaticBody/MouseCollider.scale = (sphere_point - center).length() / 2.0 * Vector3.ONE


func _on_StaticBody_input_event(
	_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int
) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				selected = not selected
				clicked.emit(selected)
			MOUSE_BUTTON_RIGHT:
				right_clicked.emit()


func _on_StaticBody_mouse_entered():
	Input.set_default_cursor_shape(Input.CursorShape.CURSOR_POINTING_HAND)
	if $Highlight.state == Highlight.State.OFF:
		$Highlight.state = Highlight.State.HOVERED


func _on_StaticBody_mouse_exited():
	Input.set_default_cursor_shape()
	if $Highlight.state == Highlight.State.HOVERED:
		$Highlight.state = Highlight.State.OFF
