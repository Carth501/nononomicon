## A level definition file.
## 
## It is used to store the level data.

class_name Level extends Resource

## The internal ID for the level. This is used to identify the level in the game.
@export var id: String
## The string to identify the level to the player. Should be localized along the way.
@export var title: String = ""
## The level settings.
@export var parameters: LevelParameters
## The conditions for the level, mostly used for secret levels.
## TODO
@export var conditions: Dictionary = {}