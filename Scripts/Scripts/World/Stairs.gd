extends Sprite2D

@onready var player = get_node("../Player")

func _process(_delta) -> void:
	if player.position.y > position.y:
		z_index = -1
	else:
		z_index = 1
