extends Button

@onready var layer: CanvasLayer = get_node("../")

func _on_mouse_entered() -> void:
	add_theme_font_size_override("font_size", 40)

func _on_mouse_exited() -> void:
	add_theme_font_size_override("font_size", 30)

func _on_pressed():
	if !layer.visible: return
	
	get_tree().change_scene_to_file("res://Scenes/Debug.tscn")
	#Engine.max_fps = 1
