class_name Chapter3Levels extends Node

static var levels: Dictionary = {
	"elbredth": {
		"name": "Elbredth",
		"parameters": {
			"seed": 33,
			"size": Vector2i(6, 6),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"notes": true,
				},
			"generation": {
				"method": "waveform",
				"constant": - 0.2,
				"series": [
					[
						{
							"amplitude": 1,
							"frequency": Vector2(4, 4),
							"offset": Vector2(1, 1),
						}
					],
					[
						{
							"amplitude": 1,
							"frequency": Vector2(1.5, 1.5),
						}
					],
				]
			},
			"complications": [
				{
					"type": "variable",
					"value": '1',
					"glyph": 'x',
				}
			],
		}
	},
	"lattice": {
		"name": "Lattice",
		"parameters": {
			"seed": 34,
			"size": Vector2i(8, 8),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"notes": true,
				},
			"generation": {
				"method": "waveform",
				"constant": - 0.2,
				"series": [
					[
						{
							"amplitude": 1,
							"frequency": Vector2(3, 3)
						}
					],
					[
						{
							"amplitude": 1,
							"frequency": Vector2(1.6, 1.6),
						}
					],
				]
			},
			"complications": [
				{
					"type": "variable",
					"value": '1',
					"glyph": 'x',
				}
			],
		}
	},
	"talisman": {
		"name": "Talisman",
		"parameters": {
			"seed": 35,
			"size": Vector2i(8, 8),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"notes": true,
				},
			"generation": {
				"method": "sine",
				"frequency": Vector2(8, 8),
			},
			"complications": [
				{
					"type": "variable",
					"value": '2',
					"glyph": 'x',
				}
			],
		}
	},
	"gem_of_the_dead": {
		"name": "Gem of the Dead",
		"parameters": {
			"seed": 36,
			"size": Vector2i(8, 8),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"notes": true,
					"timer": true,
				},
			"generation": {
				"method": "ellipse",
				"scale": Vector2(1.4, 1.2),
			},
			"complications": [
				{
					"type": "variable",
					"value": '3',
					"glyph": 'x',
				}
			],
			"override": {
				"marked": [
					Vector2i(0, 5),
					Vector2i(7, 4),
				],
				"empty": [
					Vector2i(3, 3),
					Vector2i(4, 4),
				]
			},
		}
	},
	"now_use_it": {
		"name": "Now Use It",
		"parameters": {
			"seed": 37,
			"size": Vector2i(9, 9),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"notes": true,
					"timer": true,
				},
			"generation": {
				"method": "handcrafted",
				"marked": {
					0: [0, 0, 1, 1, 1, 1, 1, 0, 0],
					1: [0, 1, 1, 0, 0, 0, 1, 1, 0],
					2: [1, 0, 1, 1, 0, 1, 1, 0, 1],
					3: [1, 0, 0, 1, 1, 1, 0, 0, 1],
					4: [1, 0, 1, 1, 0, 1, 1, 0, 1],
					5: [1, 1, 1, 1, 1, 1, 1, 1, 1],
					6: [1, 0, 0, 0, 1, 0, 0, 0, 1],
					7: [0, 1, 0, 0, 1, 0, 0, 1, 0],
					8: [0, 0, 1, 1, 1, 1, 1, 0, 0]
				}
			},
			"complications": [
				{
					"type": "variable",
					"value": '3',
					"glyph": 'x',
				},
				{
					"type": "variable",
					"value": '4',
					"glyph": 'y',
				}
			],
		}
	},
	
}