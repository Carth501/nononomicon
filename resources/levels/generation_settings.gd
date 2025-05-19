## The settings for level generation.
##
## The list of generation settings for levels.
@tool
class_name GenerationSettings extends Resource

@export var method_name: String = "default"
@export var gen_seed: int = randi()
@export var constant: float = 0.0
@export var randomness: float = 1.0
@export var overrides_marked: Array[Vector2i] = []
@export var overrides_empty: Array[Vector2i] = []
