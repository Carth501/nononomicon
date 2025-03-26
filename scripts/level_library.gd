extends Node

var levels: Dictionary = {
	"intro": {
		"name": "Introduction",
		"parameters": {
			"seed": 1,
			"size": Vector2i(5, 5)
		}
	},
	"basics": {
		"name": "Basics",
		"parameters": {
			"seed": 2,
			"size": Vector2i(8, 8)
		}
	}
}
var chapters: Dictionary = {
	"chapter1": {
		"levels": ["intro", "basics"],
		"title": "Chapter 1"
	}
}

func get_chapters() -> Dictionary:
	return chapters

func get_levels(list: Array) -> Dictionary:
	var result = {}
	for level in list:
		result[level] = levels[level]
	return result

func get_level(level: String) -> Dictionary:
	return levels[level]

func get_level_parameters(level: String) -> Dictionary:
	return levels[level].parameters