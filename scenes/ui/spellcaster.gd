class_name Spellcaster
extends Control

signal spell_cancelled
signal spell_casted
signal spell_primed

# The height of this element, calculated as max height of its children
var height: float:
	get:
		return get_children().map(func(child): return child.size.y).max()

var spell:
	get:
		return spell

@onready var spell_circle := $SpellCircle as SpellCircle


func _ready() -> void:
	spell_cancelled.connect(func(): spell_circle.spell_cancelled.emit())
	spell_casted.connect(func(): spell_circle.spell_casted.emit())

	spell_circle.spell_primed.connect(_set_spell)


func _set_spell(cons: Constellation):
	spell_primed.emit()
	spell = cons
