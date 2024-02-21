extends Button

@onready var main_layer: CanvasLayer = get_node("../")
@onready var config_layer: CanvasLayer = get_node("../../ConfigLayer")

func _on_pressed() -> void:
	main_layer.visible = false
	config_layer.visible = true

func _on_mouse_entered() -> void:
	add_theme_font_size_override("font_size", 40)

func _on_mouse_exited() -> void:
	add_theme_font_size_override("font_size", 30)
