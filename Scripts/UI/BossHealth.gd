extends Control

@onready var bar: TextureRect = $Bar
@onready var tweenBar: TextureRect = $TweenBar
@onready var label: Label = $BossLabel
@onready var bar_fade_timer = $Timer

@export var max_hp: int

var current_hp: int
var max_size: float

func set_bar(boss: Enemy) -> void:
	if boss == null: return #delete later?
	
	visible = true
	
	max_hp = boss.hp
	label.text = boss.enemy_name
	boss.hp_changed.connect(update_hp)
	
	bar.size.x = 1000
	tweenBar.size.x = 1000
	
	current_hp = max_hp
	max_size = bar.size.x
	update_hp(max_hp)

func update_hp(new_hp: int) -> void:
	var tween = get_tree().create_tween()
	
	current_hp = new_hp
	
	bar.size.x = current_hp * (max_size / max_hp)
	tween.tween_property(tweenBar, "size", Vector2(bar.size.x, bar.size.y), .5)
	
	if current_hp <= 0:
		bar_fade_timer.start()

func _on_timer_timeout():
	visible = false
