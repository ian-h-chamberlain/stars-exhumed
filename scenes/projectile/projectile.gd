class_name SpellProjectile
extends RigidBody3D

@export var rotation_speed: float = 3.0
@export var travel_speed: float = 7.0

var travel_direction := Vector3.ZERO:
	set(dir):
		linear_velocity = travel_speed * dir

var _inner_rotation_direction: Vector3
var _inner_rotation_speed: float

@onready var _center = $CenterMesh as Node3D


func _ready():
	angular_velocity = Vector3(
		randf_range(0.0, rotation_speed),
		randf_range(0.0, rotation_speed),
		randf_range(0.0, rotation_speed),
	)

	_inner_rotation_direction = angular_velocity.cross(Vector3.UP).normalized()
	_inner_rotation_speed = randf_range(1.0, rotation_speed)


func _physics_process(delta):
	_center.rotate_object_local(_inner_rotation_direction, _inner_rotation_speed * delta)
