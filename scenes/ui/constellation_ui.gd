extends Control

@export var viewport_texture_paths: Array[NodePath]

@export var constellation_builder: ConstellationBuilder
@export var constellation_viewport: ConstellationViewport
@export var starfield_gen: StarfieldGenerator

@export var margin: int = 5

# https://github.com/godotengine/godot/issues/62916#issuecomment-1471750455
@onready var viewport_textures := viewport_texture_paths.map(get_node)


# Called when the node enters the scene tree for the first time.
func _ready():
	constellation_builder.connect("constellation_added", _on_constellation_added)


func _on_constellation_added() -> void:
	var constellations := PlayerProgress.constellations
	var tex_rect: TextureRect = viewport_textures[len(constellations) - 1]

	var texture := constellation_viewport.get_texture()
	var image := texture.get_image()

	# TODO it would be nice to crop here, and avoid showing other constellations
	# in the image, but oh well for now

	tex_rect.texture = ImageTexture.create_from_image(image)
