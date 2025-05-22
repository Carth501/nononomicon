@tool
class_name Waveform extends GenerationSettings

@export var waveform_series: Array[Wave] = []
@export var v2: bool = false

func _init() -> void:
	method_name = "waveform"