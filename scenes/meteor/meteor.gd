class_name Meteor
extends RigidBody3D

@export var meshes: Array[ArrayMesh]

@onready var _mesh = $MeteorCollider/MeteorMesh as MeshInstance3D
@onready var _collider = $MeteorCollider as CollisionShape3D
@onready var _preloader = $ResourcePreloader as ResourcePreloader

var _mesh_idx: int


func _ready():
	_mesh_idx = randi_range(0, len(meshes) - 1)

	# pick a random mesh at spawn time
	_mesh.mesh = meshes[_mesh_idx]

	var shape_name := _shape_name()
	if _preloader.has_resource(shape_name):
		_collider.shape = _preloader.get_resource(shape_name)


func _process(_delta):
	if not _collider.shape:
		if _mesh.get_child_count() == 0:
			_mesh.create_convex_collision()
		else:
			var shape_name := _shape_name()
			var body = _mesh.get_child(0)
			var collision: CollisionShape3D = body.get_child(0)
			_collider.shape = collision.shape
			_preloader.add_resource(shape_name, collision.shape)
			_mesh.get_child(0).queue_free()


func _shape_name() -> String:
	return "rock_mesh_collision_%d" % _mesh_idx
