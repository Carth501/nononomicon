@tool
class_name DeltaComplication extends Complication

@export var subject_index: int = -1
@export var subject_axis: State.Axis = State.Axis.X
@export var variable_index: int = -1
@export var variable_axis: State.Axis = State.Axis.X

func _init() -> void:
	type = "delta"