extends StaticBody2D

@onready var sprite: AnimatedSprite2D =  $AnimatedSprite2D
@onready var world: World = get_parent()

var state: String = "Up"
var body_list: Array[CharacterBody2D]

func _on_timer_timeout():
	state = "Up" if state == "Down" else "Down"
	sprite.play(state)
	apply_spike_damage()

func _on_area_2d_body_entered(body):
	if body.get_class() != "CharacterBody2D": return
	if world.generating_world: return
	if body.is_on_spikes: return
	
	body.is_on_spikes = true
	body_list.append(body)
	
	if state == "Down": return
	
	if body.name == "Player":
		body.apply_damage(1)
	else:
		body.apply_damage(1, Vector2.ZERO, 0)

func _on_area_2d_body_exited(body):
	if !body.get_class() == "CharacterBody2D": return
	
	body.is_on_spikes = false
	
	for i in range(body_list.size()):
		if body == body_list[i]:
			body_list.remove_at(i)
			return

func apply_spike_damage() -> void:
	for i in range(body_list.size()):
		if !body_list[i].is_on_spikes: continue
		
		if body_list[i].name == "Player":
			body_list[i].apply_damage(1)
		else:
			body_list[i].apply_damage(1, Vector2.ZERO, 0)

func _on_dmg_timer_timeout():
	if world.generating_world: return
	if state == "Down": return
	
	apply_spike_damage()
