extends MeshInstance3D
class_name Star

## A clickable star object used to construct constellations

# Emitted when this star is (un)selected by the player clicking it.
# Emits trure
signal clicked

@export var selected: bool = false:
	set(sel):
		selected = sel
		$Highlight.state = Highlight.State.SELECTED if sel else Highlight.State.OFF


func _ready():
	var collision_body := $StaticBody
	collision_body.connect("input_event", _on_StaticBody_input_event)
	collision_body.connect("mouse_entered", _on_StaticBody_mouse_entered)
	collision_body.connect("mouse_exited", _on_StaticBody_mouse_exited)


func _on_StaticBody_input_event(
	_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int
) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected = not selected
		clicked.emit(selected)


func _on_StaticBody_mouse_entered():
	if $Highlight.state == Highlight.State.OFF:
		print("star ", get_instance_id(), " hovered")
		$Highlight.state = Highlight.State.HOVERED


func _on_StaticBody_mouse_exited():
	if $Highlight.state == Highlight.State.HOVERED:
		print("star ", get_instance_id(), " un-hovered")
		$Highlight.state = Highlight.State.OFF
