extends Node
class_name Upgrade

@export var price: int
@export var texture: Texture2D
@export var upgrade_name: String
@export_multiline var upgrade_desc: String


var manager: Node

func on_instantiate() -> void:
	pass

func update() -> void:
	pass
