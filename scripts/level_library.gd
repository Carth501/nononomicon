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
	"ellipse": {
		"name": "Ellipse",
		"parameters": {
			"seed": 7,
			"size": Vector2i(12, 12)
		},
		"next": "discovery",
		"prev": "basics"
	},
	"big": {
		"name": "Go Big",
		"parameters": {
			"seed": 3,
			"size": Vector2i(20, 20)
		},
		"next": "discovery",
		"prev": "basics"
	},
	"discovery": {
		"name": "Discovery",
		"parameters": {
			"seed": 4,
			"size": Vector2i(6, 6),
			"complications": [
				{
					"type": "delta",
					"subject_column": 4,
					"variable_column": 3,
				}
			]
		},
		"next": "mistrust",
		"prev": "big"
	},
	"mistrust": {
		"name": "Mistrust",
		"parameters": {
			"seed": 5,
			"size": Vector2i(8, 8),
			"complications": [
				{
					"type": "delta",
					"subject_column": 4,
					"variable_column": 3,
				},
				{
					"type": "delta",
					"subject_column": 5,
					"variable_column": 4,
				}
			]
		},
		"next": "contradiction",
		"prev": "discovery"
	},
	"y_can_too": {
		"name": "Y Can Too",
		"parameters": {
			"seed": 8,
			"size": Vector2i(8, 8),
			"complications": [
				{
					"type": "delta",
					"subject_row": 4,
					"variable_row": 5,
				}
			]
		},
		"prev": "mistrust"
	},
	"contradiction": {
		"name": "Contradiction",
		"parameters": {
			"seed": 6,
			"size": Vector2i(8, 8),
			"complications": [
				{
					"type": "delta",
					"subject_column": 2, # index, starts at 0
					"variable_column": 1,
				},
				{
					"type": "delta",
					"subject_column": 3,
					"variable_column": 2,
				}
			]
		},
		"prev": "mistrust"
	}
}
var chapters: Dictionary = {
	"chapter1": {
		"levels": ["intro", "basics", "ellipse", "big"],
		"title": "Chapter 1"
	},
	"chapter2": {
		"levels": ["discovery", "mistrust", "y_can_too", "contradiction"],
		"title": "Chapter 2"
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

func level_exists(level: String) -> bool:
	return levels.has(level)