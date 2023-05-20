extends Node3D


func _ready():
	$Timer.timeout.connect(func(): $ExplosionParticles.emitting = true)
