extends Label

@onready var player: Player = get_node("../../Player")
@onready var timer: Timer = $Timer

var dir: int = 1

var alpha_tween: Tween
var rotation_tween: Tween
var scale_tween: Tween

func _ready() -> void:
	player.ammo_changed.connect(on_ammo_changed)

func on_ammo_changed() -> void:
	self_modulate = Color(1, 1, 1, 1)
	if !player.armed:
		visible = false
	
	if player.gun.ammo > 0:
		visible = false
		return
	
	visible = true
	timer.start()

func _on_timer_timeout() -> void:
	self_modulate = Color(1, 1, 1, 1)
	alpha_tween = get_tree().create_tween()
	alpha_tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 1)

func _on_anim_timer_timeout():
	if !visible: return
	if !player.armed: return
	
	apply_animations()

func apply_animations() -> void:
	rotation_tween = get_tree().create_tween()
	scale_tween = get_tree().create_tween()
	
	rotation_tween.tween_property(self, "rotation", .15 * dir, 1)
	
	var v: Vector2 = Vector2(1.25, 1.25) if scale == Vector2(1, 1) else Vector2(1, 1)
	scale_tween.tween_property(self, "scale", v, 1)
	
	dir *= -1

func _on_visibility_changed():
	if !player.armed: return
	
	if visible: 
		apply_animations()
		return
	
	self_modulate = Color(1, 1, 1, 1)
	scale = Vector2(1, 1)
	rotation = 0
	
	if alpha_tween:
		alpha_tween.stop()
	if rotation_tween:
		rotation_tween.stop()
	if scale_tween:
		scale_tween.stop()
