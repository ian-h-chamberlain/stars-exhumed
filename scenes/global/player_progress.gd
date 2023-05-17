extends Node

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
	print("Adding constellation: ", cons)
	_constellations.push_back(cons)
