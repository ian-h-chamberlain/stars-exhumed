class_name MeteorSpawner
extends Node3D

signal meteor_destroyed

@export var meteor: PackedScene
@export var spawn_radius: float = 200.0
@export var target_radius: float = 50.0
@export var meteor_speed: float = 150.0
@export var max_meteors: int = 5

@onready var _timer := $Timer as Timer

var _meteor_count: int = 0


func _ready():
	_timer.timeout.connect(_spawn_meteor)

	meteor_destroyed.connect(func(): _meteor_count -= 1)


func _spawn_meteor():
	if _meteor_count >= max_meteors:
		return

	_meteor_count += 1
	var new_meteor := meteor.instantiate()
	add_child(new_meteor)

	var spawn_offset_dir := Vector3(randf(), 0.0, randf()).normalized()
	var spawn_pos := spawn_offset_dir * randf_range(0.0, 2 * spawn_radius)

	var target_offset_dir := Vector3(randf(), 0.0, randf()).normalized()
	var target := target_offset_dir * randf_range(0.0, target_radius)

	new_meteor.position = spawn_pos
	new_meteor.look_at(target)
	new_meteor.body.linear_velocity = (target - spawn_pos).normalized() * meteor_speed
