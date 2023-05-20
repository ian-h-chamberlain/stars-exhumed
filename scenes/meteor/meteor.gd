class_name Meteor
extends Node3D

signal destroyed(other: Node3D)

@export var meshes: Array[ArrayMesh]
@export var angular_speed: float = 5.0
@export var friction_force: float = 0.6

@onready var body := $MeteorBody as RigidBody3D
@onready var _mesh := $MeteorBody/MeteorCollider/MeteorMesh as MeshInstance3D
@onready var _collider := $MeteorBody/MeteorCollider as CollisionShape3D
@onready var _preloader := $ResourcePreloader as ResourcePreloader
@onready var _player := $ExplosionAudio as AudioStreamPlayer3D

var _mesh_idx: int


func _ready():
	_mesh_idx = randi_range(0, len(meshes) - 1)

	# pick a random mesh at spawn time
	_mesh.mesh = meshes[_mesh_idx]

	var shape_name := _shape_name()
	if _preloader.has_resource(shape_name):
		_collider.shape = _preloader.get_resource(shape_name)

	body.angular_velocity = (
		Vector3(randf(), randf(), randf()).normalized() * randf_range(1.0, angular_speed)
	)

	body.body_entered.connect(_on_collision)
	destroyed.connect(_on_collision)


func _process(_delta):
	if body.constant_force == Vector3.ZERO and body.linear_velocity != Vector3.ZERO:
		body.add_constant_force(-body.linear_velocity.normalized() * friction_force)

	if not _collider.shape:
		if _mesh.get_child_count() == 0:
			_mesh.create_convex_collision()
		else:
			var shape_name := _shape_name()
			var new_body = _mesh.get_child(0)
			var collision: CollisionShape3D = new_body.get_child(0)
			_collider.shape = collision.shape
			_preloader.add_resource(shape_name, collision.shape)
			_mesh.get_child(0).queue_free()


func _shape_name() -> String:
	return "rock_mesh_collision_%d" % _mesh_idx


func _on_collision(collided_body: Node3D):
	# projectile plays its own explosion sound and despawns us so don't deduplicate
	if not collided_body.owner is SpellProjectile and not collided_body.owner is Meteor:
		_player.play()
		queue_free()
