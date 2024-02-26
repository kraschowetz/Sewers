extends Button

@onready var layer: CanvasLayer = get_node("../")

@export var layer_select: CanvasLayer

var show_opt_menu: bool = false

func _ready() -> void:
	var file = FileAccess.open("res://LevelsReached.txt", FileAccess.READ)
	var txt = file.get_as_text()
	var lines: PackedStringArray = txt.split("\n")
	if !lines[1].split("/")[0] == "0":
		show_opt_menu = true

func _on_mouse_entered() -> void:
	add_theme_font_size_override("font_size", 40)

func _on_mouse_exited() -> void:
	add_theme_font_size_override("font_size", 30)

func _on_pressed():
	if !layer.visible: return
	
	if show_opt_menu:
		layer_select.visible = true
		layer.visible = false
		return
	
	get_tree().change_scene_to_file("res://Scenes/Debug.tscn")
	#Engine.max_fps = 1
