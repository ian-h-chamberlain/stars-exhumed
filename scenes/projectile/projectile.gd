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

@onready var _center := $CenterMesh as Node3D
@onready var _collision_area := $SpellCollisionArea as Area3D
@onready var _despawn_timer := $DespawnTimer as Timer
@onready var _audio_player := $ExplosionAudio as AudioStreamPlayer3D


func _ready():
	angular_velocity = Vector3(
		randf_range(0.0, rotation_speed),
		randf_range(0.0, rotation_speed),
		randf_range(0.0, rotation_speed),
	)

	_inner_rotation_direction = angular_velocity.cross(Vector3.UP).normalized()
	_inner_rotation_speed = randf_range(1.0, rotation_speed)

	_collision_area.body_entered.connect(_on_spell_collision_area_body_entered)

	_despawn_timer.timeout.connect(queue_free)


func _physics_process(delta):
	_center.rotate_object_local(_inner_rotation_direction, _inner_rotation_speed * delta)


func _process(_delta):
	if global_position.length() > despawn_radius:
		# print("despawning ", get_instance_id(), " due to distance from origin")
		queue_free()


func _on_spell_collision_area_body_entered(body: Node3D):
	# TODO: probably should delay this free by a little bit to make the despawn
	# less jarring?

	if body.owner is Meteor:
		body.owner.destroyed.emit(self)

	if not body.owner is BattlefieldPlayer:
		_despawn_timer.start()

	_audio_player.play()
