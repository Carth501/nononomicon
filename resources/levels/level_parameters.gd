## The mechanical settings for a level.
##
## The definition of level mechanical values 
## for a level.
@tool
class_name LevelParameters extends Resource

## The size of the board in the level.
@export var size: Vector2i = Vector2i(6, 6)
## Features list for the level.
@export var features: FeaturesList = FeaturesList.new()
## List of powers accessible in the level.
@export var powers: PowersList = PowersList.new()
## The settings for level generation.
@export var generation: GenerationSettings = null
## The list of complications for the level.
@export var complications: Array[Complication] = []
## Locks to be applied to the level.
@export var locks: Array[Vector2i] = []
## List of hints available in the level.
@export var hints: Array[Hint] = []
## The tutorial text for the level.
@export_multiline var tutorial_text: String = ""
