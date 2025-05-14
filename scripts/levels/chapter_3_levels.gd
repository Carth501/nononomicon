class_name Chapter3Levels extends Node

static var levels: Dictionary = {
	"variables": {
		"name": "Variables",
		"parameters": {
			"seed": 32,
			"size": Vector2i(5, 5),
			"features":
				{
					"notes": false,
					"header_assist": State.HeaderAssistLevel.LENGTH,
				},
			"tutorial": '\tA new obsticle needs introduction. Numbers in ' +
				'headers can be replaced with variables, obfuscating information ' +
				'vital. One must discover their values by other ways.',
			"complications": [
				{
					"type": "variable",
					"value": '4',
					"glyph": 'x',
				}
			],
				
		}
	}
}