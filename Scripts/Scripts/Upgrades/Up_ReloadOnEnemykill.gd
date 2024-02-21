extends Upgrade

var current_gun: String = ""

func on_instantiate() -> void:
	current_gun = manager.gun.gun_name
	manager.gun.reload_on_enemy_kill = true

func update() -> void:
	if manager.gun.gun_name != current_gun:
		current_gun = manager.gun.name
		manager.gun.reload_on_enemy_kill = true
