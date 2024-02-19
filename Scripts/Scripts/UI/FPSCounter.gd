extends Label

func _input(event) -> void:
	if event.is_action_pressed("F3"):
		visible = !visible

func _process(_delta) -> void:
	if !visible: return
	
	text = "%s/s" % Engine.get_frames_per_second()
