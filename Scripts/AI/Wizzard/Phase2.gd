extends State

@onready var world: World = get_node("../../..")
@onready var body: Enemy = get_node("../..")

@export var wall: PackedScene

var can_attack: bool = false
var wall_ammount: int = 10

func enter() -> void:
	var tween: Tween = get_tree().create_tween()
	body.invincible = true
	body.sprite.self_modulate = Color(0, 0, 0, 1)
	$InitTimer.start()
	tween.tween_property(body, "position", Vector2(980, 370), 3)

func update(_delta) -> void:
	$WallSpawnTimer.paused = world.paused

func _on_init_timer_timeout():
	can_attack = true
	body.sprite.self_modulate = Color(1, 1, 1, 1)

func _on_wall_spawn_timer_timeout():
	if !can_attack || wall_ammount <= 0 || body.is_defeated: return
	
	var i = wall.instantiate()
	var n = randi_range(-4, 4)
	var pos = Vector2(body.position.x + 104, body.position.y + n * 48)
	i.position = pos
	world.call_deferred("add_child", i)
	
	wall_ammount -= 1
	
	if wall_ammount == 0:
		$OpeningTimer.start()
		body.invincible = false

func _on_opening_timer_timeout():
	wall_ammount = randi_range(8, 16)
	body.invincible = true
