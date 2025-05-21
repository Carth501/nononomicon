@tool
class_name VariableComplication extends Complication

@export var value: String
@export var glyph: String

func _init() -> void:
	type = "variable"