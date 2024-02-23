extends RigidBody2D
class_name Gun

@onready var origin_point: Marker2D = $OriginPoint
@onready var bullet_target_point: Marker2D = $BulletTargetPoint
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var precision_recovery_timer: Timer = $PrecisionRecoveryTimer
@onready var reload_timer: Timer = $ReloadTimer
@onready var sprite: Sprite2D = $Sprite2D
@onready var item_pickup_area: Area2D = $ItemPickupArea
@onready var price_label: Label = $Label
@onready var item_shine_mat: ShaderMaterial = preload("res://Shaders/Materials/ItemShineMaterial.tres")

@export_category("stats")
@export var gun_name: String
@export var price: int
@export var max_ammo: int
@export var precision: int
@export var damage: int
@export var bullet_velocity: int
@export var bullet_force: float = 2
@export var reload_time: float
@export var precision_recover_time: float
@export var fire_rate: float
@export var spray: float
@export var knockback: float = 0
@export var position_offset: Vector2

@export_category("spray management")
@export var bullet: PackedScene
@export var bullet_origin_vector: Vector2
@export var target_point: Array[Vector2]

@export_category("visuals")
@export var spr: Texture
@export var bar: TextureRect
@export var item_desc: PackedScene
@export_multiline var desc: String
@export var shoot_particle: PackedScene

signal mlee_damage(dmg: int, origin: Vector2, mod: float)

var player: Player = null
var world: World = null

var is_reloading: bool = false
var ammo: int
var can_shoot: bool = true
var shoot_num: int = 0
var can_deal_throw_damage: bool = false
var can_be_picked_up: bool = true

var itm_dsc: Node

#variavavies de upgrades
var reload_on_enemy_kill: bool = false

var connected: bool = false

func _ready() -> void:
	
	item_pickup_area.input_pickable = true
	
	ammo = max_ammo
	sprite.z_index = 3
	
	sleeping = true
	
	if !player:
		sprite.material = item_shine_mat
	
	if price > 0:
		price_label.text = "$%s" % price if price > 9 else "$0%s" % price
	

func _process(delta) -> void:
	if player: 
		reload_timer.paused = world.paused
		return
	if sleeping: return
	sprite.rotation -= 360 * delta

func update() -> void:
	origin_point.position = bullet_origin_vector
	bullet_target_point.position = target_point[0]
	fire_rate_timer.wait_time = fire_rate
	precision_recovery_timer.wait_time = precision_recover_time
	reload_timer.wait_time = reload_time
	sprite.texture = spr
	bar = player.reload_bar
	
	if connected: return
	
	fire_rate_timer.timeout.connect(_on_fire_rate_timer_timeout)
	precision_recovery_timer.timeout.connect(_on_precision_recovery_timer_timeout)
	reload_timer.timeout.connect(_on_reload_timer_timeout)
	
	connected = true
	

func attach(_player: Player, _world: World) -> void: #conecta a arma ao player
	player = _player
	world = _world
	
	player.armed = true
	sprite.material = null
	await get_tree().create_timer(.1).timeout
	player.gun_pivot.gun = self
	player.gun = self
	can_deal_throw_damage = true
	player.upgrade_manager.gun = self
	
	for i  in world.unload_after_layer_exit.size():
		if world.unload_after_layer_exit[i] == self:
			world.unload_after_layer_exit[i] = null

func detach() -> void:
	player.armed = false
	sprite.material = item_shine_mat
	player.ammo_changed.emit()
	world.unload_after_layer_exit.append(self)
	
	player = null

func on_shoot() -> void:
	if world.generating_world: return
	if ammo < 1: return
	if !can_shoot: return
	if is_reloading: return
	
	can_shoot = false
	
	precision_recovery_timer.stop()
	ammo -= 1
	
	var b: PackedScene
	
	if bullet:
		b = bullet
	else:
		b = player.bullet
	#atualizar UI
	player.emit_signal("ammo_changed")
	
	var instance: Node
	
	#atirar uma vez por ponto alvo
	for i in range(target_point.size()):
		instance = b.instantiate()
		
		instance.dmg = damage
		
		#atualiza o alvo da bala baseado na array
		bullet_target_point.position = target_point[i]
		instance.target = bullet_target_point.global_position
		
		instance.vel = bullet_velocity
		instance.global_position = origin_point.global_position
		instance.origin = origin_point.global_position
		instance.mod = bullet_force
		
		#maneja o spray
		if shoot_num > precision  && spray > 0:
			var p: Vector2 = bullet_target_point.position
			bullet_target_point.position.y += randf_range(-spray, spray)
			instance.target = bullet_target_point.global_position
			bullet_target_point.position = p
		
		world.add_child(instance)
	
	#instancia particula de tiro, se houver
	if shoot_particle:
		var particle = shoot_particle.instantiate()
		particle.position = origin_point.global_position
		particle.look_at(bullet_target_point.global_position)
		world.call_deferred("add_child", particle)
		particle.emitting = true
	
	#resetar a posição do alvo
	bullet_target_point.position = target_point[0]
	shoot_num += 1
	
	mlee_damage.emit(damage * target_point.size(), player.position, bullet_force)
	
	#knockback
	var knock_dir = bullet_target_point.global_position - player.global_position
	player.apply_force(0.1, knock_dir.normalized() * knockback * -350)
	
	fire_rate_timer.start()
	precision_recovery_timer.start()

