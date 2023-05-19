class_name Spellcaster
extends Control

signal spell_cancelled
signal spell_casted
signal spell_primed

var spell:
	get:
		return spell

@onready var spell_circle := $SpellCircle as SpellCircle
@onready var reticle := $Reticle as Reticle
@onready var _audio_player := $SpellcastAudioPlayer as SpellcastAudioPlayer


func _ready() -> void:
	spell_cancelled.connect(func(): spell_circle.spell_cancelled.emit())

	spell_casted.connect(_clear_spell)
	spell_circle.spell_primed.connect(_set_spell)


func _cancel_cast():
	spell_circle.spell_cancelled.emit()
	_audio_player.spell_cancelled.emit()


func _set_spell(cons: Constellation):
	_audio_player.spell_primed.emit()
	$Reticle.visible = true
	spell_primed.emit()
	spell = cons


func _clear_spell():
	_audio_player.spell_casted.emit()
	reticle.visible = false
	spell_circle.spell_casted.emit()
