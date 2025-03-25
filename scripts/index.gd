class_name Index extends Control

signal level_selected(id: String)
@export var list: VFlowContainer
@export var level_buttons: Array[Generic_Selection_Button]
var chapters
var levels := []

func _ready() -> void:
	for button in level_buttons:
		button.thing_selected.connect(change_level)

func change_level(id: String):
	level_selected.emit(id)
