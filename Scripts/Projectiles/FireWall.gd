extends RigidBody2D

func _ready() -> void:
	apply_central_force(Vector2.LEFT * 30 * 1000)
	await get_tree().create_timer(5).timeout
	queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.apply_damage(1)
