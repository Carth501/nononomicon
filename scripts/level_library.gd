extends Node

var levels: Dictionary = {
	"intro": {
	"name": "Introduction",
	"parameters": {
		"seed": 1.0,
		"size": Vector2i(5, 5)
		}
	}
}
var chapters: Dictionary = {
	"chapter1": {
		"levels": ["intro"],
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

func get_level_parameters(level: String) -> Dictionary:
	return levels[level].parameters