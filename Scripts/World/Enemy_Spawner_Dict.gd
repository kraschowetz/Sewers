extends Node

var dict = {
	"data_1": Enemy_Spawner_Data.new([0], [100], 5),
	"data_2": Enemy_Spawner_Data.new([0, 1], [55, 100], 10),
	"data_3": Enemy_Spawner_Data.new([1, 2], [75, 100], 20),
	"data_4": Enemy_Spawner_Data.new([1, 2, 3], [70, 90, 100], 255),
}

var boss_dict = {
	"data_1": Enemy_Spawner_Data.new([0], [100], 11),
	"data_2": Enemy_Spawner_Data.new([1, 2], [50, 100], 255)
}
