extends Button

@export var lvl: int = 0
@export var id: int = 0
@export var cheese: int = 0

var unlocked: bool = false

func _ready() -> void:
	var file = FileAccess.open("res://LevelsReached.txt", FileAccess.READ)
	var txt = file.get_as_text()
	var lines: PackedStringArray = txt.split("\n")
	if lines[id].split("/")[0] == "1":
		unlocked = true

func _on_pressed():
	if !visible: return
	
	print(id)
	Global.starting_layer = lvl
	Global.starting_cheese = cheese
	get_tree().change_scene_to_file("res://Scenes/Debug.tscn")

func _on_mouse_entered():
	add_theme_font_size_override("font_size", 40)

func _on_mouse_exited():
	add_theme_font_size_override("font_size", 30)

func _on_visibility_changed():
	if visible && !unlocked:
		visible = false
