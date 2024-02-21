extends Control

@onready var chromatic_aberration_shader = get_node("../ChromaticAberration")
@onready var player = get_node("../../Player")

func _ready() -> void:
	player.hp_changed.connect(on_hp_changed)

func on_hp_changed() -> void:
	if player.hp > 0: return
	
	visible = true
	await get_tree().create_timer(player.i_time).timeout
	chromatic_aberration_shader.visible = true

func _input(event):
	if !visible: return
	
	if event.is_action_released("R"):
		get_tree().change_scene_to_file("res://Scenes/Debug.tscn")
