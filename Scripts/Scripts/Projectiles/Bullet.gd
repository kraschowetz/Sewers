extends RigidBody2D
class_name Bullet

@export var explosion: PackedScene

var dmg: int
var target: Vector2
var vel: int
var mod: float
var shot_by_enemy: bool
var origin: Vector2

func _ready() -> void:
	look_at(target)
	var angle = rotation
	apply_central_force(Vector2(cos(angle), sin(angle)) * vel * 1000)
	
	clear()

func clear() -> void:
	await get_tree().create_timer(2).timeout
	queue_free()

func _on_bullet_area_2d_body_entered(body):
	if explosion:
		var e = explosion.instantiate()
		e.position = global_position
		get_parent().call_deferred("add_child", e)
	if body.get_class() == "CharacterBody2D":
		if shot_by_enemy && body.name != "Player":
			queue_free()
			return
		if shot_by_enemy:
			body.apply_damage(dmg)
		else:
			body.apply_damage(dmg, origin, mod)
	queue_free()
"""
DOCUMENTACIÒN:
	var target = direction of the bullet
	
	func _ready():
		set target to mouse pos
		look at target
		apply a force to the bullet's RigidBody2D towards the target
		call clear() function
	
	func clear():
		create a x seconds timer
		when timer is over delete bullet
"""
