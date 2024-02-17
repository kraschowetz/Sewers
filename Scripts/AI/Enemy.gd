extends CharacterBody2D
class_name Enemy

@export_category("stats")
@export var is_boss: bool = false
@export var hp: int
@export var speed: int
@export var damage: int
@export_category("front-end")
@export var sprite: AnimatedSprite2D
@export var can_flip: bool
@export var has_multiple_animations: bool
@export var i_time: float

@onready var world: World = get_parent()

var is_defeated: bool = false
var on_mlee_range = false
var active: bool = false
var invincible: bool = false
var max_hp: int
var player: CharacterBody2D
var external_velocity: Vector2
var is_on_spikes: bool = false

signal defeated(pos: Vector2)

func _ready() -> void:
	player = world.get_node("Player")
	max_hp = hp
	if sprite:
		sprite.speed_scale = 1 + randf_range(-.3, .3)
	var s = speed
	speed = 0
	await  get_tree().create_timer(1.75).timeout
	active = true
	speed = s

func apply_external_velocity(dur: float, vel: Vector2) -> void:
	external_velocity = vel
	await get_tree().create_timer(dur).timeout
	external_velocity = Vector2.ZERO

func count_iframes() -> void:
	sprite.self_modulate = Color(255, 255, 255, 255)
	
	if i_time > 0: 
		invincible = true
		
	await get_tree().create_timer(.1).timeout
	sprite.self_modulate = Color(1, 1, 1, 1)
	
	if !invincible: return
	
	await get_tree().create_timer(i_time - .1).timeout
	invincible = false

func apply_damage(dmg: int, origin: Vector2, mod: float) -> void:
	hp -= dmg
	if is_defeated: return
	if invincible: return
	
	#calculate external velocity
	var direction: Vector2 = (origin - position).normalized()
	apply_external_velocity(0.1, direction * speed * -mod)
	
	if hp <= 0:
		defeated.emit(global_position)
		sprite.z_index = -3
		is_defeated = true
		world.unload_after_layer_exit.append(self)
		sprite.modulate = Color("#818181")
		return
	
	count_iframes()

func on_mlee_damage(dmg: int, origin: Vector2, mod: float) -> void:
	apply_damage(dmg, origin, mod)

func _process(_delta) -> void:
	if is_defeated:
		$CollisionShape2D.disabled = true
		velocity = external_velocity
		speed = 0
		sprite.play("defeated")
		move_and_slide()
		return
	
	velocity += external_velocity
	
	if can_flip:
		sprite.flip_h = true if player.position.x < position.x else false
	
	if has_multiple_animations:
		if velocity == Vector2.ZERO:
			sprite.play("idle")
		else:
			sprite.play("default")
