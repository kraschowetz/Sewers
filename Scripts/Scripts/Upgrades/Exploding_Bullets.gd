extends Upgrade

var current_gun: String

func on_instantiate() -> void:
	manager.player.bullet = preload("res://Prefabs/Projectiles/ExplodingBullet.tscn")
	manager.player.knockback_mod *= 1.5
