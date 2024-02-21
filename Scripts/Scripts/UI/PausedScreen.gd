extends Control

@onready var world: World = get_node("../..")

func _on_world_state_changed():
	visible = !world.paused
