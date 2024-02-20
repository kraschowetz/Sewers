extends Node2D

@onready var player: Player = get_parent()
@onready var unarmored_damage_timer: Timer = $UnarmedDamageTimer
@onready var slash_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var gun: Node2D

var can_deal_unarmed_damage: bool = true

signal shoot
signal reload
signal mlee_damage
signal throw

signal unarmed_damage(dmg: int, origin: Vector2, mod: float)

func _ready() -> void:
	update()

func update() -> void:
	shoot.connect(gun.on_shoot)
	reload.connect(gun.on_reload)
	throw.connect(gun.on_throw)
	gun.attach(player, get_node("../.."))
	gun.update()

func _process(_delta) -> void:
	if player.world.paused: return
	if player.hp < 1: return
	
	flip_gun()
	
	if Input.is_action_pressed("lmb"):
		if player.armed:
			shoot.emit()
		elif can_deal_unarmed_damage:
			unarmed_damage.emit(1, player.global_position, 3)
			slash_sprite.play("default")
			can_deal_unarmed_damage = false
			unarmored_damage_timer.start()
	
	if !player.armed: return
	
	if Input.is_action_pressed("rmb"):
		reload.emit()
	if Input.is_action_just_released("scroll") && player.armed:
		throw.emit()
		if is_connected("shoot", gun.on_shoot):
			shoot.disconnect(gun.on_shoot)
		if is_connected("reload", gun.on_reload):
			reload.disconnect(gun.on_reload)
		if is_connected("throw", gun.on_throw):
			throw.disconnect(gun.on_throw)

func flip_gun() -> void:
	var pos = get_viewport().get_mouse_position()
	
	look_at(pos)
	
	if !player.armed: return
	if player.gun == null: return
	gun.scale.y = -1 if pos.x < get_parent().position.x else 1

func _on_mlee_hit_area_body_entered(body):
	if player.armed: return
	if !body.get_class() == "CharacterBody2D": return
	if body.name == "Player": return
	if is_connected("unarmed_damage", body.on_mlee_damage): return
	
	unarmed_damage.connect(body.on_mlee_damage)

func _on_mlee_hit_area_body_exited(body):
	if player.armed: return
	if !body.get_class() == "CharacterBody2D": return
	if body.name == "Player": return
	if !is_connected("unarmed_damage", body.on_mlee_damage): return
	
	unarmed_damage.disconnect(body.on_mlee_damage)

func _on_timer_timeout(): #unarmed damage timer
	can_deal_unarmed_damage = true
