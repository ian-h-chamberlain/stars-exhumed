extends Control

@export var viewport_texture_paths: Array[NodePath]

# https://github.com/godotengine/godot/issues/62916#issuecomment-1471750455
@onready var viewport_textures := viewport_texture_paths.map(get_node)


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in len(PlayerProgress.constellations):
		viewport_textures[i].texture = PlayerProgress.constellations[i].texture
