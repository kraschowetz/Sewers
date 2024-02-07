extends Upgrade

func on_instantiate() -> void:
	manager.world.spawn_cheese_on_enemy_kill = true

func update() -> void:
	pass
