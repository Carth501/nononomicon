extends Node

var levels: Dictionary = {
	"intro": {
		"name": "Introduction",
		"parameters": {
			"seed": 1,
			"size": Vector2i(5, 5),
			"features":
				{
					"notes": false
				},
			"tutorial": '\tWelcome! This is a nonogram.\n' +
				'The goal is to fill in the squares according to the numbers on the top and left.' +
				'The numbers indicate how many squares are filled in a row or column.\n\n' +
				'\tFor example, if you see "3 1", it means there is a segment of three filled squares followed by a lone filled square.' +
				'You can mark squares with a simple left click, or flag them by right-clicking.\n\n' +
				'\tWhen you believe you are done, press the submit button.'
		}
	},
	"basics": {
		"name": "Basics",
		"parameters": {
			"seed": 2,
			"size": Vector2i(8, 8),
			"features":
				{
					"notes": false
				},
			"tutorial": '\tDifferent levels have different dimensions, but the logic still applies. ' +
				'Try filling in the lines with large numbers first.\n\tIf a number is greater than ' +
				'half the grid, it will occupy the middle squares.'
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
			},
			"tutorial": '\tDifferent levels can be generated by different methods. ' +
				'This level was generated using trigonometry, but the principles still apply.\n\n' +
				'\tThis level also has a new feature: Notes. Toggle the switch in the bottom ' +
				'left corner or hold control and click a square to add a note. ' +
				'Notes are not part of the solution, but they can help you keep track of your thoughts.'
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
		},
		"tutorial": '\tThis level is much larger than the previous ones. ' +
			'Size does not determine difficulty, but it can get overwhelming.' +
			'Don\'t worry, you are doing great!'
	},
	"trig2": {
		"name": "Trig Harder",
		"parameters": {
			"seed": 11,
			"size": Vector2i(24, 16),
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
			},
			'tutorial': "\tChaos, like so much else, can be beautiful."
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
			],
			'tutorial': "\tSee that thing below the grid? \tThis level introduces the first complication. " +
				"Complications are additional rules that can be applied to a line, or board.\n" +
				"\tThis one is the 'delta' complication. The numbers in the header of that column " +
				"do not correspond directly to what squares must be filled in. These numbers are " +
				"where the differences between the squares are between it and column 4.\n" +
				"\tIn this case, there are exactly 2 differences between columns 4 and 5, and they are not adjacent."
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
			],
			'tutorial': "\tComplications need not be lonely. This one has two delta complications, " +
				"with one referencing the other."
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
			],
			'tutorial': "\tComplications are not restricted to columns. " +
				"This one is on a row, but it still works the same way."
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
			],
			'tutorial': "\tThis one is big, with 4 complications. Don't worry, " +
				"I believe in you."
		}
	},
	"trig3": {
		"name": "Big Trig",
		"parameters": {
			"seed": 12,
			"size": Vector2i(24, 16),
			"complications": [
				{
					"type": "delta",
					"subject_column": 2,
					"variable_column": 1,
				},
				{
					"type": "delta",
					"subject_column": 8,
					"variable_column": 19,
				},
				{
					"type": "delta",
					"subject_column": 12,
					"variable_column": 8,
				},
				{
					"type": "delta",
					"subject_column": 6,
					"variable_column": 20,
				},
				{
					"type": "delta",
					"subject_column": 23,
					"variable_column": 19,
				},
				{
					"type": "delta",
					"subject_row": 8,
					"variable_row": 5,
				},
				{
					"type": "delta",
					"subject_row": 5,
					"variable_row": 12,
				},
				{
					"type": "delta",
					"subject_row": 12,
					"variable_row": 8,
				}
			],
			"generation": {
				"method": "waveform",
				"series": [
					[
						{
							"amplitude": 0.5,
							"frequency": Vector2(.8, 1.2),
							"offset": Vector2(3, 3),
							"nested": {
								"amplitude": 0.5,
								"frequency": Vector2(1, 1.2),
							}
						}
					],
					[
						{
							"amplitude": 2,
							"frequency": Vector2(.9, .9),
						},
						{
							"amplitude": 2,
							"frequency": Vector2(.6, .6)
						}
					]
				]
			}
		}
	},
}
var chapters: Dictionary = {
	"chapter1": {
		"levels": ["intro", "basics", "trig", "ellipse", "big", "trig2"],
		"title": "Chapter 1"
	},
	"chapter2": {
		"levels": ["discovery", "mistrust", "y_can_too", "contradiction", "tundra", "trig3"],
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
			var prev_chapter_key = chapters.keys()[chapter_index - 1]
			return chapters[prev_chapter_key].levels.back()
	return levels.keys()[level_index - 1]

func has_prev_level(level: String) -> bool:
	return get_prev_level(level) != ""

func get_chapter_for_level(level: String) -> String:
	for chapter in chapters.keys():
		if level in chapters[chapter].levels:
			return chapter
	return ""
