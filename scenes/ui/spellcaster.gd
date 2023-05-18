class_name Spellcaster
extends Control

signal spell_cancelled
signal spell_casted(constellation: Array[Vector2])

# The height of this element, calculated as max height of its children
var height: float:
	get:
		return get_children().map(func(child): return child.size.y).max()

@onready var spell_circle := $SpellCircle as TextureRect


func _ready() -> void:
	spell_cancelled.connect(func(): spell_circle.spell_cancelled.emit())
