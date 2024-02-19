extends Node2D
class_name World

@onready var map: TileMap = $TileMap
@onready var sub_map: TileMap = $TileMapLower
@onready var overlay_map: TileMap = $OverlayMap
@onready var water: Sprite2D = $Water
@onready var hp_bar: Control = $UI/BossHealth
@onready var cheese: PackedScene = preload("res://Prefabs/Items/cheese.tscn")
@onready var shopkeeper: PackedScene = preload("res://Prefabs/Shopkeeper.tscn")
@onready var spikes: PackedScene = preload("res://Prefabs/spikes.tscn")
@export var tile_sets: Array[TileSet]
@export var water_textures: Array[Texture2D]

@export var map_ammount: int
@export var random_cheese_chance: int = 10
@export var path: String
@export var enemy_list: Array[PackedScene]
@export var boss_list: Array[PackedScene]
@export var enemy_spawner_dictionary: Node
@export var debug: bool
@export var layer: int = 0

var img: Image
var enemy_count: int
var current_stage: int = 0
var current_enemy_list: int = 1
var current_boss_list: int = 1
var next_cheese: int = 0
var enemy_dict: Dictionary
var boss_dict: Dictionary
var shopkeeper_loaded: bool = false
var generating_world: bool
var unload_after_layer_exit: Array[Node]
var spawn_cheese_on_enemy_kill: bool = false
var change_tileset_on_next_round: bool = false

func _ready():
	if(!debug):
		next_cheese = calc_next_cheese_round()
		transition()
	enemy_dict = enemy_spawner_dictionary.dict
	boss_dict = enemy_spawner_dictionary.boss_dict
	#generate_world()

func update_tileset() -> void:
	var i: int = randi_range(0, tile_sets.size() - 1)
	map.tile_set = tile_sets[i]
	sub_map.tile_set = tile_sets[i]
	water.texture = water_textures[i]

func on_enemy_defeated(pos: Vector2) -> void:
	enemy_count -= 1
	
	if spawn_cheese_on_enemy_kill:
		if randi_range(1, 100) > random_cheese_chance: return
		var c = cheese.instantiate()
		c.position = pos
		unload_after_layer_exit.append(c)
		call_deferred("add_child", c)

func calc_next_cheese_round() -> int:
	var r: int = randi_range(0, 1)
	var n: int = 2 if r == 0 else 3
	return layer + n

func generate_floor_variant(chance: int) -> int:
	var variation: int = randi_range(0, 100)
	var pos: int = 0 if variation > chance else randi_range(1, 2)
	return pos

func check_left_edge_water_type(pos: Vector2) -> Vector2:
	var x: int = 3
	var y: int = 0
	
	#if theres water on the left
	if sub_map.get_cell_atlas_coords(0, Vector2(pos.x, pos.y)).x > 2:
		x = 4
	
	#if theres water on top
	if sub_map.get_cell_atlas_coords(0, Vector2(pos.x + 1, pos.y - 1)).x > 2:
		y = 1
	
	return Vector2(x, y)

func check_right_edge_water_type(pos: Vector2) -> Vector2:
	var x: int = 3
	var y: int = 0
	
	#if theres no water on the right
	if pos.x > 20 || img.get_pixel(int(pos.x + 1), int(pos.y)) != Color("#4c6885"):
		x = 5
		if(pos.y < 12):
			#if theres water below and no on top
			if (pos.y == 0) || (img.get_pixel(int(pos.x), int(pos.y + 1)) == Color("#4c6885") && img.get_pixel(int(pos.x), int(pos.y - 1)) != Color("#4c6885")):
				y = 0
			elif img.get_pixel(int(pos.x), int(pos.y + 1)) == Color("#4c6885"):
				y = 1
			else:
				y = 2
		else: y = 2
	else:
		y = 2
		#if theres water on the left
		if pos.x > 0 && img.get_pixel(int(pos.x - 1), int(pos.y)) == Color("#4c6885"):
			x = 4
		else:
			x = 3
	return Vector2(x, y)

