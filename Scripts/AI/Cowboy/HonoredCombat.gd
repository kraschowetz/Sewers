extends State

@onready var body: Enemy = get_node("../..")
@onready var player: Player = get_node("../../../Player")
@onready var pivot: Node2D = get_node("../../Pivot")
@onready var gun: Enemy_Gun = get_node("../../Pivot/Gun")
@onready var label: Label = get_node("../../Label")

var count_time: int = 1

func enter() -> void:
	body.invincible = true
	$InitTimer.start()
	label.text = "shoot on 3"

func update(_delta) -> void:
	pivot.look_at(player.position)
	if body.is_defeated:
		label.visible = false

func _on_timer_timeout():
	if body.is_defeated: return
	
	body.invincible = false
	var delay = .1 + (randf() / 3)
	await get_tree().create_timer(delay).timeout
	gun.shoot()
	await get_tree().create_timer(1).timeout
	body.invincible = true
	$InitTimer.start()

func _on_init_timer_timeout():
	if body.is_defeated: return
	
	count_time = 1
	label.text = "%s" % count_time
	count_time += 1
	$Timer.start()
	$SubTimer.start()

func _on_sub_timer_timeout():
	if body.is_defeated: return
	
	label.text = "%s" % count_time
	count_time += 1
	
	if count_time > 4:
		label.text = "shoot"
		return
	
	$SubTimer.start()
