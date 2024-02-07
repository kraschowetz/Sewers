extends State

@onready var player: Node2D = get_node("../../../Player")

@export var agent: NavigationAgent2D
@export var body: CharacterBody2D
@export var gun: Enemy_Gun
@export var ray: RayCast2D
@export var reposition_size: int
@export var max_distance: int

var near_target: bool
var can_shoot: bool = true
var shoot_delay: float
var target: Vector2
var spawn_point: Vector2
var bounds: Vector2 = Vector2(1500, 650)

var speed

func enter() -> void:
	shoot_delay = gun.fire_rate + randf()
	$"Shoot Timer".wait_time = shoot_delay
	spawn_point = body.position
	$"Nav Timer".start()
	pathfind()
	set_target()

func update(_delta) -> void:
	if body.is_defeated: return
	if !body.active: return
	
	if body.position.distance_to(player.position + target) < 4:
		speed = 0
	else: speed = body.speed
	
	if gun:
		gun.target = player.position
		
		#detect if aiming towards player
		ray.target_position = player.position - body.position
		
		if(ray.get_collider() && ray.get_collider().name == "Player"):
			if(can_shoot):
				gun.shoot()
				can_shoot = false
				$"Shoot Timer".start()
	if !near_target:
		var dir = body.to_local(agent.get_next_path_position()).normalized()
		body.velocity = dir * speed
		body.velocity += body.external_velocity
		body.move_and_slide()
	
	#draw_line()

func set_target() -> void:
	var d: Vector2 = Vector2(randf(), randf()).normalized() #set direction
	
	$"Target Timer".stop()
	$"Target Timer".start()
	target = d * max_distance

func pathfind() -> void:
	agent.target_position = player.position + target 

func _on_nav_timer_timeout() -> void:
	pathfind()
	$"Nav Timer".start()

func _on_target_timer_timeout():
	set_target()

func _on_area_2d_body_entered(other):
	if(other.name != "Player"): 
		set_target()
		return
	near_target = true

func _on_area_2d_body_exited(other):
	if(other.name != "Player"): return
	near_target = false

func _on_shoot_timer_timeout():
	can_shoot = true

#DEBUG FUNCTIONS

func draw_line() -> void:
	$Line2D.clear_points()
	
	$Line2D.add_point(player.position)
	$Line2D.add_point(player.position + target )


