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
			"tutorial": '\tOne should not attempt these challenges without ambition. ' +
				'The secrets contained are encoded such that you will learn their purpose ' +
				'as you craft their construction.\n' +
				'\tVenture no further, however, if you find a piece of yourself missing. ' +
				'It cannot be stated plainly enough: there is evil in these pages, and ' +
				'greater evils to confront will be all that you earn.\n' +
				'To begin, fill in the squares according to the numbers on the top and left. ' +
				'The numbers indicate how many squares are filled in a row or column, and the ' +
				'length of the segments they should make up.\n\t"3 1" means ' +
				'there is a segment of three filled squares followed by a lone filled square.' +
				'Mark with left click, flag with the right. Submit when you believe yourself done.'
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
			"tutorial": 'For these simple spells, look for the highest numbers first.'
		}
	},
	"didactic": {
		"name": "Didactic",
		"parameters": {
			"seed": 13,
			"size": Vector2i(8, 8),
			"randomness": 2,
			"generation": {
				"method": "sine",
				"frequency": Vector2(6, 1),
			}
		}
	},
	"jack_and_hide": {
		"name": "Jack and Hide",
		"parameters": {
			"seed": 14,
			"size": Vector2i(16, 6),
			"randomness": 0.5,
			"tutorial": 'Differences in thought emerge, but the pattern may ' +
				'yet be preserved. These shapes are not harmless, but you are not their target.'
		}
	},
	"elaborate": {
		"name": "Elaborate",
		"parameters": {
			"seed": 16,
			"size": Vector2i(8, 8),
			"randomness": 0.5,
			"generation": {
				"method": "sine",
				"frequency": Vector2(5, 5),
			}
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
			"tutorial": 'A cage you have escape from, yet you are still here. ' +
				'This author may only wonder at your reasons, but do not err; ' +
				'this text will provide no gift nor boon.'
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
	"locks": {
		"name": "Locks",
		"parameters": {
			"seed": 17,
			"size": Vector2i(12, 8),
			"randomness": 0.9,
			"generation": {
				"method": "ellipse",
				"scale": Vector2(0.8, 1.1),
			},
			"locks": [
				Vector2i(6, 7),
				Vector2i(3, 5),
				Vector2i(2, 2),
				Vector2i(8, 1)],
			"tutorial": "\tThe first locked squares. These answers are provided, " +
				"but that may not make the pattern easy, maybe mearly possible."
		}
	},
	"response": {
		"name": "Response",
		"parameters": {
			"seed": 18,
			"size": Vector2i(6, 6),
			"powers": {"power_divine": {"charges": 2}},
			"tutorial": '\tThe first power granted. Divination can give sight into ' +
				'the truth, but it is not to be wasted. Use it with purpose, as ' +
				'it will not be replenished before the next page.'
		},
	},
	"big": {
		"name": "Go Big",
		"parameters": {
			"seed": 3,
			"size": Vector2i(20, 16),
			"powers": {"power_divine": {"charges": 3}},
			"tutorial": '\tOne triumph brings a greater demand.'
		}
	},
	"trig2": {
		"name": "Trig Harder",
		"parameters": {
			"seed": 11,
			"size": Vector2i(24, 16),
			"powers": {"power_divine": {"charges": 9}},
			"generation": {
				"method": "waveform",
				"constant": 0.5,
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
			'tutorial': '\tWake now from the dream. Look through eyes without veil ' +
				'at a night without breaking. The truth is out there, yet it does ' +
				'not wait for you. You may imagine it, but you only imagine the ' +
				'as it would appear to you. It is not the truth you leap for but the ' +
				'construction of tools for further delving. You do not explore uncharted ' +
				'depths, only retread with yet-unsullen feet the paths of those before.\n' +
				'\tKnow that tenacity is required to reach deeper in this page, and still ' +
				'deeper in this tome.'
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
			'tutorial': '\tAnd so you find the first complication, the weapon of devious forces you ' +
				'will face. This one can be named "delta", and it is unwise to look for the more true ' +
				'name. This one, presented with a triangle at the bottom of the column, indicates that ' +
				'the numbers in the header of that column do not correspond directly to what squares must be. ' +
				'Instead, the numbers speak of the differences between that column and the 4th column.'
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
			'tutorial': '\tComplications are the weapons you must be ever-aware of, lest they lead you to ruin. ' +
				'This one has two delta complications, with one referencing the other. Such a chain can cause ' +
				'strife.'
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
			'tutorial': "\tYet complications are not restricted to columns."
		}
	},
	"contradiction": {
		"name": "Contradiction",
		"parameters": {
			"seed": 6,
			"size": Vector2i(8, 8),
			"powers": {"power_divine": {"charges": 1}},
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
			],
			'tutorial': "\tComplications do not inhibit powers, and powers can " +
				'prove invaluable counters to their nefarious tricks.'
		}
	},
	"category": {
		"name": "Category",
		"parameters": {
			"seed": 19,
			"size": Vector2i(9, 9),
			"powers": {"power_divine": {"charges": 2}},
			"complications": [
				{
					"type": "delta",
					"subject_row": 7, # index, starts at 0
					"variable_row": 3,
				},
				{
					"type": "delta",
					"subject_row": 3,
					"variable_row": 5,
				}
			]
		}
	},
	"education": {
		"name": "Education",
		"parameters": {
			"seed": 20,
			"size": Vector2i(12, 9),
			"powers": {"power_divine": {"charges": 2}},
			"complications": [
				{
					"type": "delta",
					"subject_column": 0, # index, starts at 0
					"variable_column": 1,
				},
				{
					"type": "delta",
					"subject_column": 1,
					"variable_column": 2,
				},
				{
					"type": "delta",
					"subject_column": 2,
					"variable_column": 3,
				},
				{
					"type": "delta",
					"subject_column": 3,
					"variable_column": 4,
				},
				{
					"type": "delta",
					"subject_column": 4,
					"variable_column": 5,
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
				},
				{
					"type": "delta",
					"subject_row": 6,
					"variable_row": 12,
				}
			],
			"powers": {"power_divine": {"charges": 4}},
			'tutorial': 'Complications can result in a chain of dependencies, ' +
				'with one line requiring another that requires another that requires another. ' +
				'The only hope is to be found in what information can be gleaned from the opposing ' +
				'axis, trusting that there is enough information to find the answer.'
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
		"levels": ["intro", "basics", "didactic", "jack_and_hide", "elaborate", "trig", "ellipse", "locks", "response", "big", "trig2"],
		"title": "Chapter 1"
	},
	"chapter2": {
		"levels": ["discovery", "mistrust", "y_can_too", "contradiction", "category", "education", "tundra", "trig3"],
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
	if level_index == chapters[chapter_key].levels.size() - 1:
		var chapter_index = chapters.keys().find(chapter_key)
		if chapter_index == chapters.size() - 1:
			return ""
		else:
			var next_chapter_key = chapters.keys()[chapter_index + 1]
			return chapters[next_chapter_key].levels[0]
	return chapters[chapter_key]["levels"][level_index + 1]

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
	return chapters[chapter_key]["levels"][level_index - 1]

func has_prev_level(level: String) -> bool:
	return get_prev_level(level) != ""

func get_chapter_for_level(level: String) -> String:
	for chapter in chapters.keys():
		if level in chapters[chapter].levels:
			return chapter
	return ""
