extends State

@onready var player: Player = get_node("../../../Player")
@onready var body: Enemy = get_node("../..")
@onready var wand: Enemy_Gun = get_node("../../Pivot/Gun")
@onready var pivot: Node2D = get_node("../../Pivot")
@onready var world: World = get_node("../../..")

var min_position: Vector2 = Vector2(48, 96)
var max_position: Vector2 = Vector2(1100, 600)
var can_shoot: bool = true

func enter() -> void:
	await get_tree().create_timer(1.5).timeout
	$Timer.start()
	$RepositionTimer.start()

func update(_delta) -> void:
	$Timer.paused = world.paused
	$RepositionTimer.paused = world.paused
	$ReposOpeningTimer.paused = world.paused
	pivot.look_at(player.position)
	
	if body.hp <= 22:
		transitioned.emit(self, "phase2")

func _on_timer_timeout():
	if body.is_defeated || !can_shoot: return
	if body.hp <= 22: return
	
	wand.shoot()

func _on_reposition_timer_timeout():
	if body.hp <= 22: return
	
	$ReposOpeningTimer.start()
	var x = randi_range(min_position.x, max_position.x)
	var y = randi_range(min_position.y, max_position.y)
	
	can_shoot = false
	body.invincible = true
	
	body.sprite.self_modulate = Color(0, 0, 0, 1)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(body, "position", Vector2(x, y), 3)

func _on_repos_opening_timer_timeout():
	if body.hp <= 22: return
	
	body.sprite.self_modulate = Color(1, 1, 1, 1)
	can_shoot = true
	body.invincible = false
