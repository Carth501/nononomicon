class_name Index extends Control

signal level_selected(id: String)
@export var list: VFlowContainer
var generic_button_scene := preload("res://scenes/generic_selection_button.tscn")
var chapters := {}
var level_buttons := {}
var chapters_buttons := {}

func _ready() -> void:
	chapters = LevelLibrary.get_chapters()
	for chapter in chapters:
		var chapter_header = Label.new()
		chapter_header.text = chapters[chapter].title
		list.add_child(chapter_header)
		chapters_buttons[chapter] = chapter_header
		chapter_header.hide()
		var chapter_levels = LevelLibrary.get_levels(chapters[chapter].levels)
		for level in chapter_levels:
			var button := generic_button_scene.instantiate()
			button.set_value(level)
			button.set_text(chapter_levels[level].name)
			list.add_child(button)
			button.thing_selected.connect(change_level)
			level_buttons[level] = button
			button.hide()

func change_level(id: String):
	level_selected.emit(id)

func open_index():
	chapters_buttons['chapter1'].show()
	level_buttons['intro'].show()
	var complete_levels = State.get_complete_levels()
	for level in complete_levels:
		if level_buttons.has(level):
			level_buttons[level].show()
			var next_level = LevelLibrary.get_next_level(level)
			if next_level != "":
				if level_buttons.has(next_level):
					level_buttons[next_level].show()
					check_chapter_unlocked(next_level)
				else:
					print("Next level not found in index: ", next_level)
		else:
			print("Level not found in index: ", level)

func check_chapter_unlocked(level_id: String):
	var chapter_id = LevelLibrary.get_chapter_for_level(level_id)
	if chapter_id != "":
		if chapters_buttons.keys().has(chapter_id):
			chapters_buttons[chapter_id].show()
		else:
			print("Chapter not found in index: ", chapter_id)
	else:
		print("Chapter ID not found for level: ", level_id)
