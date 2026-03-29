extends Node

var SAVE_DATA_PATH = "user://save_data.json"

var default_save_data = {
	highscore = 0
}

func _ready():
	pass
#	print(str(default_save_data.test.a))

func save_data_to_file(save_data):
	var file = File.new()
	
	file.open(SAVE_DATA_PATH, File.WRITE)
	file.store_line(to_json(save_data))
	file.close()

func load_data_from_file():
	var file = File.new()
	
	if file.file_exists(SAVE_DATA_PATH):
		file.open(SAVE_DATA_PATH, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		
		return data
	else:
		return default_save_data
