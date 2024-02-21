extends Button

@onready var layer: CanvasLayer = get_node("../")
@onready var main_layer: CanvasLayer = get_node("../../MainLayer")

func _on_pressed():
	if !layer.visible: return
	
	layer.visible = false
	main_layer.visible = true

func _on_mouse_entered():
	add_theme_font_size_override("font_size", 40)

func _on_mouse_exited():
	add_theme_font_size_override("font_size", 30)
