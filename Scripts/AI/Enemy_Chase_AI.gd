extends State

@export var body: CharacterBody2D
@export var player: CharacterBody2D
@export var atk_timer: Timer

var motion: Vector2
var near_player: bool
var is_atacking: bool = false

func enter() -> void:
	player = get_node("../../../Player")

func update(_delta) -> void:
	if body.is_defeated: return
	
	if(near_player): 
		atack()
		return
	motion = body.position.direction_to(player.position)
	body.velocity = (motion.normalized() * body.speed) + (body.external_velocity / 2)
	body.move_and_slide()

func atack() -> void:
	if is_atacking: return
	if !near_player: return
	
	is_atacking = true
	player.apply_damage(body.damage)
	if player.hp > 0:
		atk_timer.start()

func _on_area_2d_body_entered(other):
	if(other.name == "Player"):
		near_player = true

func _on_area_2d_body_exited(other):
	if(other.name == "Player"):
		near_player = false

func _on_timer_timeout():
	is_atacking = false
