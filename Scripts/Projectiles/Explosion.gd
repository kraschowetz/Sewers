extends StaticBody2D

@export var dmg: int

func _on_area_2d_body_entered(body) -> void:
	if body.get_class() == "CharacterBody2D":
		if body.name == "Player":
			body.apply_damage(dmg)
		else:
			body.apply_damage(dmg, position, 10)

func _on_timer_timeout() -> void:
	queue_free()
