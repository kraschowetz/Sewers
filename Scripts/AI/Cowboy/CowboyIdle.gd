extends State

@onready var body: Enemy = get_node("../..")
@onready var label: Label = get_node("../../Label")

var started: bool = false

func enter() -> void:
	body.invincible = true
	dialogue()

func _on_area_2d_body_entered(_body) -> void:
	if _body.name == "Player":
		transitioned.emit(self, "honoredcombat")
		started = true
func _on_area_2d_body_exited(_body) -> void:
	if _body.name == "Player":
		body.scale = Vector2.ONE

func dialogue() -> void:
	label.text = "lets have an honored battle"
	await get_tree().create_timer(5).timeout
	if started: return
	label.text = ""
