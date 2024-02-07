extends Node

@export var gun: Gun
@export var player: CharacterBody2D
@export var world: World

var upgrades: Array[Upgrade]

func update_upgrades() -> void:
	upgrades.clear()
	for child in get_children():
		if child is Upgrade:
			upgrades.append(child)
			child.manager = self
	
	for i in upgrades.size():
		upgrades[i - 1].on_instantiate()

func remove_upgrade(_u: Upgrade) -> void:
	for i in upgrades.size():
		if upgrades[i - 1] == _u:
			upgrades.remove_at(i - 1)

func check_if_player_have_upgrade(n: String) -> bool:
	for i in upgrades.size():
		if upgrades[i - 1].upgrade_name == n:
			return true
	return false

func _ready() -> void:
	update_upgrades()

func _process(_delta) -> void:
	for i in upgrades.size():
		upgrades[i].update()


