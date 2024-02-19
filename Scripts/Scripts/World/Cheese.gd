extends StaticBody2D

var origin: Vector2
var dir: int = 8

func _ready() -> void:
	origin = global_position

func _on_area_2d_body_entered(body) -> void:
	if body.name == "Player":
		body.add_cheese()
		queue_free()