func on_reload() -> void:
	if is_reloading: return
	if ammo >= max_ammo: return
	
	is_reloading = true
	
	#atualizar UI
	bar.size = Vector2(0, 8)
	bar.visible = true
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(bar, "size", Vector2(48, 8), reload_time)
	
	#fazer o player mais lento
	player.speed_mod = .25
	
	reload_timer.start()

func on_throw() -> void:
	#interromper recarga
	if is_reloading:
		is_reloading = false
		reload_timer.stop()
		is_reloading = false
		bar.visible = false
		player.speed_mod = 1
	
	detach()
	var new_parent = world
	var p = global_position
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = p
	
	look_at(get_global_mouse_position())
	var angle = rotation
	apply_central_force(Vector2(cos(angle), sin(angle)) * 40 * 1000)
	price = 0
	price_label.visible = false
	can_be_picked_up = false
	await get_tree().create_timer(.1).timeout
	can_be_picked_up = true

func _on_fire_rate_timer_timeout() -> void:
	can_shoot = true

func _on_precision_recovery_timer_timeout() -> void:
	shoot_num = 0

func _on_reload_timer_timeout() -> void:
	ammo = max_ammo
	player.speed_mod = 1
	
	#atualizar UI
	is_reloading = false
	bar.visible = false
	player.emit_signal("ammo_changed")

func _on_item_pickup_area_body_entered(body) -> void:
	#pegar arma
	if !player:
		if body.name != "Player":
			sleeping = true
		if body.name == "Player" && !body.armed && body.cheese >= price && can_be_picked_up:
			if itm_dsc:
				itm_dsc.queue_free()
				itm_dsc = null
			attach(body, body.world)
			await get_tree().create_timer(0.1).timeout
			body.armed = true
			sprite.rotation = 0
			rotation = 0
			get_parent().call_deferred("remove_child", self)
			body.gun_pivot.call_deferred("add_child", self)
			body.gun_pivot.update()
			position = position_offset
			player.ammo_changed.emit()
			player.cheese -= price
			player.cheese_changed.emit()
			price_label.visible = false
		
		#throw damage
		if body.get_class() != "CharacterBody2D": 
			can_deal_throw_damage = false
			return
		if body.name == "Player": 
			can_deal_throw_damage = false
			return
		if !can_deal_throw_damage: return
		
		body.apply_damage(1, global_position, 10)
		can_deal_throw_damage = false
		
		if !reload_on_enemy_kill: return
		
		if body.hp < 1:
			ammo = max_ammo
		
		return
	#dano corpo a corpo
	if body.get_class() != "CharacterBody2D": return
	if body.name == "Player": return
	if is_connected("mlee_damage", body.on_mlee_damage): return
	
	mlee_damage.connect(body.on_mlee_damage)

func _on_item_pickup_area_body_exited(body) -> void:
	if body.get_class() != "CharacterBody2D": return
	if body.name == "Player": return
	if !is_connected("mlee_damage", body.on_mlee_damage): return
	
	mlee_damage.disconnect(body.on_mlee_damage)

func _on_item_pickup_area_mouse_entered() -> void:
	if !item_desc: return
	if player: return
	if !sleeping: return
	
	itm_dsc = item_desc.instantiate()
	var p: Vector2 = Vector2(position.x - 48 * 2.5, position.y - 48 * 3.5)
	itm_dsc.global_position = p
	if !world:
		get_parent().call_deferred("add_child", itm_dsc)
	else:
		world.call_deferred("add_child", itm_dsc)
		world.unload_after_layer_exit.append(itm_dsc)
	itm_dsc.set_text(desc)


func _on_item_pickup_area_mouse_exited() -> void:
	if !item_desc: return
	if player: return
	if !sleeping: return
	if !itm_dsc: return
	
	if world:
		for i in range(world.unload_after_layer_exit.size()):
			if world.unload_after_layer_exit[i] == itm_dsc:
				world.unload_after_layer_exit.remove_at(i)
				break
	
	itm_dsc.queue_free()
	itm_dsc = null
