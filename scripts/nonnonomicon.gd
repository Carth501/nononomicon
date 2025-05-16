class_name Nononomicon extends Control

var nonogram_board := preload("res://scenes/nonogram_board.tscn")
var index := preload("res://scenes/index.tscn")

@export var game_ui: GameUI
@export var board: NonogramBoard
@export var split_container: SplitContainer
@export var submission_button: Button
@export var index_page: Index
@export var next_button: Button
@export var prev_button: Button
@export var command_console: LineEdit
@export var drawer: Control
@export var descriptions: Control
@export var level_title: Label
@export var tutorial_text: RichTextLabel
@export var power_description_container: VBoxContainer
@export var power_description: RichTextLabel
@export var power_name: Label
@export var debug_menu: Control
@export var stack_container: ScrollContainer
@export var stack_list: VBoxContainer
@export var hint_button: Button
@export var tab_menus: TabContainer
@export var power_menu: PowersMenu
var drawer_width_percent := 0.7

func _ready():
	open_page("index")
	State.victory_changed.connect(set_next_enabled)
	State.level_changed.connect(check_page_buttons)
	State.level_changed.connect(set_level_title)
	State.level_changed.connect(set_tutorial_text)
	State.level_changed.connect(handle_features)
	State.level_changed.connect(set_hint_button)
	State.showing_power.connect(show_power_description)
	State.hiding_power.connect(hide_power_description)
	State.squares_correct.connect(handle_squares_correct)
	State.level_changed.connect(reset_submission_button)
	State.victory_changed.connect(reset_submission_button)
	State.level_changed.connect(toggle_power_menu)

func open_page(id: String):
	if (id == "index"):
		tutorial_text.text = ""
		split_container.hide()
		index_page.show()
		index_page.open_index()
		State.stop_timer()
	else:
		State.set_active_id(id)
		split_container.show()
		index_page.hide()
		set_tutorial_text()
		set_level_title()
		command_console.visible = false
		handle_features()
		reset_timer()

func check_page_buttons():
	set_next_button()
	set_next_enabled(State.get_victory_state())
	set_prev_button()

func cheat():
	State.cheat_reveal_all_squares()

func _on_submit_pressed() -> void:
	State.submit()

func _on_reset_pressed() -> void:
	State.reset()

func _on_clear_notes() -> void:
	State.clear_notes()

func _on_notes_switch_toggled(toggled_on: bool) -> void:
	State.set_notes_no_signal(toggled_on)

func _on_save_button_pressed() -> void:
	SaveManager.save("ManualSave")

func _on_next_button_pressed() -> void:
	State.next_level()
	reset_timer()

func _on_index_button_pressed() -> void:
	open_page("index")

func _on_prev_button_pressed() -> void:
	State.prev_level()
	reset_timer()

func set_next_button():
	next_button.visible = State.has_next_level()

func set_next_enabled(value: bool):
	next_button.disabled = !value

func set_prev_button():
	prev_button.visible = State.has_prev_level()

func toggle_command_console():
	command_console.visible = !command_console.visible
	command_console.grab_focus()

func _on_line_edit_text_submitted(new_text: String) -> void:
	State.interpret_command(new_text)
	if new_text == "show debug":
		show_debug_menu()
	elif new_text == "hide debug":
		hide_debug_menu()
	elif new_text == "show stack":
		toggle_stack_view(true)
	elif new_text == "hide stack":
		toggle_stack_view(false)
	command_console.clear()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Console"):
		toggle_command_console()

func set_level_title():
	var level_id = State.get_active_id()
	var level_name = LevelLibrary.get_level_name(level_id)
	var chapter_id = LevelLibrary.get_chapter_for_level(level_id)
	var chapter_name = LevelLibrary.get_chapter_name(chapter_id)
	level_title.text = chapter_name + " - " + level_name

func set_tutorial_text():
	var params = State.get_level_parameters()
	if (params.has("tutorial")):
		tutorial_text.text = params["tutorial"]
	else:
		tutorial_text.text = ""
	hide_power_description()

func handle_features():
	var params = State.get_level_parameters()
	if params.has("features"):
		game_ui.toggle_features(params["features"])
	else:
		game_ui.toggle_features({}) # triggers default feature set

func show_debug_menu():
	debug_menu.show()

func hide_debug_menu():
	debug_menu.hide()

func toggle_stack_view(value: bool):
	if (value):
		open_stack_view()
	else:
		close_stack_view()

func open_stack_view():
	stack_container.show()
	State.stack_changed.connect(update_stack_view)
	update_stack_view()

func close_stack_view():
	State.stack_changed.disconnect(update_stack_view)
	stack_container.hide()

func update_stack_view():
	for i in range(stack_list.get_child_count()):
		stack_list.get_child(i).queue_free()
	var stack = State.get_stack()
	var stack_index = State.get_stack_index()
	for i in range(stack.size()):
		var new_label = Label.new()
		if stack_index > i:
			new_label.add_theme_color_override("font_color", Color(0, 1, 0))
		else:
			new_label.add_theme_color_override("font_color", Color(.8, .8, .8))
		new_label.text = str(i) + ": " + str(stack[i])
		new_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		stack_list.add_child(new_label)


func _on_resized() -> void:
	split_container.split_offset = roundi(size.x * drawer_width_percent)

func on_drawer_dragged(value: int):
	drawer_width_percent = value / size.x

func show_power_description(power_id: String):
	var power_locale = PowersLibary.data[power_id]
	power_name.text = power_locale["power_name"]
	power_description.text = power_locale["power_description"]
	power_description_container.show()
	descriptions.hide()

func hide_power_description():
	power_description_container.hide()
	descriptions.show()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func set_hint_button():
	hint_button.visible = State.has_hints()

func _on_hint_button_pressed() -> void:
	State.request_hint()

func _on_undo_button_pressed() -> void:
	State.undo()

func _on_redo_button_pressed() -> void:
	State.redo()

func reset_timer():
	if !State.get_victory_state():
		State.start_timer()

func handle_squares_correct(value: bool):
	var params = State.get_level_parameters()
	var features = params.get("features", {})
	var submit_button_assist = features.get("submit_button_assist", false)
	if submit_button_assist:
		if value:
			submission_button.disabled = false
			submission_button.add_theme_color_override("font_color", Color("#82ed72"))
		else:
			submission_button.disabled = true
			submission_button.remove_theme_color_override("font_color")
	else:
		submission_button.disabled = false
		submission_button.remove_theme_color_override("font_color")

func reset_submission_button(_value: bool = false):
	var params = State.get_level_parameters()
	var features = params.get("features", {})
	var submit_button_assist = features.get("submit_button_assist", false)
	if submit_button_assist:
		var victory = State.get_victory_state()
		var correct_map = State.is_square_map_correct()
		var submit_ready = victory || !correct_map
		submission_button.disabled = submit_ready
		if submit_ready:
			submission_button.add_theme_color_override("font_color", Color("#82ed72"))
		else:
			submission_button.remove_theme_color_override("font_color")
	else:
		submission_button.disabled = false
		submission_button.remove_theme_color_override("font_color")

func toggle_power_menu():
	var has_powers = State.get_powers().size() > 0
	if has_powers:
		tab_menus.set_tab_disabled(0, false)
		tab_menus.current_tab = 0
	else:
		tab_menus.set_tab_disabled(0, true)
		tab_menus.current_tab = 1
