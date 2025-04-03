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
	},
	"trig": {
		"name": "Trigonometry",
		"parameters": {
			"seed": 10,
			"size": Vector2i(12, 12),
			"randomness": 0.5,
			"generation": {
				"method": "sine",
				"frequency": Vector2(1.4, 1.2),
				"offset": Vector2(3, 3),
			}
		}
	},
	"ellipse": {
		"name": "Ellipse",
		"parameters": {
			"seed": 7,
			"size": Vector2i(10, 6),
			"randomness": 0.3,
			"generation": {
				"method": "ellipse",
				"scale": Vector2(1.4, 1.2),
			}
		}
	},
	"big": {
		"name": "Go Big",
		"parameters": {
			"seed": 3,
			"size": Vector2i(20, 20)
		}
	},
	"trig2": {
		"name": "Trig Harder",
		"parameters": {
			"seed": 11,
			"size": Vector2i(24, 16),
			"randomness": 0.5,
			"generation": {
				"method": "waveform",
				"series": [
					[
						{
							"amplitude": 0.5,
							"frequency": Vector2(1.4, 1.2),
							"offset": Vector2(3, 3),
						},
						{
							"amplitude": 0.5,
						}
					],
					[
						{
							"frequency": Vector2(2, .5)
						}
					],
					[
						{
							"amplitude": 1,
							"frequency": Vector2(1, 3),
							"offset": Vector2(3, 3),
						}
					],
					[
						{
							"amplitude": 2,
							"frequency": Vector2(4, 4),
						},
						{
							"amplitude": 2,
							"frequency": Vector2(1.6, .6)
						}
					]
				]
			}
		}
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
		}
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
		}
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
		}
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
		}
	},
	"tundra": {
		"name": "Tundra",
		"parameters": {
			"seed": 9,
			"size": Vector2i(20, 16),
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
				},
				{
					"type": "delta",
					"subject_column": 4,
					"variable_column": 3,
				},
				{
					"type": "delta",
					"subject_column": 5,
					"variable_column": 4,
				},
				{
					"type": "delta",
					"subject_row": 8,
					"variable_row": 5,
				}
			]
		}
	}
}
var chapters: Dictionary = {
	"chapter1": {
		"levels": ["intro", "basics", "trig", "ellipse", "big", "trig2"],
		"title": "Chapter 1"
	},
	"chapter2": {
		"levels": ["discovery", "mistrust", "y_can_too", "contradiction", "tundra"],
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

func get_next_level(level: String) -> String:
	var chapter_key = get_chapter_for_level(level)
	if chapter_key == "":
		return ""
	var level_index = chapters[chapter_key].levels.find(level)
	if level_index == -1:
		return ""
	if level_index == levels.size() - 1:
		var chapter_index = chapters.keys().find(chapter_key)
		if chapter_index == chapters.size() - 1:
			return ""
		else:
			return chapters[chapter_index + 1].levels[0]
	return levels.keys()[level_index + 1]

func has_next_level(level: String) -> bool:
	return get_next_level(level) != ""

func get_prev_level(level: String) -> String:
	var chapter_key = get_chapter_for_level(level)
	if chapter_key == "":
		return ""
	var level_index = chapters[chapter_key].levels.find(level)
	if level_index == -1:
		return ""
	if level_index == 0:
		var chapter_index = chapters.keys().find(chapter_key)
		if chapter_index == 0:
			return ""
		else:
			return chapters[chapter_index - 1].levels.back()
	return levels.keys()[level_index - 1]

func has_prev_level(level: String) -> bool:
	return get_prev_level(level) != ""

func get_chapter_for_level(level: String) -> String:
	for chapter in chapters.keys():
		if level in chapters[chapter].levels:
			return chapter
	return ""
