extends Upgrade

var current_gun: String

func on_instantiate() -> void:
	current_gun = manager.gun.gun_name
	manager.gun.bullet = preload("res://Prefabs/Projectiles/ExplodingBullet.tscn")
	manager.gun.knockback *= 1.5

func update() -> void:
	if manager.gun.gun_name != current_gun:
		current_gun = manager.gun.name
		manager.gun.bullet = preload("res://Prefabs/Projectiles/ExplodingBullet.tscn")
		manager.gun.knockback *= 1.5
