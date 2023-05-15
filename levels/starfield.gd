extends Node3D

## If true, Esc key quits the game
@export var fast_close := true


func _ready() -> void:
	if !OS.is_debug_build():
		fast_close = false

	if fast_close:
		print("** Fast Close enabled in the 'level.gd' script **")

	set_process_input(fast_close)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()  # Quits the game
