class_name SpellProjectile
extends RigidBody3D

@export var rotation_speed: float = 3.0
@export var travel_speed: float = 7.0
@export var despawn_radius: float = 200.0

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

	body_entered.connect(func(body): print(body))
	body_shape_entered.connect(func(rid, body, idx, idx2): print(rid, body, idx, idx2))


func _physics_process(delta):
	_center.rotate_object_local(_inner_rotation_direction, _inner_rotation_speed * delta)


func _process(_delta):
	if global_position.length() > despawn_radius:
		print("despawning ", get_instance_id(), " due to distance from origin")
		queue_free()


func _on_spell_collision_area_body_entered(body: Node3D):
	print("collided with ", body)

	# TODO: despawn body if it's a meteor

	# TODO: probably should delay this free by a little bit to make the despawn
	# less jarring?
	queue_free()
