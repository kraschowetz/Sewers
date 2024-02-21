extends Node

@export var player: Player

func _ready() -> void:
	player.ammo_changed.connect(on_ammo_changed)
	on_ammo_changed()

func on_ammo_changed() -> void:
	if player.armed:
		$TextureRect.size.y = player.gun.ammo * 8
	else:
		$TextureRect.size.y = 0
