extends StaticBody2D

@export var price: int

var world: World
var player: Player

func _ready() -> void:
	world = get_parent()
	player = get_node("../Player")
	$Label.text = "$0%s" % price

func _on_area_2d_body_entered(body):
	if body.name != "Player" && player.cheese < price: return
	if player.hp > 2: return
	
	player.hp = 3
	player.hp_changed.emit()
	
	for i  in world.unload_after_layer_exit.size():
		if world.unload_after_layer_exit[i] == self:
			world.unload_after_layer_exit[i] = null
	queue_free()
