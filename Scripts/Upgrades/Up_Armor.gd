extends Upgrade

func on_instantiate() -> void:
	manager.player.hp = 3
	manager.player.hp_changed.connect(on_hp_changed)
	manager.player.hp_changed.emit()

func on_hp_changed() -> void:
	if manager.player.hp == 3: return
	manager.remove_upgrade(self)
	queue_free()
