extends Label

func _ready():
	#get text from file
	var file = FileAccess.open("res://Titles.txt", FileAccess.READ)
	var txt = file.get_as_text()
	
	#split text and store in an array
	var txt_list: PackedStringArray = txt.split("\n") #String.split() returns a packedStringArray
	text = txt_list[randi_range(0, txt_list.size() - 2)] 
	#for sum reason the .txt file generates an additional blank line at the end, so subtract 2 from its size
