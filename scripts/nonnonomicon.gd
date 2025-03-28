class_name Nononomicon extends Control

var nonogram_board := preload("res://scenes/nonogram_board.tscn")
var index := preload("res://scenes/index.tscn")
var pages := {}
@export var book: Control
@export var game_ui: Control
@export var next_button: Button
@export var prev_button: Button
@export var coords_display: Label

func _ready():
	open_page("index")
	State.victory.connect(set_next_enabled)
	State.level_changed.connect(check_page_buttons)
	State.coords_changed.connect(update_coords_display)

func open_page(id: String):
	if (id == "index"):
		game_ui.hide()
		if (!pages.has(id)):
			var page: Index = index.instantiate()
			pages[id] = page
			book.add_child(page)
			page.level_selected.connect(open_page)
	else:
		if (!pages.has(id)):
			State.set_active_id(id)
			var page: NonogramBoard = nonogram_board.instantiate()
			pages[id] = page
			check_page_buttons()
			page.prepare_board()
			book.add_child(page)
		game_ui.show()
	close_all_except(id)

func check_page_buttons():
	set_next_button()
	set_next_enabled()
	set_prev_button()

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
	print("Setting next button ", State.has_next_level())
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