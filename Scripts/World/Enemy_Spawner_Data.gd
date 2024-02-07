extends Node
class_name Enemy_Spawner_Data

var ids: Array[int]
var chance: Array[int]
var exit_layer: int

func _init(_ids: Array[int], _chance: Array[int], _exit_layer: int):
	self.ids = _ids
	self.chance = _chance
	self.exit_layer = _exit_layer
