extends State

@onready var player: Player = get_node("../../../Player")
@onready var body: Enemy = get_node("../..")
@onready var wand: Enemy_Gun = get_node("../../Pivot/Gun")
@onready var pivot: Node2D = get_node("../../Pivot")
@onready var world: World = get_node("../../..")

func enter() -> void:
	$Timer.start()
	$RepositionTimer.start()

func update(_delta) -> void:
	$Timer.paused = world.paused
	$RepositionTimer.paused = world.paused
	pivot.look_at(player.position)

func _on_timer_timeout():
	wand.shoot()

func _on_reposition_timer_timeout():
	body.position = Vector2(180, 200)
