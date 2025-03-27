extends Node

var levels: Dictionary = {
	"intro": {
		"name": "Introduction",
		"parameters": {
			"seed": 1,
			"size": Vector2i(5, 5)
		},
		"next": "basics"
	},
	"basics": {
		"name": "Basics",
		"parameters": {
			"seed": 2,
			"size": Vector2i(8, 8)
		},
		"next": "big",
		"prev": "intro"
	},
	"big": {
		"name": "Go Big",
		"parameters": {
			"seed": 3,
			"size": Vector2i(20, 20)
		},
		"prev": "basics"
	}
}
var chapters: Dictionary = {
	"chapter1": {
		"levels": ["intro", "basics", "big"],
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
