extends Node2D

@onready var player: Player = get_node("../")
@onready var ray: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D

func _process(_delta) -> void:
	line.clear_points()
	line.add_point(Vector2.ZERO)
	ray.position = Vector2.ZERO
	ray.target_position = get_global_mouse_position() - player.position
	line.add_point((get_global_mouse_position() - player.position) * 10)
