extends State

@onready var body = get_node("../..")
@onready var timer = $Timer

@export var bounds: Vector2
@export var gun: Enemy_Gun

var target: Vector2
var motion: Vector2

func enter() -> void:
	set_target()
	timer.start()

func update(_delta) -> void:
	if body.is_defeated: return
	
	if !body.invincible:
		body.invincible = true
	
	motion = body.position.direction_to(target)
	body.velocity = (motion.normalized() * (body.speed / 1.25)) + body.external_velocity
	body.move_and_slide()
	
	if gun:
		gun.target = target
	
	if body.position.x > target.x - 24 && body.position.x < target.x + 24:
		if body.position.y > target.y - 24 && body.position.y < target.y + 24:
			set_target()
	
	body.sprite.flip_h = true if body.position.x > target.x else false

func exit() -> void:
	body.invincible = false

func set_target() -> void:
	var x = randi_range(48, bounds.x)
	var y = randi_range(96, bounds.y)
	target = Vector2(x, y)


func _on_timer_timeout():
	transitioned.emit(self, "rushing")
