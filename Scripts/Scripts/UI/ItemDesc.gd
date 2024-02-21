extends Node2D

class_name ItemDesc

@export var text: RichTextLabel
@export var _min: Vector2
@export var _max: Vector2

func set_text(_text: String) -> void:
	self.text.text = _text 

func _ready() -> void:
	if global_position.x < _min.x:
		global_position.x = _min.x
	elif global_position.x > _max.x:
		global_position.x = _max.x
	
	if global_position.y < _min.y:
		global_position.y = _min.y
	elif global_position.y > _max.y:
		global_position.y = _max.y
