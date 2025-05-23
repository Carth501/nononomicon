class_name SaveLoadInterface extends Control

enum ManagerMode {SAVE, OVERWRITE, LOAD}

@export var button_container: VBoxContainer
var generic_selection_button := preload("res://scenes/generic_selection_button.tscn")
var buttons := {}
var current_mode: ManagerMode = ManagerMode.SAVE
var overwrite := false
@export var save_controls: Control
@export var overwrite_controls: Control
@export var load_controls: Control
@export var custom_name_line_edit: LineEdit

# func _ready():
# 	prepare_save_list()

func prepare_save_list():
	if buttons.size() > 0:
		for button in buttons.values():
			button.queue_free()
	buttons.clear()
	var save_files = SaveManager.get_save_file_list()
	for save_file in save_files:
		var button := generic_selection_button.instantiate()
		button.set_value(save_file)
		button_container.add_child(button)
		buttons[save_file] = button

func set_mode(mode: ManagerMode):
	current_mode = mode
	match current_mode:
		ManagerMode.SAVE:
			save_controls.visible = true
			load_controls.visible = false
			for button in buttons.values():
				button.thing_selected.connect(save_game)
		ManagerMode.LOAD:
			save_controls.visible = false
			load_controls.visible = true
			for button in buttons.values():
				button.thing_selected.connect(load_game)

func save_game(filename: String):
	SaveManager.save(filename)
	hide()

func load_game(filename: String):
	SaveManager.load(filename)
	get_tree().change_scene_to_file("res://scenes/nononomicon.tscn")
	hide()

func custom_save_name():
	SaveManager.save(custom_name_line_edit.text)
	hide()
