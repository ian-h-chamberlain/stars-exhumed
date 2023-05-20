extends Node

@export var max_constellations: int = 5

@export var meteors_to_kill: int = 10

var seen_constellation_help: bool = false
var seen_battlefield_help: bool = false

# The initial seed the starfield was generated with
var starfield_seed: int:
	set(seed_):
		print("Starfield seeded with, ", seed_)
		starfield_seed = seed_

# The list of constellations the user has saved.
var constellations: Array[Constellation]:
	get:
		return _constellations

var _constellations: Array[Constellation] = []


func add_constellation(cons: Constellation) -> void:
	if len(_constellations) < max_constellations:
		print("Adding constellation: ", cons)
		_constellations.push_back(cons)
	else:
		print("Reach max # of constellations!")