func generate_world() -> void:
	
	#Load Image
	img = load(path).get_image()
	
	#Read every pixel from the source image
	for x in range(img.get_width()):
		for y in range(img.get_height()):
			#Get current pixel color
			var px: Color = img.get_pixel(x, y)
			
			#dollar store switch-case statement:
			match px: 
				Color("#f5ffe8"): #wall
					map.set_cell(0, Vector2(x + 1, y), 0, Vector2(2, 2))
				
				Color("#dfe0e8"): #wall top
					map.set_cell(0, Vector2(x + 1, y), 0, Vector2(2, 1))
				
				Color("#14182e"): #floor
					map.set_cell(0, Vector2(x + 1, y), 0, Vector2(generate_floor_variant(10), 0))
				
				Color("#291d2b"): #void
					map.set_cell(0, Vector2(x + 1, y), 0, Vector2(1, 2))
				
				Color("#ffae70"): #exit
					$Exit.position = Vector2((x + 1.5) * 48, (y + .5) * 48)
					map.set_cell(0, Vector2(x + 1, y), 0, Vector2(1, 1))
				
				Color("#cc2f7b"): #Enemy
					var entity
					var r = randi_range(0, 100)
					
					if layer % 10 != 0:
						for i in range(enemy_dict["data_%s" % current_enemy_list].chance.size()):
							if r <= enemy_dict["data_%s" % current_enemy_list].chance[i]:
								entity = enemy_list[enemy_dict["data_%s" % current_enemy_list].ids[i]].instantiate()
								break
					else:
						for i in range(boss_dict["data_%s" % current_boss_list].chance.size()):
							if r <= boss_dict["data_%s" % current_boss_list].chance[i]:
								entity = boss_list[boss_dict["data_%s" % current_boss_list].ids[i]].instantiate()
								hp_bar.set_bar(entity)
								break
					
					entity.global_position = Vector2((x + 1.5) * 48, (y + .5) * 48)
					entity.connect("defeated", on_enemy_defeated)
					call_deferred("add_child", entity) #cant mod world collisions while checking on_collision_enter() so call deferred do sum magic and fixes that 
					enemy_count += 1
					map.set_cell(0, Vector2(x + 1, y), 0, Vector2(generate_floor_variant(10), 0))
				
				Color("#ffee83"): #Player
					$Player.position = Vector2((x + 1.5) * 48, ((y + .5) * 48) + 3)
					map.set_cell(0, Vector2(x + 1, y), 0, Vector2(generate_floor_variant(10), 0))
					$Stairs.position = Vector2((x + 1.5) * 48, (y + .5) * 48)
				
				Color("#f0b541"): #cheese
					if layer >= next_cheese:
						var c = cheese.instantiate()
						c.position = Vector2((x + 1.5) * 48, (y + .5) * 48)
						unload_after_layer_exit.append(c)
						next_cheese = calc_next_cheese_round()
						call_deferred("add_child", c)
					map.set_cell(0, Vector2(x + 1, y), 0, Vector2(generate_floor_variant(10), 0))
				
				Color("#63ab3f"): #shopkeeper
					var s = shopkeeper.instantiate()
					s.position = Vector2((x + 1.5) * 48, (y + .5) * 48)
					call_deferred("add_child", s)
					map.set_cell(0, Vector2(x + 1, y), 0, Vector2(generate_floor_variant(10), 0))
					shopkeeper_loaded = true
				
				Color("#8f4d57"): #Spike
					var s = spikes.instantiate()
					s.position = Vector2((x + 1.5) * 48, (y + .5) * 48)
					call_deferred("add_child", s)
					map.set_cell(0, Vector2(x + 1, y), 0, Vector2(0, 1))
					unload_after_layer_exit.append(s)
				
				Color("#4fa4b8"): #central water
					map.erase_cell(0, Vector2(x + 1, y))
					sub_map.set_cell(0, Vector2(x + 1, y), 0, Vector2(4, 1))
				
				Color("#92e8c0"): #left or top edge water
					map.erase_cell(0, Vector2(x + 1, y))
					sub_map.set_cell(0, Vector2(x + 1, y), 0, check_left_edge_water_type(Vector2(x, y)))
				
				Color("#4c6885"): #bottom or right edge water
					map.erase_cell(0, Vector2(x + 1, y))
					sub_map.set_cell(0, Vector2(x + 1, y), 0, check_right_edge_water_type(Vector2(x, y)))

func set_visibility(to: bool) -> void:
	$Player.visible = to
	$UI.visible = to
	$UI/Health/Sprite2D.visible = to

func generate_stage() -> String:
	var pth: String
	var n: int
	if layer > 5:
		n = randi_range(1, map_ammount)
	else:
		n = randi_range(1, 5)
	while n == current_stage:
		if layer > 5:
			n = randi_range(1, map_ammount)
		else:
			n = randi_range(1, 5)
	current_stage = n
	pth = "res://Maps/Map_" + str(n) + ".png"
	if layer % 5 == 0 && layer % 10 != 0:
		pth = "res://Maps/Shop_1.png"
	elif layer % 10 == 0:
		pth = "res://Maps/Arena_1.png"
	return pth

func update_enemy_list() -> void:
	#current layer is greater than enemy list layer value
	if layer > enemy_dict["data_%s" % current_enemy_list].exit_layer:
		current_enemy_list += 1
	
	if layer > boss_dict["data_%s" % current_boss_list].exit_layer:
		current_boss_list += 1

func transition() -> void:
	generating_world = true
	set_visibility(false)
	img = load(path).get_image()
	for y in img.get_height():
		for x in img.get_width():
			overlay_map.set_cell(0, Vector2(x + 1, y), 0, Vector2(1, 2))
		await get_tree().create_timer(.075).timeout
	sub_map.clear()
	
	layer += 1
	path = generate_stage()
	update_enemy_list()
	
	if unload_after_layer_exit.size() > 0: 
		for i in unload_after_layer_exit.size():
			if unload_after_layer_exit[i] != null:
				unload_after_layer_exit[i].queue_free()
	
	if layer % 10 == 0:
		change_tileset_on_next_round = true
	if change_tileset_on_next_round && layer % 10 != 0:
		update_tileset()
		change_tileset_on_next_round = false
	
	generate_world()
	
	$Player.ammo_changed.emit()
	$UI/LayerLabel.text = "Layer %s" %layer
	
	for y in img.get_height():
		for x in img.get_width():
			overlay_map.set_cell(-1, Vector2(x + 1, y), -1, Vector2(1, 2))
		await get_tree().create_timer(.075).timeout
	set_visibility(true)
	generating_world = false

func _on_exit_body_entered(body):
	if body.name != "Player": return
	if enemy_count > 0: return
	transition()
	
