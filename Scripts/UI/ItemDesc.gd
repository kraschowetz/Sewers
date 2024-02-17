extends Node2D

class_name ItemDesc

@export var box: Sprite2D
@export var text: RichTextLabel 

func set_text(_text: String) -> void:
	self.text.text = _text 
