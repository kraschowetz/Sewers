extends Sprite2D

@export var textures: Array[Texture2D]

func _ready() -> void:
	var i: int = randi_range(0, textures.size() - 1)
	texture = textures[i]
