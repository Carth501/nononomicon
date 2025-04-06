class_name Nononomicon extends Control

var nonogram_board := preload("res://scenes/nonogram_board.tscn")
var index := preload("res://scenes/index.tscn")

@export var game_ui: GameUI
@export var board: NonogramBoard
@export var index_page: Control
@export var next_button: Button
@export var prev_button: Button
@export var coords_display: Label
@export var command_console: LineEdit
@export var drawer: Control
@export var communications: RichTextLabel

func _ready():
	open_page("index")
	State.victory.connect(set_next_enabled)
	State.level_changed.connect(check_page_buttons)
	State.level_changed.connect(set_tutorial_text)
	State.coords_changed.connect(update_coords_display)
	State.level_changed.connect(handle_features)

func open_page(id: String):
	if (id == "index"):
		communications.text = ""
		drawer.hide()
		board.hide()
		index_page.show()
	else:
		State.set_active_id(id)
		drawer.show()
		board.show()
		index_page.hide()
		set_tutorial_text()
		command_console.visible = false
		handle_features()

func check_page_buttons():
	set_next_button()
	set_next_enabled()
	set_prev_button()

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
	if Input.is_action_just_pressed("Console"):
		toggle_command_console()

func set_tutorial_text():
	var params = State.get_level_parameters()
	if (params.has("tutorial")):
		communications.text = params["tutorial"]
	else:
		communications.text = ""

func handle_features():
	var params = State.get_level_parameters()
	if params.has("features"):
		game_ui.toggle_features(params["features"])
	else:
		game_ui.toggle_features({}) # triggers default feature set
