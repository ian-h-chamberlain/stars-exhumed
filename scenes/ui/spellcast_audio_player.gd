class_name SpellcastAudioPlayer
extends AudioStreamPlayer3D

signal spell_primed
signal spell_casted
signal spell_cancelled
signal spell_failed

@export var prime_sound: AudioStream
@export var cast_sound: AudioStream
@export var fail_sound: AudioStream


func _ready():
	spell_primed.connect(_play_primed)
	spell_casted.connect(_play_casted)
	spell_cancelled.connect(_play_failed)
	spell_failed.connect(_play_failed)


func _play_primed():
	stream = prime_sound
	play()


func _play_casted():
	stream = cast_sound
	play()


func _play_failed():
	stream = fail_sound
	play()
