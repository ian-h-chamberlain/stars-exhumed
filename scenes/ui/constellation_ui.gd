extends Control

@export var viewport_texture_paths: Array[NodePath]

@export var constellation_builder: ConstellationBuilder
@export var constellation_viewport: ConstellationViewport
@export var starfield_gen: StarfieldGenerator

@export var margin: int = 5

@export var battlefield_scene: PackedScene

# https://github.com/godotengine/godot/issues/62916#issuecomment-1471750455
@onready var viewport_textures := viewport_texture_paths.map(get_node)

@onready var _continue = $MarginContainer/ContinueButton as Button


# Called when the node enters the scene tree for the first time.
func _ready():
	constellation_builder.connect("constellation_added", _on_constellation_added)
	_continue.pressed.connect(_on_continue_pressed)


func _on_constellation_added() -> void:
	if _continue.disabled:
		_continue.disabled = false
		_continue.tooltip_text = ""

	var constellations := PlayerProgress.constellations
	var cons := constellations[-1]
	var tex_rect: TextureRect = viewport_textures[len(constellations) - 1]

	var texture := constellation_viewport.get_texture()
	var image := texture.get_image()

	# TODO it would be nice to crop here, and avoid showing other constellations
	# in the image, but oh well for now

	var tex := ImageTexture.create_from_image(image)
	tex_rect.texture = tex
	cons.texture = tex


# Janky as fuck but whatever
func _on_continue_pressed():
	# TODO prevent the player from continuing without at least one spell
	get_tree().change_scene_to_packed(battlefield_scene)
