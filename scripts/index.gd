class_name Index extends Control

signal level_selected(id: String)
@export var list: VFlowContainer
@export var level_buttons: Array[Generic_Selection_Button]
var generic_button_scene := preload("res://scenes/generic_selection_button.tscn")
var chapters := {}
var levels := {}

func _ready() -> void:
	chapters = LevelLibrary.get_chapters()
	for chapter in chapters:
		var chapter_header = Label.new()
		chapter_header.text = chapters[chapter].title
		list.add_child(chapter_header)
		for level in LevelLibrary.get_levels(chapters[chapter].levels):
			var button := generic_button_scene.instantiate()
			button.set_value(level)
			list.add_child(button)
			button.thing_selected.connect(change_level)

func change_level(id: String):
	level_selected.emit(id)
