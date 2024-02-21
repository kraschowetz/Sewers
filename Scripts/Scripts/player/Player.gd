extends CharacterBody2D
class_name Player

signal hp_changed
signal cheese_changed
signal ammo_changed

@onready var anim: AnimatedSprite2D = $Sprite2D
@onready var gun: Node2D = $GunPivot/Musket
@onready var gun_pivot: Node2D = $GunPivot
@onready var world: Node2D = get_parent()
@onready var chromatic_aberration_shader: Sprite2D = get_node("../UI/ChromaticAberration")
@onready var upgrade_manager: Node = $UpgradeManager
@onready var reload_indicator = $'ReloadIndicator'
@export var reload_bar: TextureRect

@export var cheese: int
@export var i_time: float

@export_category("GUN CONFIG")
@export var bullet: PackedScene
@export var knockback_mod: float = 1

@export_category("DEBUG")
@export var godmode: bool

var hp: int = 2
var speed_mod: float = 1
var invincible: bool = false
var external_velocity: Vector2
var armed: bool = false
var is_on_spikes: bool = false

func apply_force(duration: float, force: Vector2) -> void:
	external_velocity = force
	await get_tree().create_timer(duration).timeout
	external_velocity = Vector2.ZERO

func _process(_delta) -> void:
	if world.paused: return
	
	if hp == 1 && Input.is_action_just_pressed("space") && cheese > 0:
		cheese -= 1
		hp += 1
		emit_signal("hp_changed")
		emit_signal("cheese_changed")
	
	handle_animations()

func add_cheese() -> void:
	cheese += 1
	emit_signal("cheese_changed")

func apply_damage(dmg: int) -> void:
	if invincible || godmode: return
	if hp < 1: return
	
	hp -= dmg
	
	emit_signal("hp_changed")
	
	if hp > 0:
		count_invincibility_time()

func count_invincibility_time() -> void:
	invincible = true
	anim.self_modulate = Color(255, 255, 255, 255)
	chromatic_aberration_shader.visible = true
	await get_tree().create_timer(i_time).timeout
	invincible = false
	chromatic_aberration_shader.visible = false
	anim.self_modulate = Color(1, 1, 1, 1)

func handle_animations() -> void:
	var axis = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	if armed && gun != null:
		if gun.ammo < 1 && !gun.is_reloading:
			reload_indicator.visible = true
		else:
			reload_indicator.visible = false
	else:
		reload_indicator.visible = false
	
	if axis == Vector2.ZERO && hp > 0:
		anim.play("Idle")
	elif axis != Vector2.ZERO && hp > 0:
		anim.play("Run")
	else:
		anim.play("Defeated")
	
	#tint
	if hp <= 1:
		if(!invincible):
			anim.self_modulate = Color("#ff6367")
	else:
		anim.self_modulate = Color(1, 1, 1, 1)
