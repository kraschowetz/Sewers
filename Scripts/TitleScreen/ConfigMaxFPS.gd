extends TextEdit

@onready var layer: CanvasLayer = get_node("../..")

func _on_text_changed() -> void:
	if !layer.visible: return


func _on_gui_input(event) -> void:
	if !layer.visible: return
	
	if event is InputEventKey && event.is_action_pressed("enter"):
		var s = text.split("\n")
		text = "%s" % (int)(s[0])
		release_focus()
		Engine.max_fps = (int)(text)


func _on_button_vsync_changed():
	text = "%s" % Engine.max_fps
