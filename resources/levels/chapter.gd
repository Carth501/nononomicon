## Chapter definition file.
##
## To be used to define the chapters in the game. Chapters organize levels, typically
## teaching the player one major new complication at a time, with some minor features,
## patters throughout.

class_name Chapter extends Resource

## Internal ID for the chapter. This is used to identify the chapter in the game.
@export var id: String
## The name of the chapter. This is used to display the chapter name in the game. Should be localized along the way.
@export var title: String = ""
## The list of levels in the chapter.
@export var levels: Array[Level] = []
## Only the first two chapters are in the demo, everything else should leave this as false.
@export var in_demo: bool = false