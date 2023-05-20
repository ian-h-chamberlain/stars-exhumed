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

@onready var _ok_button = $HelpPanel/PanelContainer/VBoxContainer/OKButton as Button
@onready var _help_panel = $HelpPanel as CanvasItem


func _ready() -> void:
	spell_cancelled.connect(_cancel_cast)
	spell_casted.connect(_clear_spell)
	spell_circle.spell_primed.connect(_set_spell)

	if _help_panel:
		_help_panel.visible = not PlayerProgress.seen_battlefield_help

	if _ok_button:
		_ok_button.pressed.connect(_hide_help)


func _hide_help():
	PlayerProgress.seen_battlefield_help = true
	_help_panel.visible = false


func _cancel_cast():
	if spell_circle.is_casting:
		_audio_player.spell_cancelled.emit()

	spell_circle.spell_cancelled.emit()


func _set_spell(cons: Constellation):
	_audio_player.spell_primed.emit()
	$Reticle.visible = true
	spell_primed.emit()
	spell = cons


func _clear_spell():
	spell = null
	_audio_player.spell_casted.emit()
	reticle.visible = false
	spell_circle.spell_casted.emit()
