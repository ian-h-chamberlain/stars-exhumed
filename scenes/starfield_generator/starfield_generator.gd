extends Node3D
class_name StarfieldGenerator

@export var max_radius: float = 100
@export var min_distance: float = 10
@export var num_stars: int = 100
@export var star: PackedScene

var _stars: Array[Node3D] = []

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	# Print seed for determinism, can regenerate if needed
	rng.randomize()
	print("Seeded with, ", rng.get_seed())

	for i in range(num_stars):
		var new_star = star.instantiate()

		while true:
			var star_pos = _generate_star_position()
			if star_pos != Vector3.ZERO:
				new_star.position = star_pos
				# print("Generating star ", len(_stars), " with pos ", star_pos)
				break

		_stars.push_back(new_star)
		add_child(new_star)


func _generate_star_position() -> Vector3:
	var star_pos = Vector3(
		randf_range(-max_radius, max_radius),
		randf_range(-max_radius, max_radius),
		randf_range(-max_radius, max_radius)
	)

	# This is super naive generation algorithm, there is probably a way better
	# way to sample points on a sphere lol...
	if star_pos.length() > max_radius:
		return Vector3.ZERO

	for existing_star in _stars:
		if existing_star.position.distance_to(star_pos) < min_distance:
			return Vector3.ZERO

	return star_pos
