extends StaticBody2D

@export var price: int
@export var upgrade: PackedScene

var world: World
var player: Player

func _ready() -> void:
	world = get_parent()
	player = get_node("../Player")

func update(_up: PackedScene) -> void:
	upgrade = _up
	price = upgrade.instantiate().price
	$Sprite2D.texture = upgrade.instantiate().texture
	if(price > 0):
		$Label.text = "$0%s" %price

func set_world(_w: World) -> void:
	self.world = _w

func _on_area_2d_body_entered(body) -> void:
	if(body.name == "Player" && player.cheese >= price):
		var u = upgrade.instantiate()
		
		if player.upgrade_manager.check_if_player_have_upgrade(u.upgrade_name):
			return
		
		player.upgrade_manager.add_child(u)
		player.upgrade_manager.update_upgrades()
		player.cheese -= price
		player.cheese_changed.emit()
		for i  in world.unload_after_layer_exit.size():
			if world.unload_after_layer_exit[i] == self:
				world.unload_after_layer_exit[i] = null
		queue_free()

