class_name Nononomicon extends Control

var nonogram_board := preload("res://scenes/nonogram_board.tscn")
var index := preload("res://scenes/index.tscn")
var pages := {}
@export var book: Control
@export var game_ui: Control
@export var next_button: Button
@export var prev_button: Button
@export var coords_display: Label
@export var command_console: LineEdit
@export var main_view: Control
@export var drawer: Control
@export var communications: RichTextLabel

func _ready():
	open_page("index")
	State.victory.connect(set_next_enabled)
	State.level_changed.connect(check_page_buttons)
	State.level_changed.connect(set_tutorial_text)
	State.level_changed.connect(resize_book)
	State.coords_changed.connect(update_coords_display)

func open_page(id: String):
	if (id == "index"):
		game_ui.hide()
		communications.text = ""
		drawer.hide()
		if (!pages.has(id)):
			var page: Index = index.instantiate()
			pages[id] = page
			add_child(page)
			page.level_selected.connect(open_page)
	else:
		if (!pages.has(id)):
			State.set_active_id(id)
			var page: NonogramBoard = nonogram_board.instantiate()
			pages[id] = page
			check_page_buttons()
			page.prepare_board()
			book.add_child(page)
			resize_book()
		game_ui.show()
		drawer.show()
		set_tutorial_text()
		command_console.visible = false
	close_all_except(id)

func check_page_buttons():
	set_next_button()
	set_next_enabled()
	set_prev_button()

func resize_book():
	var board_size = State.get_size()
	var game_size = Vector2((board_size.x * 64) + 176 + 4, (board_size.y * 64) + 176 + 4)
	game_size = game_size.clamp(Vector2(0, 0), main_view.size)
	book.set_custom_minimum_size(game_size)

func close_all_except(id: String):
	for page_id in pages.keys():
		if (page_id == id):
			pages[page_id].show()
		else:
			pages[page_id].hide()

func cheat():
	State.cheat_reveal_all_squares()

func _on_submit_pressed() -> void:
	State.submit()

func _on_notes_switch_toggled(toggled_on: bool) -> void:
	State.set_notes_no_signal(toggled_on)

func _on_save_button_pressed() -> void:
	SaveManager.save("ManualSave")

func _on_next_button_pressed() -> void:
	State.next_level()

func _on_index_button_pressed() -> void:
	open_page("index")

func _on_prev_button_pressed() -> void:
	State.prev_level()

func set_next_button():
	next_button.visible = State.has_next_level()

func set_next_enabled():
	next_button.disabled = not State.get_victory_state()

func set_prev_button():
	prev_button.visible = State.has_prev_level()

func update_coords_display(new_coords: Vector2i):
	if (new_coords == Vector2i(-1, -1)):
		coords_display.text = ""
	else:
		coords_display.text = str(new_coords.x + 1) + ", " + str(new_coords.y + 1)

func toggle_command_console():
	command_console.visible = !command_console.visible

func _on_line_edit_text_submitted(new_text: String) -> void:
	State.interpret_command(new_text)
	command_console.clear()

func _process(_delta: float) -> void:
	if (game_ui.visible):
		if Input.is_action_just_pressed("Console"):
			toggle_command_console()

func set_tutorial_text():
	var params = State.get_level_parameters()
	if (params.has("tutorial")):
		communications.text = params["tutorial"]
	else:
		communications.text = ""