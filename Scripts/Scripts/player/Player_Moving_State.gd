extends State

@export var base_speed: int
@export var body: CharacterBody2D
@export var sprite: AnimatedSprite2D
@export var player: Player
@export var world: World

func update(_delta: float) -> void:
	if world.generating_world: return
	if player.hp < 1: return
	var dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")) #get input as an axis
	
	if dir != Vector2.ZERO:
		body.velocity = dir.normalized() * base_speed * player.speed_mod
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, base_speed)
		body.velocity.y = move_toward(body.velocity.y, 0, base_speed)
	
	body.velocity += player.external_velocity
	
	body.move_and_slide()
	render()

func render() -> void:
	if(body.velocity.x != 0):
		var flip = true if Input.is_action_pressed("left") else false
		sprite.flip_h = flip
