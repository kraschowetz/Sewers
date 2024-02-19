extends StaticBody2D

@onready var world = get_parent()

@export var gun_items: Array[PackedScene]
@export var upgrades: Array[PackedScene]
@export var upgrade_item: PackedScene

var items: Array[String] = ["", "", "",""]

func _ready():
	world.unload_after_layer_exit.append(self)
	generate_items()
	"""
	for i in range(3):
		var instance
		
		var chance: int = randi_range(1, 100)
		if chance < 33:
			instance = gun_items[randi_range(0, gun_items.size() - 1)].instantiate()
		else:
			var up = upgrades[randi_range(0, upgrades.size() - 1)]
			instance = upgrade_item.instantiate()
			instance.upgrade = up
			instance.update(up)
		var pos = Vector2((position.x - 96) + (i * 96), position.y + 96)
		instance.global_position = pos
		instance.set_world(world)
		world.call_deferred("add_child", instance)
		world.unload_after_layer_exit.append(instance)
		#world.add_child(instance)
		"""

func generate_items() -> void:
	for i in range(4):
		var instance
		match i:
			0: #first slot is always an armor
				instance = upgrades[0].instantiate()
				
			1: #second slot is always a gun
				if world.layer == 5:
					instance = gun_items[0].instantiate()
				else:
					instance = gun_items[randi_range(0, gun_items.size() - 1)].instantiate()
				items[0] = instance.name
				instance.world = world
				
			2: #third slot is always an upgrade
				var up = upgrades[randi_range(1, upgrades.size() - 1)]
				instance = upgrade_item.instantiate()
				instance.upgrade = up
				instance.update(up)
				items[1] = up.instantiate().upgrade_name
				
			3: #fourth slot is random
				items[2] = items[0]
				while items[2] == items[1] || items[2] == items[0]:
					if randi_range(1, 2) < 2:
						instance = gun_items[randi_range(0, gun_items.size() - 1)].instantiate()
						items[2] = instance.name
						instance.world = world
					else:
						var up = upgrades[randi_range(1, upgrades.size() - 1)]
						instance = upgrade_item.instantiate()
						instance.upgrade = up
						instance.update(up)
						items[2] = up.instantiate().upgrade_name
		
		var pos = Vector2((position.x - 148) + (i * 96), position.y + 96) #change vlaues
		instance.global_position = pos
		world.call_deferred("add_child", instance)
		world.unload_after_layer_exit.append(instance)
