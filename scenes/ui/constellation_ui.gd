extends Control

@export var viewport_texture_paths: Array[NodePath]

@export var constellation_builder: ConstellationBuilder

# https://github.com/godotengine/godot/issues/62916#issuecomment-1471750455
@onready var viewport_textures := viewport_texture_paths.map(get_node)
@onready var sub_viewport: SubViewport = $SubViewport
@onready var camera: Camera3D = get_viewport().get_camera_3d()

var _viewport_cam: Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	constellation_builder.connect("constellation_added", _on_constellation_added)

	_viewport_cam = camera.duplicate()
	sub_viewport.add_child(_viewport_cam)


func _process(_delta) -> void:
	_viewport_cam.global_transform = camera.global_transform


func _on_constellation_added() -> void:
	var constellations = PlayerProgress.constellations
	var tex_rect: TextureRect = viewport_textures[len(constellations) - 1]

	# TODO: align camera bounding box etc. to make this look a little nicer, maybe
	var image := sub_viewport.get_texture().get_image()
	tex_rect.texture = ImageTexture.create_from_image(image)
