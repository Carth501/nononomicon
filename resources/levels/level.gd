## A level definition file.
## 
## It is used to store the level data.

class_name Level extends Resource

## The level settings.
@export var parameters: LevelParameters
## The conditions for the level, mostly used for secret levels.
## TODO
@export var conditions: Dictionary = {}