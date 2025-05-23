extends Node

var chapter1 = preload("res://data/content/chapters/Chapter1.tres")
var chapter2 = preload("res://data/content/chapters/Chapter2.tres")
var chapter3 = preload("res://data/content/chapters/Chapter3.tres")

var level_cache = {}

func get_chapters() -> Dictionary:
	var chapters = {
		chapter1.id: chapter1,
		chapter2.id: chapter2,
		chapter3.id: chapter3,
	}
	return chapters

func get_levels(list: Array) -> Dictionary:
	var result = {}
	for level in list:
		result[level] = get_level(level)
	return result

func get_level(level_id: String) -> Level:
	if level_cache.has(level_id):
		return level_cache[level_id]
	var chapters = get_chapters()
	for chapter in chapters.keys():
		for level in chapters[chapter].levels:
			if level.id == level_id:
				level_cache[level_id] = level
				return level
	push_error("Level not found in any chapter: ", level_id)
	return null

func get_level_index(level_id: String) -> int:
	var level_id_list = get_level_id_list()
	return level_id_list.find(level_id)

func get_level_parameters(level: String) -> LevelParameters:
	return get_level(level).parameters

func level_exists(level: String) -> bool:
	var level_data = get_level(level)
	if level_data == null:
		return false
	else:
		return true

func get_level_id_list() -> Array:
	var level_id_list = []
	for chapter in get_chapters().keys():
		var chapter_levels = get_chapters()[chapter].levels
		for level in chapter_levels:
			level_id_list.append(level.id)
	return level_id_list

func get_next_level(level_id: String) -> String:
	var level_id_list = get_level_id_list()
	var level_index = level_id_list.find(level_id)
	if level_index == -1:
		return ""
	if level_index == level_id_list.size() - 1:
		return ""
	return level_id_list[level_index + 1]

func has_next_level(level: String) -> bool:
	return get_next_level(level) != ""

func get_prev_level(level_id: String) -> String:
	var level_id_list = get_level_id_list()
	var level_index = level_id_list.find(level_id)
	if level_index == -1:
		return ""
	if level_index == 0:
		return ""
	return level_id_list[level_index - 1]

func has_prev_level(level: String) -> bool:
	return get_prev_level(level) != ""

func get_chapter_for_level(level_id: String) -> String:
	var chapters = get_chapters()
	for chapter_id in chapters.keys():
		for level in chapters[chapter_id].levels:
			if level.id == level_id:
				return chapter_id
	return ""

func get_level_title(level: String) -> String:
	return get_level(level).title

func get_chapter_title(chapter: String) -> String:
	return get_chapters()[chapter].title

func is_level_in_demo(level_id: String) -> bool:
	var chapter_id = get_chapter_for_level(level_id)
	return get_chapters()[chapter_id].in_demo

func get_level_available(level: String) -> bool:
	## this is where bonus level unlocking logic may go
	return is_level_in_demo(level) || !get_demo_mode()

func get_demo_mode() -> bool:
	return ProjectSettings.get_setting("application/config/is_demo")
