extends Control

@export var bar: TextureRect
@export var tween_bar: TextureRect

var max_health: int
var health: int 

func set_bar(e: Enemy) -> void:
	max_health = e.hp
	health = max_health
	bar.size.x = health * (48 / max_health)
	e.hp_changed.connect(update_bar)
	visible = false

func update_bar(new: int) -> void:
	visible = true
	
	health = new
	bar.size.x = health * (48 / max_health)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(tween_bar, "size", Vector2(bar.size.x, bar.size.y), .15)
	
	if health <= 0:
		visible = false
