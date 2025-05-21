@tool
class_name DeltaComplication extends Complication

@export var delta_subject_column: int = -1
@export var delta_subject_row: int = -1
@export var delta_variable_column: int = -1
@export var delta_variable_row: int = -1

func _init() -> void:
	type = "delta"