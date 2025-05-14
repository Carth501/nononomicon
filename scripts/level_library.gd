extends Node

var levels: Dictionary = {
	"intro": {
		"name": "Introduction",
		"parameters": {
			"seed": 1,
			"size": Vector2i(5, 5),
			"features":
				{
					"notes": false,
					"header_assist": State.HeaderAssistLevel.LENGTH,
				},
			"tutorial": '\tOne should not attempt these challenges without ambition. ' +
				'The secrets contained are encoded such that you will learn their purpose ' +
				'as you craft their construction.\n' +
				'\tVenture no further, however, if you find a piece of yourself missing. ' +
				'It cannot be stated plainly enough: there are evils in these pages, and ' +
				'greater evils to confront will be all that you earn.\n' +
				'\tTo begin, fill in the squares according to the numbers on the top and left. ' +
				'The numbers indicate how many squares are filled in a row or column, and the ' +
				'length of the segments they should make up.\n\t"3 1" means ' +
				'there is a segment of three filled squares followed by a lone filled square. ' +
				'Mark with left click, flag with the right. Submit when you believe yourself done.',
			"locks": [
				Vector2i(0, 0),
				Vector2i(1, 0),
				Vector2i(2, 0),
				Vector2i(4, 0),
				Vector2i(2, 3),
				Vector2i(4, 4),
				],
			"hints": [
				[
					Vector2i(0, 3),
					Vector2i(1, 3),
					Vector2i(2, 3),
					Vector2i(3, 3),
					Vector2i(4, 3),
				],
				[
					Vector2i(2, 1),
					Vector2i(4, 1),
				],
				[
					Vector2i(3, 2),
					Vector2i(3, 3),
					Vector2i(3, 4),
				]
			]
		}
	},
	"basics": {
		"name": "Basics",
		"parameters": {
			"seed": 2,
			"size": Vector2i(8, 8),
			"features":
				{
					"notes": false,
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"submit_button_assist": true,
				},
			"tutorial": '\tFor these simple trials, look for the zeros first, ' +
				'then search for the highest numbers.',
			"locks": [
				Vector2i(3, 5),
				Vector2i(6, 2),
				],
			"hints": [
				[
					Vector2i(0, 4),
					Vector2i(1, 4),
					Vector2i(2, 4),
					Vector2i(3, 4),
					Vector2i(4, 4),
					Vector2i(5, 4),
					Vector2i(6, 4),
					Vector2i(7, 4),
				],
				[
					Vector2i(3, 1),
					Vector2i(3, 2),
					Vector2i(3, 3),
					Vector2i(3, 4),
					Vector2i(3, 5),
					Vector2i(3, 6),
					Vector2i(3, 7),
				],
				[
					Vector2i(4, 1),
					Vector2i(4, 2),
					Vector2i(4, 3),
					Vector2i(4, 4),
					Vector2i(4, 5),
					Vector2i(4, 6),
					Vector2i(4, 7),
				],
				[
					Vector2i(5, 1),
					Vector2i(5, 2),
					Vector2i(5, 3),
					Vector2i(5, 4),
					Vector2i(5, 5),
					Vector2i(5, 6),
					Vector2i(5, 7),
				],
				[
					Vector2i(2, 1),
					Vector2i(2, 3),
					Vector2i(2, 4),
					Vector2i(2, 5),
					Vector2i(2, 7)
				],
				[
					Vector2i(0, 3),
					Vector2i(2, 3),
					Vector2i(3, 3),
					Vector2i(4, 3),
					Vector2i(5, 3),
					Vector2i(7, 3)
				],
				[
					Vector2i(0, 3),
					Vector2i(2, 3),
					Vector2i(3, 3),
					Vector2i(4, 3),
					Vector2i(5, 3),
					Vector2i(7, 3)
				],
				[
					Vector2i(3, 6),
					Vector2i(4, 6),
					Vector2i(5, 6),
					Vector2i(6, 6),
					Vector2i(7, 6),
				],
			]
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
			},
			"tutorial": '\tNotes are now available. Use them to speculate on the ' +
				'possibilities.',
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"notes": true,
					"submit_button_assist": true,
				},
		}
	},
	"orbitals": {
		"name": "Orbitals",
		"parameters": {
			"seed": 22,
			"size": Vector2i(9, 9),
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
							"frequency": Vector2(3, 3),
							"offset": Vector2(2, 2),
						}
					],
					[
						{
							"amplitude": 1,
							"frequency": Vector2(1.2, 1.2),
						}
					],
				]
			},
			"locks": [
				Vector2i(4, 4),
				]
		}
	},
	"jack_and_hide": {
		"name": "Jack and Hide",
		"parameters": {
			"seed": 14,
			"size": Vector2i(10, 7),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"notes": true,
					"submit_button_assist": true,
				},
			"randomness": 2,
			"tutorial": '\tDifferences in thought emerge, but the pattern may ' +
				'yet be preserved. These shapes are not harmless, but you are not their target.',
			"locks": [
				Vector2i(1, 4),
				Vector2i(3, 4),
				Vector2i(5, 4),
				Vector2i(7, 4),
				Vector2i(9, 4),
				Vector2i(8, 2),
				],
			"hints": [
				[
					Vector2i(1, 6),
					Vector2i(2, 6),
					Vector2i(3, 6),
					Vector2i(4, 6),
					Vector2i(5, 6),
					Vector2i(6, 6),
					Vector2i(7, 6),
					Vector2i(9, 6),
				],
				[
					Vector2i(1, 5),
					Vector2i(1, 6),
				],
				[
					Vector2i(2, 4),
					Vector2i(2, 5),
					Vector2i(2, 6),
				],
				[
					Vector2i(4, 3),
					Vector2i(4, 4),
					Vector2i(4, 5),
					Vector2i(4, 6),
				],
				[
					Vector2i(5, 0),
					Vector2i(5, 1),
					Vector2i(5, 2),
					Vector2i(5, 3),
					Vector2i(5, 4),
					Vector2i(5, 5),
					Vector2i(5, 6),
				],
				[
					Vector2i(6, 5),
					Vector2i(6, 6),
				],
			]
		}
	},
	"elaborate": {
		"name": "Elaborate",
		"parameters": {
			"seed": 16,
			"size": Vector2i(8, 8),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": false,
					"notes": true,
				},
			"randomness": 0.5,
			"generation": {
				"method": "sine",
				"frequency": Vector2(5, 5),
			},
			"hints": [
				[
					Vector2i(4, 0),
					Vector2i(4, 1),
					Vector2i(4, 2),
					Vector2i(4, 3),
					Vector2i(4, 4),
					Vector2i(4, 5),
					Vector2i(4, 6),
					Vector2i(4, 7),
				],
				[
					Vector2i(0, 3),
					Vector2i(1, 3),
					Vector2i(3, 3),
					Vector2i(4, 3),
					Vector2i(5, 3),
					Vector2i(7, 3),
				],
				[
					Vector2i(0, 4),
					Vector2i(2, 4),
					Vector2i(3, 4),
					Vector2i(4, 4),
					Vector2i(5, 4),
					Vector2i(7, 4),
				],
			]
		}
	},
	"trig": {
		"name": "Trigonometry",
		"parameters": {
			"seed": 10,
			"size": Vector2i(12, 12),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": true,
					"timer": true,
					"notes": true,
				},
			"randomness": 0.5,
			"generation": {
				"method": "sine",
				"frequency": Vector2(1.4, 1.2),
				"offset": Vector2(3, 3),
			},
			"tutorial": '\tA cage you have escape from, yet you are still here. ' +
				'This author may only wonder at your reasons, but do not err; ' +
				'this text will provide no gift nor boon.',
			"locks": [
				Vector2i(5, 5), ],
		}
	},
	"ellipse": {
		"name": "Ellipse",
		"parameters": {
			"seed": 7,
			"size": Vector2i(10, 6),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": true,
					"timer": true,
					"notes": true,
					"submit_button_assist": true,
				},
			"randomness": 0.3,
			"generation": {
				"method": "ellipse",
				"scale": Vector2(1.4, 1.2),
			}
		}
	},
	"painting": {
		"name": "Painting",
		"parameters": {
			"seed": 23, # shouldn't need a seed, but just in case
			"size": Vector2i(9, 9),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": true,
					"timer": true,
					"notes": true,
					"submit_button_assist": true,
				},
			"generation": {
				"method": "handcrafted",
				"marked": {
					0: [1, 0, 0, 0, 0, 0, 0, 1, 1],
					1: [1, 1, 0, 0, 0, 0, 0, 1, 0],
					2: [0, 0, 1, 0, 1, 0, 1, 1, 0],
					3: [1, 1, 0, 1, 0, 1, 0, 0, 0],
					4: [0, 0, 0, 0, 1, 0, 0, 1, 0],
					5: [0, 0, 1, 1, 0, 1, 1, 1, 0],
					6: [0, 0, 1, 0, 0, 0, 1, 0, 0],
					7: [0, 1, 0, 0, 1, 0, 0, 1, 1],
					8: [1, 1, 0, 0, 1, 0, 0, 0, 1]
				}
			},
			"locks": [
				Vector2i(0, 0),
				Vector2i(8, 0),
				Vector2i(0, 8),
				Vector2i(8, 8),
				Vector2i(4, 4),
				],
		}
	},
	"locks": {
		"name": "Locks",
		"parameters": {
			"seed": 17,
			"size": Vector2i(8, 8),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": true,
					"timer": true,
					"notes": true,
					"submit_button_assist": true,
				},
			"randomness": 3,
			"generation": {
				"method": "ellipse",
				"scale": Vector2(1, 1),
			},
			"locks": [
				Vector2i(6, 7),
				Vector2i(3, 5),
				Vector2i(4, 2),
				Vector2i(0, 1)],
		}
	},
	"magenta": {
		"name": "Magenta",
		"parameters": {
			"seed": 23,
			"size": Vector2i(9, 9),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": true,
					"timer": true,
					"notes": true,
				},
			"randomness": 3,
			"generation": {
				"method": "sine",
				"frequency": Vector2(1.15, 1.18),
				"offset": Vector2(6.21, 2.55),
				"constant": - 0.5
			},
			"locks": [
				Vector2i(0, 0),
				Vector2i(1, 1),
				Vector2i(2, 2),
				Vector2i(3, 3),
				Vector2i(4, 4),
				Vector2i(5, 5),
				Vector2i(0, 8),
			],
		}
	},
	"response": {
		"name": "Response",
		"parameters": {
			"seed": 18,
			"size": Vector2i(6, 6),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": true,
					"timer": true,
					"notes": true,
				},
			"override":
				{
					"marked": [
						Vector2i(2, 0),
					],
					"empty": [
						Vector2i(3, 3),
					]
				},
			"powers": {"power_lock": {"charges": 2}},
			"tutorial": '\tThe first power granted. Choosing where to apply locks can give ' +
				'sight into the truth, but it is not to be wasted. Use it with purpose, as ' +
				'it will not be replenished before the next page.'
		},
	},
	"big": {
		"name": "Go Big",
		"parameters": {
			"seed": 3,
			"size": Vector2i(19, 16),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": true,
					"timer": true,
					"notes": true,
				},
			"powers": {"power_lock": {"charges": 3}},
			"tutorial": '\tOne triumph brings a greater demand.',
			# "locks": [
			# 	Vector2i(0, 9),
			# 	Vector2i(0, 10),
			# 	Vector2i(1, 8),
			# 	Vector2i(1, 11),
			# 	Vector2i(2, 7),
			# 	Vector2i(2, 12),
			# 	Vector2i(3, 6),
			# 	Vector2i(3, 13),
			# 	Vector2i(4, 5),
			# 	Vector2i(4, 14),
			# 	Vector2i(5, 4),
			# 	Vector2i(5, 15),
			# 	Vector2i(6, 3),
			# 	Vector2i(7, 2),
			# 	Vector2i(8, 1),
			# 	Vector2i(9, 0),
			# 	Vector2i(10, 1),
			# 	Vector2i(11, 2),
			# 	Vector2i(12, 3),
			# 	Vector2i(13, 4),
			# 	Vector2i(13, 15),
			# 	Vector2i(14, 5),
			# 	Vector2i(14, 14),
			# 	Vector2i(15, 6),
			# 	Vector2i(15, 13),
			# 	Vector2i(16, 7),
			# 	Vector2i(16, 12),
			# 	Vector2i(17, 8),
			# 	Vector2i(17, 11),
			# 	Vector2i(18, 9),
			# 	Vector2i(18, 10),
			# 	]
		}
	},
	"trig2": {
		"name": "Trig Harder",
		"parameters": {
			"seed": 11,
			"size": Vector2i(24, 16),
			"features":
				{
					"header_assist": State.HeaderAssistLevel.LENGTH,
					"percent_marked": true,
					"timer": true,
					"notes": true,
				},
			"powers": {"power_lock": {"charges": 9}},
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
	"delta": {
		"name": "Delta",
		"parameters": {
			"seed": 26,
			"size": Vector2i(4, 4),
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
					"subject_column": 1,
					"variable_column": 2,
				}
			],
			'tutorial': '\tAnd so you find the first complication, the weapon of devious forces you ' +
				'will face. This one can be named "delta", and it is unwise to look for the more true ' +
				'name. This one, presented with a triangle at the bottom of the column, called "delta", ' +
				'indicates that ' +
				'the numbers in the header of that column do not correspond directly to what squares must be. ' +
				'Instead, the numbers speak of the differences between that column and the referenced column. \n' +
				'\tThe complication is displayed as a code, with the symbol indicating what the rules are, a ' +
				'"c" or an "r" indicating the reference pointing to a column or a row, respectively. Then a ' +
				'number, representing which column or row is referenced.',
			"hints": [
				[
					Vector2i(0, 1),
					Vector2i(1, 1),
					Vector2i(2, 1),
					Vector2i(3, 1),
				],
				[
					Vector2i(0, 3),
					Vector2i(1, 3),
					Vector2i(2, 3),
				],
				[
					Vector2i(1, 2),
					Vector2i(2, 2),
					Vector2i(3, 2),
				],
				[
					Vector2i(1, 0),
				],
			]
		}
	},
	"discovery": {
		"name": "Discovery",
		"parameters": {
			"seed": 4,
			"size": Vector2i(6, 6),
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
					"subject_column": 4,
					"variable_column": 3,
				}
			],
			"locks": [
				Vector2i(3, 2),
				Vector2i(4, 2),
				Vector2i(3, 3),
				Vector2i(4, 3),
				Vector2i(3, 4),
				Vector2i(4, 4),
			],
			"hints": [
				[
					Vector2i(0, 2),
					Vector2i(1, 2),
				],
				[
					Vector2i(2, 3),
					Vector2i(2, 4),
					Vector2i(2, 5),
				],
				[
					Vector2i(0, 4),
				],
				[
					Vector2i(4, 5),
					Vector2i(5, 5),
				],
				[
					Vector2i(5, 3),
				],
				[
					Vector2i(0, 1),
					Vector2i(0, 2),
				],
				[
					Vector2i(2, 1),
					Vector2i(3, 1),
				],
				[
					Vector2i(5, 0),
				]
			]
		}
	},
	"vermillion": {
		"name": "Vermillion",
		"parameters": {
			"seed": 24,
			"size": Vector2i(8, 8),
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
					"subject_column": 0,
					"variable_column": 1,
				}
			]
		}
	},
	"tea_tumbler": {
		"name": "Tea Tumbler",
		"parameters": {
			"seed": 25,
			"size": Vector2i(9, 9),
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
					"subject_column": 0,
					"variable_column": 1,
				}
			],
			"override":
				{
					"marked": [
						Vector2i(1, 1),
					],
					"empty": [
						Vector2i(0, 7),
					]
				},
		}
	},
	"onomonopia": {
		"name": "Onomonopia",
		"parameters": {
			"seed": 27,
			"size": Vector2i(9, 6),
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
					"subject_column": 4,
					"variable_column": 8,
				}
			],
		}
	},
	"positive": {
		"name": "Positive",
		"parameters": {
			"seed": 28,
			"size": Vector2i(9, 8),
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
					"subject_column": 3,
					"variable_column": 7,
				}
			],
			"override":
				{
					"marked": [
						Vector2i(0, 1),
					],
					"empty": [
						Vector2i(8, 1),
						Vector2i(5, 7),
					]
				},
		}
	},
	"mistrust": {
		"name": "Mistrust",
		"parameters": {
			"seed": 5,
			"size": Vector2i(8, 8),
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
	"breaking": {
		"name": "Breaking",
		"parameters": {
			"seed": 8,
			"size": Vector2i(8, 8),
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
var chapters: Dictionary = {
	"chapter1": {
		"levels": ["intro", "basics", "orbitals", "jack_and_hide",
			"elaborate", "trig", "ellipse", "didactic", "painting",
			"locks", "magenta", "response", "big", "trig2"],
		"title": "Chapter 1"
	},
	"chapter2": {
		"levels": ["delta", "discovery", "vermillion", "tea_tumbler",
			"onomonopia", "positive", "mistrust", "binding", "breaking", "something_deeper",
			"contradiction", "category", "education", "point_of_contact",
			"tundra", "professional", "oroboros", "trig3"],
		"title": "Chapter 2"
	},
	"chapter3": {
		"levels": ["variables"],
		"title": "Chapter 3"
	}
}

func get_chapters() -> Dictionary:
	return chapters

func get_levels(list: Array) -> Dictionary:
	var result = {}
	for level in list:
		if levels.has(level):
			result[level] = levels[level]
		elif Chapter3.levels.has(level):
			result[level] = Chapter3.levels[level]
	return result

func get_level(level: String) -> Dictionary:
	if levels.has(level):
		return levels[level]
	elif Chapter3.levels.has(level):
		return Chapter3.levels[level]
	else:
		return {}

func get_level_parameters(level: String) -> Dictionary:
	return get_level(level).get("parameters", {})

func level_exists(level: String) -> bool:
	if levels.has(level):
		return true
	elif Chapter3.levels.has(level):
		return true
	else:
		return false

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

func get_level_name(level: String) -> String:
	return get_level(level).name

func get_chapter_name(chapter: String) -> String:
	return chapters[chapter].title
