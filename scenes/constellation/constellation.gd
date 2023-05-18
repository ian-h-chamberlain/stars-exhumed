class_name Constellation
extends Node

# The indices of the stars in this constellation, in order.
var stars: Array[int] = []:
	get:
		return stars

# Whether the constellation is "set" or not.
var is_valid: bool = false:
	get:
		return not screen_stars.is_empty()

# How many stars are in this constellation.
var length: int = 0:
	get:
		return len(stars)

# The screenspace positions of each star, in order
var screen_stars: Array[Vector2] = []:
	get:
		return screen_stars

var texture: ImageTexture

# TODO: probably want some kind of bound box so we can actually align to the
# box would be good enough?


func _to_string() -> String:
	return "Constellation(%s)" % [stars]


# Returns whether the star was added or not
func add_star(idx: int) -> bool:
	if idx in stars:
		return false

	stars.push_back(idx)
	return true


func pop_star():
	if length > 0:
		return stars.pop_back()

	return null


func peek():
	if length > 0:
		return stars.back()

	return null


func finish(cam: Camera3D, starfield: StarfieldGenerator) -> void:
	for idx in stars:
		var star := starfield.stars[idx]

		# project to screen space and normalize to [0.0, 1.0]
		screen_stars.push_back(
			(
				cam.unproject_position(star.global_position)
				/ cam.get_viewport().get_visible_rect().size
			)
		)

	print("projected: ", screen_stars)
