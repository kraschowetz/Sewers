extends Node

@export var player: Player
@export var spr: Array[Texture2D]

func _ready() -> void:
	player.hp_changed.connect(on_hp_changed)
	on_hp_changed()

func on_hp_changed() -> void:
	$Sprite2D.texture = spr[player.hp]
