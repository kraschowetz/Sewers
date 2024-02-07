extends State

@export var body: CharacterBody2D
@export var wander_Size: int
@export var player: CharacterBody2D
@export var ray: RayCast2D
@export var detection_range: int
@export var gun: Enemy_Gun

var spawn_point: Vector2
var target: Vector2
var motion: Vector2
var bounds: Vector2 = Vector2(1500, 650)

func enter() -> void:
	player = get_node("../../../Player")
	spawn_point = body.position
	set_target()

func update(_delta) -> void:
	if body.is_defeated: return
	
	if body.hp < body.max_hp:
		transitioned.emit(self, "chasing")
	
	motion = body.position.direction_to(target)
	body.velocity = motion.normalized() * (body.speed / 2)
	body.move_and_slide()
	
	if body.position.x > target.x - 16 && body.position.x < target.x + 16:
		if body.position.y > target.y - 16 && body.position.y < target.y + 16:
			set_target()
	
	ray.target_position = player.position - body.position
	
	if (ray.get_collision_point() - body.position).length() < detection_range:
		if(!ray.get_collider()): return
		if(ray.get_collider().name == "Player"):
			transitioned.emit(self, "chasing")
	
	if(gun):
		gun.target = target
	
	#DEBUG STUFF
	#check_for_detection()
	#draw_raycast_line()

func set_target() -> void:
	var x = randi_range(-1, 1)
	var y = randi_range(-1, 1)
	var v = Vector2(x, y).normalized() * randi_range(-wander_Size, wander_Size)
	
	if spawn_point.x + v.x > bounds.x || spawn_point.x + v.x < 32:
		return
	if spawn_point.y + v.y > bounds.y || spawn_point.y + v.y < 32:
		return
	
	target = spawn_point + v

func exit() -> void:
	$Line2D.visible = false

#DEBUG FUNCTIONS!

func check_for_detection() -> void:
	if (ray.get_collision_point() - body.position).length() < detection_range:
		body.get_node("./Sprite2D").self_modulate = Color(255, 0, 0)
	else:
		body.get_node("./Sprite2D").self_modulate = Color(1, 1, 1, 1)

func draw_raycast_line() -> void:
	$Line2D.clear_points()
	$Line2D.add_point(body.position)
	$Line2D.add_point(ray.get_collision_point())


func _on_area_2d_body_entered(_other) -> void:
	set_target()
