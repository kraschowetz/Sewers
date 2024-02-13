extends Node2D
class_name Enemy_Gun

@onready var pivot = get_parent()
@onready var ref = get_node("../../Ref")
@onready var timer = $Timer
@onready var fire_rate_timer = $"Fire Rate Timer"
@onready var point: Marker2D = $Marker2D
@onready var world = get_node("../../..")
@onready var body = get_node("../..")

@export var gun_name: String
@export var max_ammo: int
@export var precision: int
@export var damage: int
@export var bullet_velocity: int
@export var reload_time: float
@export var precision_recover_time: float
@export var fire_rate: float
@export var spray: float
@export var bullet: PackedScene
@export var bullet_spawn_point: Vector2
@export var target_point: Array[Vector2]
@export var bar: TextureRect
@export var rotation_delay: float

var can_shoot: bool = true
var target: Vector2
var ammo: int

func _ready() -> void:
	fire_rate_timer.wait_time = fire_rate
	ammo = max_ammo
	timer.wait_time = reload_time

func _process(delta):
	if body.is_defeated: return
	
	ref.look_at(target)
	pivot.rotation = lerp(pivot.rotation, ref.rotation, delta * rotation_delay)
	pivot.scale.y = -1 if target.x < pivot.global_position.x else 1
	

func reload() -> void:
	if timer.is_stopped():
		timer.start()

func shoot() -> void:
	if !can_shoot: return
	if ammo < 1:
		reload()
		return

	var instance: Node
	
	for i in range(target_point.size()):
		#instanciate a copy of the bullet prefab
		instance = bullet.instantiate()
		instance.dmg = damage
		
		#SET TARGET BASED ON TARGET ARRAY
		$Target.position = target_point[i]
		instance.target = $Target.global_position
		
		instance.vel = bullet_velocity
		instance.global_position = point.global_position
		instance.shot_by_enemy = true
		
		#MANAGE BULLET SPRAY
		#instance.spray = Vector2(randf_range(-spray, spray), randf_range(-spray, spray))
		var p = $Target.position
		$Target.position.y += randf_range(-spray, spray)
		instance.target =  $Target.global_position
		$Target.position = p
		world.add_child(instance)
	
	ammo -= 1
	
	can_shoot = false
	if fire_rate_timer.is_stopped():
		fire_rate_timer.start()
	

func _on_timer_timeout():
	ammo = max_ammo

func _on_fire_rate_timer_timeout():
	can_shoot = true
