class_name Spellcaster
extends Control

var height: float:
	get:
		return get_children().map(func(child): return child.size.y).max()
