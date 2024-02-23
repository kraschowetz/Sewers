extends StaticBody2D

@onready var desc = preload("res://Prefabs/itemDesc.tscn")

@export var price: int
@export_multiline var text: String

var world: World
var player: Player
var itm_dsc: Node = null

func _ready() -> void:
	world = get_parent()
	player = get_node("../Player")
	$Label.text = "$0%s" % price

func _on_area_2d_body_entered(body) -> void:
	if body.name != "Player" && player.cheese < price: return
	if player.hp > 2: return
	
	player.hp = 3
	player.cheese -= price
	player.cheese_changed.emit()
	player.hp_changed.emit()
	
	for i  in world.unload_after_layer_exit.size():
		if world.unload_after_layer_exit[i] == self:
			world.unload_after_layer_exit[i] = null
	if itm_dsc:
		itm_dsc.queue_free()
		itm_dsc = null
	queue_free()


func _on_area_2d_mouse_entered() -> void:
	itm_dsc = desc.instantiate()
	itm_dsc.global_position = Vector2(-48 * 2.5, -48 * 3.5)
	call_deferred("add_child", itm_dsc)
	itm_dsc.set_text(text)

func _on_area_2d_mouse_exited() -> void:
	itm_dsc.queue_free()
	itm_dsc = null
