extends MarginContainer

@onready var _ok_button = $PanelContainer/VBoxContainer/OKButton as Button


func _ready():
	visible = not PlayerProgress.seen_battlefield_help
	_ok_button.pressed.connect(_hide_help)


func _hide_help():
	PlayerProgress.seen_battlefield_help = true
	visible = false
