extends Node

var data: Dictionary

func _ready() -> void:
	var file = FileAccess.open("res://data/localizations/powers_en.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var json_data = file.get_as_text()

		var error = json.parse(json_data)
		if error != OK:
			print("Error parsing JSON: ", error)
			return
		data = json.data
		file.close()
	else:
		print("Powers data file not found.")
