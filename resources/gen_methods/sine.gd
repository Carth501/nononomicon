@tool
class_name Sine extends GenerationSettings

@export var sine_frequency: Vector2 = Vector2(0.0, 0.0)
@export var sine_offset: Vector2i = Vector2i(0.0, 0.0)

func _init() -> void:
	method_name = "sine"