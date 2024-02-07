extends Node

@export var player: Player

func _ready() -> void:
	player.cheese_changed.connect(on_cheese_changed)
	on_cheese_changed()

func _process(_delta):
	#$Label.set_text(str(Engine.get_frames_per_second()))
	pass

func on_cheese_changed() -> void:
	var txt: String = str(player.cheese) if player.cheese > 9 else "0%s" % player.cheese
	$Label.text = str(txt)
