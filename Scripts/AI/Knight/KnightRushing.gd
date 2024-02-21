extends State

@onready var body: Enemy = get_node("../..")

@export var gun: Enemy_Gun
@export var gun_pivot: Node2D

var player: Player
var knocked: bool = false
var motion: Vector2
var hp: int
var shot: bool = false

func enter() -> void:
	knocked = false
	shot = false
	hp = body.hp
	player = body.world.get_node("./Player")

func update(_delta: float) -> void:
	if body.is_defeated: return
	
	if knocked || shot: 
		body.velocity = body.external_velocity * 2
		body.move_and_slide()
		body.sprite.play("knocked")
		return
	
	if gun:
		gun_pivot.look_at(player.position)
		if !shot && body.position.distance_to(player.position) < 94:
			gun.shoot()
			shot = true
	
	motion = body.position.direction_to(player.position)
	body.velocity = (motion.normalized() * body.speed * 5) + body.external_velocity * 2
	body.move_and_slide()
	
	if body.hp < hp || shot:
		knocked = true
		$Timer.start()
		#transitioned.emit(self, "wander")
		#body.invincible = true

func _on_timer_timeout():
	transitioned.emit(self, "wander")
