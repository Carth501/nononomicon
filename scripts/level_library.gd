extends Node

var chapter1 = preload("res://data/content/chapters/Chapter1.tres")
var chapter2 = preload("res://data/content/chapters/Chapter2.tres")

var level_cache = {}

var levels: Dictionary = {
	"contradiction": {
		"name": "Contradiction",
		"parameters": {
			"seed": 29,
			"size": Vector2i(8, 8),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": true,
					"timer": true,
					"notes": true,
				},
			"powers": {"power_lock": {"charges": 1}},
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
	"something_deeper": {
		"name": "Something Deeper",
		"parameters": {
			"seed": 6,
			"size": Vector2i(10, 10),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": true,
					"timer": true,
					"notes": true,
				},
			"powers": {"power_lock": {"charges": 1}},
			"complications": [
				{
					"type": "delta",
					"subject_column": 7, # index, starts at 0
					"variable_column": 2,
				},
				{
					"type": "delta",
					"subject_column": 4,
					"variable_column": 5,
				}
			],
			'tutorial': "\tA shift comes, something breaks. A crack opens " +
				"that cannot be filled by what you know, so you must search " +
				"for something that can fit it. You have made a discovery, " +
				"and you could leave it alone, but you are still here, reading " +
				"this text.\n" +
				"\tWhy? Why do you wish to know these troubles? Why do you persist " +
				"when you could set this aside? This folly that should not have " +
				"been, this tome that should not have been bound, these designs " +
				"that tempt. This author shall never know the answer, but I was " +
				"cursed to write the question.\n" +
				"\tAnd now, I am surely gone, but if this is being read, then surely " +
				"something is the reader, and I am sorry to you that you found this."
		}
	},
	"category": {
		"name": "Category",
		"parameters": {
			"seed": 19,
			"size": Vector2i(9, 9),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": true,
					"timer": true,
					"notes": true,
				},
			"powers": {"power_lock": {"charges": 2}},
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
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"notes": true,
					"timer": true,
				},
			"powers": {"power_lock": {"charges": 2}},
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
			],
			'tutorial': "\tCircles in spirals in the squares. The void " +
				"is a threat to me. I cannot stand where it has is, but " +
				"it has been everywhere. Only here, for a moment, ephemeral, " +
				"can I breathe and believe. It will consume this place now, " +
				"and I will be off, always a moment ahead of the emptiness.\n" +
				"\tCan I keep it up? If I don't, I will be consumed. Will " +
				"that truely be worse?"
		}
	},
	"point_of_contact": {
		"name": "Point of Contact",
		"parameters": {
			"seed": 31,
			"size": Vector2i(6, 6),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"notes": true,
					"timer": true,
				},
			"powers": {"power_lock": {"charges": 2}},
			"generation": {
				"method": "waveform",
				"constant": 0,
				"series": [
					[
						{
							"amplitude": 0.5,
							"frequency": Vector2(5, 5),
							"offset": Vector2(-2, 0),
						}
					],
					[
						{
							"amplitude": 0.6,
							"frequency": Vector2(4, 4),
						}
					],
					[
						{
							"amplitude": 0.7,
							"frequency": Vector2(3, 3),
						}
					]
				]
			},
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
				},
			],
			'tutorial': "\tI cannot see what happened, yet behold " +
				"my breath and consume this fragment of myself again and again." +
				"I grow, yet growth is no escape, not this time. Perhaps you can, " +
				"but I cannot."
		}
	},
	"binding": {
		"name": "Binding",
		"parameters": {
			"seed": 31,
			"size": Vector2i(12, 12),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": true,
					"timer": true,
					"notes": true,
				},
			"complications": [
				{
					"type": "delta",
					"subject_column": 6,
					"variable_column": 5,
				},
				{
					"type": "delta",
					"subject_column": 5,
					"variable_column": 6,
				}
			],
			"generation": {
				"method": "waveform",
				"constant": - 0.1,
				"series": [
					[
						{
							"amplitude": 2,
							"frequency": Vector2(2, 5),
							"offset": Vector2(-2, 0),
						}
					],
					[
						{
							"amplitude": 2,
							"frequency": Vector2(5, 1.5),
						}
					],
				]
			},
			"powers": {"power_bind": {"charges": 1}},
			"override":
				{
					"marked": [
						Vector2i(1, 1),
						Vector2i(1, 7),
						Vector2i(6, 11),
						Vector2i(7, 11),
					],
					"empty": [
						Vector2i(5, 3),
						Vector2i(8, 9),
						Vector2i(8, 8),
						Vector2i(9, 9)
					]
				},
		}
	},
	"tundra": {
		"name": "Tundra",
		"parameters": {
			"seed": 9,
			"size": Vector2i(20, 16),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"notes": true,
					"timer": true,
				},
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
			"powers": {"power_lock": {"charges": 4}},
			'tutorial': '\tComplications can result in a chain of dependencies, ' +
				'with one line requiring another that requires another that requires another. ' +
				'The only hope is to be found in what information can be gleaned from the opposing ' +
				'axis, trusting that there is enough information to find the answer.'
		}
	},
	"professional": {
		"name": "Professional",
		"parameters": {
			"seed": 21,
			"size": Vector2i(9, 9),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"timer": true,
					"notes": true,
				},
			"generation": {
				"method": "waveform",
				"constant": - 0.5,
				"series": [
					[
						{
							"amplitude": 2,
							"frequency": Vector2(1.85, 1.25),
							"offset": Vector2(2, 2),
						},
						{
							"amplitude": 2,
							"frequency": Vector2(2.35, 1.95),
						}
					]
				]
			},
			"powers": {"power_lock": {"charges": 3}},
			"locks": [
				Vector2i(4, 0),
				Vector2i(3, 6),
				Vector2i(4, 6),
				Vector2i(0, 7),
				Vector2i(0, 8),
				Vector2i(1, 7),
				Vector2i(1, 8)],
			"complications": [
				{
					"type": "delta",
					"subject_row": 4,
					"variable_row": 5,
				}
			],
		}
	},
	"oroboros": {
		"name": "Oroboros",
		"parameters": {
			"seed": 30,
			"size": Vector2i(9, 9),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"notes": true,
					"timer": true,
				},
			"powers": {"power_lock": {"charges": 4}},
			"generation": {
				"method": "waveform",
				"constant": 1,
				"series": [
					[
						{
							"amplitude": 0.5,
							"frequency": Vector2(4, 4),
							"offset": Vector2(-2, 0),
						}
					],
					[
						{
							"amplitude": 0.6,
							"frequency": Vector2(3, 3),
						}
					],
					[
						{
							"amplitude": 0.7,
							"frequency": Vector2(2, 2),
						}
					]
				]
			},
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
				},
				{
					"type": "delta",
					"subject_column": 5,
					"variable_column": 6,
				},
				{
					"type": "delta",
					"subject_column": 6,
					"variable_column": 7,
				},
				{
					"type": "delta",
					"subject_column": 7,
					"variable_column": 8,
				},
				{
					"type": "delta",
					"subject_column": 8,
					"variable_column": 0,
				}
			],
			'tutorial': "\tI cannot see what happened, yet behold " +
				"my breath and consume this fragment of myself again and again." +
				"I grow, yet growth is no escape, not this time. Perhaps you can, " +
				"but I cannot."
		}
	},
	"trig3": {
		"name": "Big Trig",
		"parameters": {
			"seed": 12,
			"size": Vector2i(24, 16),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"timer": true,
					"notes": true,
				},
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

func get_chapters() -> Dictionary:
	var chapters = {
		chapter1.id: chapter1,
		chapter2.id: chapter2
	}
	return chapters

func get_levels(list: Array) -> Dictionary:
	var result = {}
	for level in list:
		result[level] = get_level(level)
	return result

func get_level(level_id: String) -> Level:
	if level_cache.has(level_id):
		return level_cache[level_id]
	var chapters = get_chapters()
	for chapter in chapters.keys():
		for level in chapters[chapter].levels:
			if level.id == level_id:
				level_cache[level_id] = level
				return level
	push_error("Level not found in any chapter: ", level_id)
	return null

func get_level_index(level_id: String) -> int:
	var level_id_list = get_level_id_list()
	return level_id_list.find(level_id)

func get_level_parameters(level: String) -> LevelParameters:
	return get_level(level).parameters

func level_exists(level: String) -> bool:
	var level_data = get_level(level)
	if level_data == null:
		return false
	else:
		return true

func get_level_id_list() -> Array:
	var level_id_list = []
	for chapter in get_chapters().keys():
		var chapter_levels = get_chapters()[chapter].levels
		for level in chapter_levels:
			level_id_list.append(level.id)
	return level_id_list

func get_next_level(level_id: String) -> String:
	var level_id_list = get_level_id_list()
	var level_index = level_id_list.find(level_id)
	if level_index == -1:
		return ""
	if level_index == level_id_list.size() - 1:
		return ""
	return level_id_list[level_index + 1]

func has_next_level(level: String) -> bool:
	return get_next_level(level) != ""

func get_prev_level(level_id: String) -> String:
	var level_id_list = get_level_id_list()
	var level_index = level_id_list.find(level_id)
	if level_index == -1:
		return ""
	if level_index == 0:
		return ""
	return level_id_list[level_index - 1]

func has_prev_level(level: String) -> bool:
	return get_prev_level(level) != ""

func get_chapter_for_level(level_id: String) -> String:
	var chapters = get_chapters()
	for chapter_id in chapters.keys():
		for level in chapters[chapter_id].levels:
			if level.id == level_id:
				return chapter_id
	return ""

func get_level_title(level: String) -> String:
	return get_level(level).title

func get_chapter_title(chapter: String) -> String:
	return get_chapters()[chapter].title

func filter_demo(level: Dictionary) -> Dictionary:
	return {
		"name": level.name,
		"not_in_demo": true
	}

func is_level_in_demo(level: String) -> bool:
	var chapter_id = get_chapter_for_level(level)
	return get_chapters()[chapter_id].in_demo

func get_level_available(level: String) -> bool:
	## this is where bonus level unlocking logic may go
	return is_level_in_demo(level)
